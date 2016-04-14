//
//  JJTestWeatherFeatureSet.m
//  JJ_iOS_Service
//
//  Created by JJ on 4/14/16.
//  Copyright © 2016 JJ. All rights reserved.
//

#import "JJTestWeatherFeatureSet.h"

#import "JJWeatherRequest.h"
#import "JJWeatherModel.h"
#import "JJTestService.h"

@implementation JJTestWeatherFeatureSet

- (void)requestWeather:(void (^)(JJWeatherModel *, NSString *, id))networkSuccessResponse_
   networkFailResponse:(void (^)(NSError *, id))networkFailResponse_
{
    [self requestWithParameters:nil requestClass:[JJWeatherRequest class] requestType:JJTestServiceRequestTypeWeather modelClass:[JJWeatherModel class] isSaveToDisk:YES networkSuccessResponse:networkSuccessResponse_ networkFailResponse:networkFailResponse_];
}

@end
