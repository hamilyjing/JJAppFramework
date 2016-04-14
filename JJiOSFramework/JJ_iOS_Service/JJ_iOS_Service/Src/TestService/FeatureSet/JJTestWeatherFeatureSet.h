//
//  JJTestWeatherFeatureSet.h
//  JJ_iOS_Service
//
//  Created by JJ on 4/14/16.
//  Copyright © 2016 JJ. All rights reserved.
//

#import "JJFeatureSet.h"

@class JJWeatherModel;

@interface JJTestWeatherFeatureSet : JJFeatureSet

- (void)requestWeather:(void (^)(JJWeatherModel *, NSString *, id))networkSuccessResponse
   networkFailResponse:(void (^)(NSError *, id))networkFailResponse;

@end
