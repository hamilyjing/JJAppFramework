//
//  JJNSStringHelper.m
//  JJ_iOS_Service
//
//  Created by JJ on 2/25/16.
//  Copyright © 2016 PingAn. All rights reserved.
//

#import "JJNSStringHelper.h"

#import <CommonCrypto/CommonDigest.h>

@implementation JJNSStringHelper

#pragma mark - public

+ (NSDictionary *)dictionaryWithJSON:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];;
    if (!data)
    {
        return nil;
    }
    
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

+ (NSString *)md5String:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned int) strlen(cStr), result);
    NSString *md5String = [NSString stringWithFormat:
                           @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return md5String;
}

@end
