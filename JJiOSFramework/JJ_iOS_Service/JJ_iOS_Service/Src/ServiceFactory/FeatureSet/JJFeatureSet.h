//
//  JJFeatureSet.h
//  YiZhangTong_iOS_Service
//
//  Created by JJ on 12/2/15.
//  Copyright © 2015 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JJBaseRequest;
@class JJService;

@interface JJFeatureSet : NSObject

@property (nonatomic, weak) JJService *service;

/**
 *  Return the class name of feature set, subClass must overwrite.
 *
 *  @return Feature set class name.
 */
+ (NSString *)featureSetName;

- (void)featureSetWillLoad;
- (void)featureSetDidLoad;

- (void)featureSetWillUnload;
- (void)featureSetDidUnload;

- (void)startRequest:(JJBaseRequest *)request
         requestType:(NSString *)requestType
           parameter:(id)parameter
           otherInfo:(id)otherInfo
       successAction:(void (^)(id object, JJBaseRequest *request))successAction
          failAction:(void (^)(NSError *error, JJBaseRequest *request))failAction;

- (void)startRequest:(JJBaseRequest *)request
         requestType:(NSString *)requestType
           parameter:(id)parameter
           otherInfo:(id)otherInfo;

- (void)actionAfterLogin;
- (void)actionAfterLogout;

@end
