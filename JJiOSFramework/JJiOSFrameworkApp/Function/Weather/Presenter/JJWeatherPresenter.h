//
//  JJWeatherPresenter.h
//  JJiOSFrameworkApp
//
//  Created by JJ on 4/14/16.
//  Copyright © 2016 JJ. All rights reserved.
//

#import "JJPresenter.h"

@class JJWeatherModel;

@interface JJWeatherPresenter : JJPresenter

- (void)requestWeather:(void (^)(JJWeatherModel *, NSString *, id))networkSuccessResponse
   networkFailResponse:(void (^)(NSError *, id))networkFailResponse;

@end
