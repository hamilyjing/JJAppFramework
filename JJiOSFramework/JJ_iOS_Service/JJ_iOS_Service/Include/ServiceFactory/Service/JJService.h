//
//  JJService.h
//  ServiceFactory
//
//  Created by JJ on 11/29/15.
//  Copyright © 2015 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class JJService;

// login
extern NSString *JJLoginServiceLoginSuccessNotification;

// logout
extern NSString *JJLoginServiceServerForceLogoutNotification;
extern NSString *JJLoginServiceLogOutNotification;

@protocol JJServiceDelegate <NSObject>

@optional

- (void)networkSuccessResponse:(JJService *)service
                   requestType:(NSString *)requestType
                     parameter:(id)parameter
                        object:(id)object
                responseString:(NSString *)responseString
                     otherInfo:(id)otherInfo;

- (void)networkFailResponse:(JJService *)service
                requestType:(NSString *)requestType
                  parameter:(id)parameter
                      error:(id)error
                  otherInfo:(id)otherInfo;

@end

@interface JJService : NSObject

/**
 *  Return the class name of service, subClass must overwrite.
 *
 *  @return Service class name.
 */
+ (NSString *)serviceName;

/**
 *  Judge if service will be unloaded if no user used it.
 *
 *  @return YES: need
 */
- (BOOL)needUnloading;

- (void)serviceWillLoad;
- (void)serviceDidLoad;

- (void)serviceWillUnload;
- (void)serviceDidUnload;

- (void)addDelegate:(id<JJServiceDelegate>)delegate;
- (void)removeDelegate:(id<JJServiceDelegate>)delegate;
- (void)removeAllDelegate;

- (id)featureSetWithFeatureSetName:(NSString *)featureSetName;

- (void)unloadFeatureSetWithFeatureSetName:(NSString *)featureSetName;

- (void)serviceResponseCallBack:(NSString *)requestType
                      parameter:(id)parameter
                        success:(BOOL)success
                         object:(id)object
                 responseString:(NSString *)responseString
                      otherInfo:(id)otherInfo
         networkSuccessResponse:(void (^)(id object, NSString *responseString, id otherInfo))networkSuccessResponse
            networkFailResponse:(void (^)(id error, id otherInfo))networkFailResponse;

- (void)postServiceResponseNotification:(NSString *)requestType
                              parameter:(id)parameter
                                success:(BOOL)success
                                 object:(id)object
                         responseString:(NSString *)responseString
                              otherInfo:(id)otherInfo;

- (void)actionAfterLogin;
- (void)actionAfterLogout;

- (void)recordRequestFinishCount:(NSInteger)count;

@end

#pragma mark - Feature Set Macro

#define JJ_SERVICE_FEATURE_SET(serviceObj, featureSet) ((featureSet *)[serviceObj featureSetWithFeatureSetName:[featureSet featureSetName]])

#define JJ_SERVICE_UNLOAD_FEATURE_SET(serviceObj, featureSet) [serviceObj unloadFeatureSetWithFeatureSetName:[featureSet featureSetName]]
