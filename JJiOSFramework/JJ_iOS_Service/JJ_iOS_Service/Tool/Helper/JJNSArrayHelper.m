//
//  JJNSArrayHelper.m
//  JJ_iOS_Service
//
//  Created by JJ on 2/25/16.
//  Copyright © 2016 PingAn. All rights reserved.
//

#import "JJNSArrayHelper.h"

@implementation JJNSArrayHelper

#pragma mark - public

+ (NSString *)JSONString:(NSArray *)array
{
    NSData *jsonData = [JJNSArrayHelper JSONSData:array];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (NSData *)JSONSData:(NSArray *)array
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (error)
    {
        NSAssert(NO, @"From JSON object to data error: %@", error);
    }
    
    return jsonData;
}

@end
