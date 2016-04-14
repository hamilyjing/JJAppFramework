//
//  JJWeatherPresenter.m
//  JJiOSFrameworkApp
//
//  Created by JJ on 4/14/16.
//  Copyright © 2016 JJ. All rights reserved.
//

#import "JJWeatherPresenter.h"

#import "JJWeatherModel.h"
#import "JJTestService.h"
#import "JJServiceFactory.h"

@implementation JJWeatherPresenter

- (void)requestWeather:(void (^)(JJWeatherModel *, NSString *, id))networkSuccessResponse
   networkFailResponse:(void (^)(NSError *, id))networkFailResponse
{
    [JJ_SERVICE(JJTestService) requestWeather:networkSuccessResponse networkFailResponse:networkFailResponse];
}

@end
