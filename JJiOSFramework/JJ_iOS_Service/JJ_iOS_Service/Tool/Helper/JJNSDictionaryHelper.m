//
//  JJNSDictionaryHelper.m
//  JJ_iOS_Service
//
//  Created by JJ on 2/25/16.
//  Copyright © 2016 PingAn. All rights reserved.
//

#import "JJNSDictionaryHelper.h"

@implementation JJNSDictionaryHelper

#pragma mark - public

+ (NSString *)JSONString:(NSDictionary *)dic
{
    NSData *jsonData = [JJNSDictionaryHelper JSONSData:dic];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (NSData *)JSONSData:(NSDictionary *)dic
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (error)
    {
        NSAssert(NO, @"From JSON object to data error: %@", error);
    }
    
    return jsonData;
}

@end
