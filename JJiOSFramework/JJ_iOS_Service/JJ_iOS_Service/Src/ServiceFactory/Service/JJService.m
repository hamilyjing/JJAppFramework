//
//  JJService.m
//  ServiceFactory
//
//  Created by JJ on 11/29/15.
//  Copyright © 2015 JJ. All rights reserved.
//

#import "JJService.h"

#import <libkern/OSAtomic.h>

#import "JJFeatureSet.h"
#import "JJNSMutableDictionaryHelper.h"
#import "JJServiceNotification.h"

// login
NSString *JJLoginServiceLoginSuccessNotification = @"JJLoginServiceLoginSuccessNotification";

// logout
NSString *JJLoginServiceServerForceLogoutNotification = @"JJLoginServiceServerForceLogoutNotification";
NSString *JJLoginServiceLogOutNotification = @"JJLoginServiceLogOutNotification";

@interface JJService ()

@property (nonatomic, strong) NSMutableDictionary *featureSetContainer;

@property (nonatomic, strong) NSHashTable *delegateList;

@property (nonatomic, assign) OSSpinLock spinLock;
@property (nonatomic, assign) NSInteger requestFinishCount;

@end

@implementation JJService

#pragma mark - life cycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.spinLock = OS_SPINLOCK_INIT;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessNotification:) name:JJLoginServiceLoginSuccessNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotification:) name:JJLoginServiceServerForceLogoutNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotification:) name:JJLoginServiceLogOutNotification object:nil];
    }
    return self;
}

#pragma mark - public

- (NSString *)description
{
    NSString *string = [NSString stringWithFormat:@"requestFinishCount: %ld, delegateList: %@", self.requestFinishCount, self.delegateList];
    return string;
}

+ (NSString *)serviceName
{
    return NSStringFromClass(self.class);
}

- (BOOL)needUnloading
{
    BOOL need = ([self JJ_isEmpty:self.delegateList] && (0 == self.requestFinishCount));
    return need;
}

- (void)serviceWillLoad
{
    
}

- (void)serviceDidLoad
{
    
}

- (void)serviceWillUnload
{
    
}

- (void)serviceDidUnload
{
    
}

- (void)addDelegate:(id<JJServiceDelegate>)delegate_
{
    if ([NSThread isMainThread])
    {
        [self.delegateList addObject:delegate_];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegateList addObject:delegate_];
        });
    }
}

- (void)removeDelegate:(id<JJServiceDelegate>)delegate_
{
    if ([NSThread isMainThread])
    {
        [self.delegateList removeObject:delegate_];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegateList removeObject:delegate_];
        });
    }
}

- (void)removeAllDelegate
{
    if ([NSThread isMainThread])
    {
        self.delegateList = nil;;
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.delegateList = nil;
        });
    }
}

- (id)featureSetWithFeatureSetName:(NSString *)featureSetName_
{
    NSParameterAssert(featureSetName_);
    
    JJFeatureSet *featureSet = self.featureSetContainer[featureSetName_];
    if (featureSet)
    {
        return featureSet;
    }
    
    featureSet = [[NSClassFromString(featureSetName_) alloc] init];
    featureSet.service = self;
    [featureSet featureSetWillLoad];
    self.featureSetContainer[featureSetName_] = featureSet;
    [featureSet featureSetDidLoad];
    
    return featureSet;
}

- (void)unloadFeatureSetWithFeatureSetName:(NSString *)featureSetName_
{
    NSParameterAssert(featureSetName_);
    
    JJFeatureSet *featureSet = self.featureSetContainer[featureSetName_];
    [featureSet featureSetWillUnload];
    [self.featureSetContainer removeObjectForKey:featureSetName_];
    [featureSet featureSetDidUnload];
}

- (void)serviceResponseCallBack:(NSString *)requestType_
                      parameter:(id)parameter_
                        success:(BOOL)success_
                         object:(id)object_
                 responseString:(NSString *)responseString_
                      otherInfo:(id)otherInfo_
         networkSuccessResponse:(void (^)(id object, NSString *responseString, id otherInfo))networkSuccessResponse_
            networkFailResponse:(void (^)(id error, id otherInfo))networkFailResponse_
{
    NSHashTable *delegateListCopy = [self.delegateList copy];
    
    if (success_)
    {
        if (networkSuccessResponse_)
        {
            networkSuccessResponse_(object_, responseString_, otherInfo_);
        }
        
        for (id<JJServiceDelegate> delegate in delegateListCopy)
        {
            if ([delegate respondsToSelector:@selector(networkSuccessResponse:requestType:parameter:object:otherInfo:)])
            {
                [delegate networkSuccessResponse:self
                                     requestType:requestType_
                                       parameter:parameter_
                                          object:object_
                                  responseString:responseString_
                                       otherInfo:otherInfo_];
            }
        }
    }
    else
    {
        if (networkFailResponse_)
        {
            networkFailResponse_(object_, otherInfo_);
        }
        
        for (id<JJServiceDelegate> delegate in delegateListCopy)
        {
            if ([delegate respondsToSelector:@selector(networkFailResponse:requestType:parameter:error:otherInfo:)])
            {
                [delegate networkFailResponse:self
                                  requestType:requestType_
                                    parameter:parameter_
                                        error:object_
                                    otherInfo:otherInfo_];
            }
        }
    }
    
    [self postServiceResponseNotification:requestType_
                                parameter:parameter_
                                  success:success_
                                   object:object_
                           responseString:responseString_
                                otherInfo:otherInfo_];
    
    [self recordRequestFinishCount:1];
}

- (void)postServiceResponseNotification:(NSString *)requestType_
                              parameter:(id)parameter_
                                success:(BOOL)success_
                                 object:(id)object_
                         responseString:(NSString *)responseString_
                              otherInfo:(id)otherInfo_
{
    NSString *notificationName = [NSString stringWithFormat:@"%@_%@", NSStringFromClass([self class]), requestType_];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [JJNSMutableDictionaryHelper mDictionary:userInfo setObj:self forKey:JJServiceNotificationKeyService];
    [JJNSMutableDictionaryHelper mDictionary:userInfo setObj:parameter_ forKey:JJServiceNotificationKeyParameter];
    [JJNSMutableDictionaryHelper mDictionary:userInfo setObj:@(success_) forKey:JJServiceNotificationKeySuccess];
    [JJNSMutableDictionaryHelper mDictionary:userInfo setObj:object_ forKey:JJServiceNotificationKeyObject];
    [JJNSMutableDictionaryHelper mDictionary:userInfo setObj:responseString_ forKey:JJServiceNotificationKeyResponseString];
    [JJNSMutableDictionaryHelper mDictionary:userInfo setObj:otherInfo_ forKey:JJServiceNotificationKeyOtherInfo];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:notificationName
                      object:nil
                    userInfo:userInfo];
}

- (void)actionAfterLogin
{
    for (JJFeatureSet *featureSet in [self.featureSetContainer allValues])
    {
        [featureSet actionAfterLogin];
    }
}

- (void)actionAfterLogout
{
    for (JJFeatureSet *featureSet in [self.featureSetContainer allValues])
    {
        [featureSet actionAfterLogout];
    }
}

- (void)recordRequestFinishCount:(NSInteger)count_
{
    OSSpinLockLock(&_spinLock);
    
    self.requestFinishCount = self.requestFinishCount + count_;
    
    OSSpinLockUnlock(&_spinLock);
}

#pragma mark - notification

- (void)loginSuccessNotification:(NSNotification *)notification_
{
    [self actionAfterLogin];
}

- (void)logoutNotification:(NSNotification *)notification_
{
    [self actionAfterLogout];
}

#pragma mark - private

- (BOOL)JJ_isEmpty:(NSHashTable *)hashTable
{
    NSEnumerator *enumerator = [hashTable objectEnumerator];
    id value;
    
    while ((value = [enumerator nextObject]))
    {
        return NO;
    }
    
    return YES;
}

#pragma mark getter and setter

- (NSMutableDictionary *)featureSetContainer
{
    if (_featureSetContainer)
    {
        return _featureSetContainer;
    }
    
    _featureSetContainer = [NSMutableDictionary dictionary];
    return _featureSetContainer;
}

- (NSHashTable *)delegateList
{
    if (_delegateList)
    {
        return _delegateList;
    }
    
    _delegateList = [NSHashTable weakObjectsHashTable];
    return _delegateList;
}

@end
