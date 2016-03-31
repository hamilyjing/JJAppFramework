//
//  JJFeatureSet.m
//  YiZhangTong_iOS_Service
//
//  Created by JJ on 12/2/15.
//  Copyright © 2015 JJ. All rights reserved.
//

#import "JJFeatureSet.h"

#import "JJBaseRequest.h"
#import "JJService.h"

@implementation JJFeatureSet

#pragma mark - life cycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public

+ (NSString *)featureSetName
{
    return NSStringFromClass(self.class);
}

- (void)featureSetWillLoad
{
    
}

- (void)featureSetDidLoad
{
    
}

- (void)featureSetWillUnload
{
    
}

- (void)featureSetDidUnload
{
    
}

- (void)startRequest:(JJBaseRequest *)request_
         requestType:(NSString *)requestType_
           parameter:(id)parameter_
           otherInfo:(id)otherInfo_
       successAction:(void (^)(id object, JJBaseRequest *request))successAction_
          failAction:(void (^)(NSError *error, JJBaseRequest *request))failAction_
{
    [self.service recordRequestFinishCount:-1];
    
    [request_ startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request)
     {
         id object = [request_ currentResponseModel];
         
         if (successAction_)
         {
             successAction_(object, request_);
         }
         
         [self.service serviceResponseCallBack:requestType_
                                     parameter:parameter_
                                       success:YES
                                        object:object
                                     otherInfo:otherInfo_
                        networkSuccessResponse:request_.networkSuccessResponse
                           networkFailResponse:request_.networkFailResponse];
         
     }failure:^(YTKBaseRequest *request)
     {
         id object = request_.requestOperation.error;
         
         if (failAction_)
         {
             failAction_(object, request_);
         }
         
         [self.service serviceResponseCallBack:requestType_
                                     parameter:parameter_
                                       success:NO
                                        object:object
                                     otherInfo:otherInfo_
                        networkSuccessResponse:request_.networkSuccessResponse
                           networkFailResponse:request_.networkFailResponse];
     }];
}

- (void)startRequest:(JJBaseRequest *)request_
         requestType:(NSString *)requestType_
           parameter:(id)parameter_
           otherInfo:(id)otherInfo_
{
    [self startRequest:request_
           requestType:requestType_
             parameter:parameter_
             otherInfo:otherInfo_
         successAction:nil
            failAction:nil];
}

- (void)actionAfterLogin
{
    
}

- (void)actionAfterLogout
{
    
}

@end
