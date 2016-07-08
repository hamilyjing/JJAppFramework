//
//  JJWeatherRequest.m
//  JJ_iOS_Service
//
//  Created by JJ on 4/14/16.
//  Copyright © 2016 JJ. All rights reserved.
//

#import "JJWeatherRequest.h"

@implementation JJWeatherRequest

- (instancetype)initWithOperationType:(NSString *)operationType_
                           parameters:(NSDictionary *)parameters_
                           modelClass:(Class)modelClass_
                       isSaveToMemory:(BOOL)isSaveToMemory_
                         isSaveToDisk:(BOOL)isSaveToDisk_
{
    self = [super initWithOperationType:operationType_ parameters:parameters_ modelClass:modelClass_ isSaveToMemory:isSaveToMemory_ isSaveToDisk:isSaveToDisk_];
    if (self)
    {
        self.userCacheDirectory = @"JJTestService";
    }
    
    return self;
}

- (NSString *)baseUrl
{
    return @"http://apis.baidu.com/showapi_open_bus/weather_showapi/areaid";
}

@end
