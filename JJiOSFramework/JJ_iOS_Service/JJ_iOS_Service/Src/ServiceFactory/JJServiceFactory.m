//
//  JJServiceFactory.m
//  ServiceFactory
//
//  Created by JJ on 11/29/15.
//  Copyright © 2015 JJ. All rights reserved.
//

#import "JJServiceFactory.h"

#import <libkern/OSAtomic.h>

#import "JJServiceLog.h"
#import "JJService.h"

static NSString *JJLogNameServiceFactory = @"[ServiceFactory]";

@interface JJServiceFactory ()

@property (nonatomic, strong) NSMutableDictionary *serviceContainer;
@property (nonatomic, assign) OSSpinLock operateLock;

@end

@implementation JJServiceFactory

#pragma mark - public

+ (instancetype)sharedServiceFactory
{
    static dispatch_once_t once;
    static JJServiceFactory *instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
        instance.operateLock = OS_SPINLOCK_INIT;
    });
    return instance;
}

- (id)serviceWithServiceName:(NSString *)serviceName_
{
    NSParameterAssert(serviceName_);
    
    [self __beginOperateLock];
    
    JJService *service = self.serviceContainer[serviceName_];
    if (service)
    {
        JJServiceLog(@"%@ get service:%@, \nservice container: \n%@", JJLogNameServiceFactory, serviceName_, self.serviceContainer);
        
        [self __endOperateLock];
        return service;
    }
    
    JJServiceLog(@"%@ load service: %@", JJLogNameServiceFactory, serviceName_);
    
    [self JJ_unloadUnneededService];
    
    service = [[NSClassFromString(serviceName_) alloc] init];
    [service serviceWillLoad];
    self.serviceContainer[serviceName_] = service;
    [service serviceDidLoad];
    
    [self __endOperateLock];
    
    return service;
}

- (void)unloadServiceWithServiceName:(NSString *)serviceName_
{
    [self unloadServiceWithServiceName:serviceName_ isForceUnload:NO];
}

- (void)unloadServiceWithServiceName:(NSString *)serviceName_
                       isForceUnload:(BOOL)isForceUnload_
{
    NSParameterAssert(serviceName_);
    
    [self __beginOperateLock];
    
    JJServiceLog(@"%@ unload service: %@, force: %d", JJLogNameServiceFactory, serviceName_, isForceUnload_);
    
    JJService *service = self.serviceContainer[serviceName_];
    
    if (!isForceUnload_ && ![service needUnloading])
    {
        [self __endOperateLock];
        return;
    }
    
    [service serviceWillUnload];
    [self.serviceContainer removeObjectForKey:serviceName_];
    [service serviceDidUnload];
    
    [self __endOperateLock];
}

#pragma mark - private

- (void)__beginOperateLock
{
    OSSpinLockLock(&_operateLock);
}

- (void)__endOperateLock
{
    OSSpinLockUnlock(&_operateLock);
}

- (void)JJ_unloadUnneededService
{
    NSMutableArray *unloadingKeys = [NSMutableArray array];
    
    [self.serviceContainer enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, JJService * _Nonnull obj, BOOL * _Nonnull stop)
    {
        if ([obj needUnloading])
        {
            [unloadingKeys addObject:key];
        }
    }];
    
    JJServiceLog(@"%@ unload unneeded service, \nservice container: \n%@, \nremove services: \n%@", JJLogNameServiceFactory, self.serviceContainer, unloadingKeys);
    
    [self.serviceContainer removeObjectsForKeys:unloadingKeys];
}

#pragma mark - getter and setter

- (NSMutableDictionary *)serviceContainer
{
    if (_serviceContainer)
    {
        return _serviceContainer;
    }
    
    _serviceContainer = [NSMutableDictionary dictionary];
    return _serviceContainer;
}

@end
