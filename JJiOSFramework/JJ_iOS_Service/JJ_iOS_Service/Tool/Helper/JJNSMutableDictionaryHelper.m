//
//  JJNSMutableDictionaryHelper.m
//  YiZhangTong_iOS_Service
//
//  Created by JJ on 2/25/16.
//  Copyright © 2016 PingAn. All rights reserved.
//

#import "JJNSMutableDictionaryHelper.h"

@implementation JJNSMutableDictionaryHelper

#pragma mark - public

+ (void)mDictionary:(NSMutableDictionary *)mDictionary setObj:(id)i forKey:(NSString*)key
{
    if (i)
    {
        mDictionary[key] = i;
    }
}

@end
