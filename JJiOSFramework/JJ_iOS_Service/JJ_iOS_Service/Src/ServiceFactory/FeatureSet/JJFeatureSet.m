//
//  JJFeatureSet.m
//  JJ_iOS_Service
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
       successAction:(void (^)(id object, NSString *responseString, JJBaseRequest *request))successAction_
          failAction:(void (^)(NSError *error, JJBaseRequest *request))failAction_
{
    [self.service recordRequestFinishCount:-1];
    
    [request_ startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request)
     {
         id object = [request_ currentResponseModel];
         
         if (successAction_)
         {
             successAction_(object, request_.responseString, request_);
         }
         
         [self.service serviceResponseCallBack:requestType_
                                     parameter:parameter_
                                       success:YES
                                        object:object
                                responseString:request_.responseString
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
                                responseString:nil
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

- (void)startGPRequest:(JJBaseRequest *)request_
             otherInfo:(id)otherInfo_
         successAction:(void (^)(id object, NSString *responseString, JJBaseRequest *request))successAction_
            failAction:(void (^)(NSError *error, JJBaseRequest *request))failAction_
{
    [self startRequest:request_
           requestType:request_.operationType
             parameter:request_.parameters
             otherInfo:otherInfo_
         successAction:(void (^)(id object, NSString *responseString, JJBaseRequest *request))successAction_
            failAction:(void (^)(NSError *error, JJBaseRequest *request))failAction_];
}

- (void)startGPRequest:(JJBaseRequest *)request_
             otherInfo:(id)otherInfo_
{
    [self startGPRequest:request_
               otherInfo:otherInfo_
           successAction:nil
              failAction:nil];
}

- (id)cacheModelWithParameters:(NSDictionary *)parameters_
                  requestClass:(Class)requestClass_
                   requestType:(NSString *)requestType_
                    modelClass:(Class)modelClass_
                  isSaveToDisk:(BOOL)isSaveToDisk_
{
    JJBaseRequest *request = [self _requestWithParameters:parameters_ requestClass:requestClass_ requestType:requestType_ modelClass:modelClass_ isSaveToDisk:isSaveToDisk_];
    id model = [request cacheModel];
    return model;
}

- (void)requestWithParameters:(NSDictionary *)parameters_
                 requestClass:(Class)requestClass_
                  requestType:(NSString *)requestType_
                   modelClass:(Class)modelClass_
                 isSaveToDisk:(BOOL)isSaveToDisk_
       networkSuccessResponse:(void(^)(id object, NSString *responseString, id otherinfo))networkSuccessResponse_
          networkFailResponse:(void (^)(NSError *error, id otherinfo))networkFailResponse_
{
    JJBaseRequest *request = [self _requestWithParameters:parameters_ requestClass:requestClass_ requestType:requestType_ modelClass:modelClass_ isSaveToDisk:isSaveToDisk_];
    request.networkSuccessResponse = networkSuccessResponse_;
    request.networkFailResponse = networkFailResponse_;
    
    [self startGPRequest:request otherInfo:nil];
}

- (void)actionAfterLogin
{
    
}

- (void)actionAfterLogout
{
    
}

#pragma mark - private

- (JJBaseRequest *)_requestWithParameters:(NSDictionary *)parameters_
                               requestClass:(Class)requestClass_
                                requestType:(NSString *)requestType_
                                 modelClass:(Class)modelClass_
                               isSaveToDisk:(BOOL)isSaveToDisk_
{
    JJBaseRequest *request = [[requestClass_ alloc] initWithOperationType:requestType_ parameters:parameters_ modelClass:modelClass_ isSaveToMemory:NO isSaveToDisk:isSaveToDisk_];
    return request;
}

@end
