//
//  JJNSDataHelper.m
//  YiZhangTong_iOS_Service
//
//  Created by JJ on 2/25/16.
//  Copyright © 2016 PingAn. All rights reserved.
//

#import "JJNSDataHelper.h"

@implementation JJNSDataHelper

+ (NSDictionary *)dictionaryWithJSON:(NSData *)data
{
    NSError *error;
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                                                  error:&error];
    
    if (error)
    {
        NSAssert(NO, @"From data to JSON object error: %@", error);
    }
    
    return result;
}

+ (NSDictionary *)dictionaryWithJSONByFilePath:(NSString *)filePath
{
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return [JJNSDataHelper dictionaryWithJSON:data];
}

@end
