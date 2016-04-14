//
//  JJServiceFactory.m
//  ServiceFactory
//
//  Created by JJ on 11/29/15.
//  Copyright © 2015 JJ. All rights reserved.
//

#import "JJServiceFactory.h"

#import "JJServiceLog.h"
#import "JJService.h"

static NSString *JJLogNameServiceFactory = @"[ServiceFactory]";

@interface JJServiceFactory ()

@property (nonatomic, strong) NSMutableDictionary *serviceContainer;

@end

@implementation JJServiceFactory

#pragma mark - public

+ (instancetype)sharedServiceFactory
{
    static dispatch_once_t once;
    static JJServiceFactory *instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)serviceWithServiceName:(NSString *)serviceName_
{
    NSParameterAssert(serviceName_);
    
    JJService *service = self.serviceContainer[serviceName_];
    if (service)
    {
        return service;
    }
    
    JJServiceLog(@"%@ load service: %@", JJLogNameServiceFactory, serviceName_);
    
    [self JJ_unloadUnneededService];
    
    service = [[NSClassFromString(serviceName_) alloc] init];
    [service serviceWillLoad];
    self.serviceContainer[serviceName_] = service;
    [service serviceDidLoad];
    
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
    
    JJServiceLog(@"%@ unload service: %@, force: %d", JJLogNameServiceFactory, serviceName_, isForceUnload_);
    
    JJService *service = self.serviceContainer[serviceName_];
    
    if (!isForceUnload_ && ![service needUnloading])
    {
        return;
    }
    
    [service serviceWillUnload];
    [self.serviceContainer removeObjectForKey:serviceName_];
    [service serviceDidUnload];
}

#pragma mark - private

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
