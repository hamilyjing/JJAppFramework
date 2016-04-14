//
//  JJTestService.m
//  JJ_iOS_Service
//
//  Created by JJ on 4/14/16.
//  Copyright © 2016 JJ. All rights reserved.
//

#import "JJTestService.h"

#import "JJService.h"
#import "JJTestWeatherFeatureSet.h"

NSString *JJTestServiceRequestTypeWeather = @"weather";

@implementation JJTestService

- (void)requestWeather:(void (^)(JJWeatherModel *, NSString *, id))networkSuccessResponse_
   networkFailResponse:(void (^)(NSError *, id))networkFailResponse_
{
    [JJ_SERVICE_FEATURE_SET(self, JJTestWeatherFeatureSet) requestWeather:networkSuccessResponse_ networkFailResponse:networkFailResponse_];
}

@end
