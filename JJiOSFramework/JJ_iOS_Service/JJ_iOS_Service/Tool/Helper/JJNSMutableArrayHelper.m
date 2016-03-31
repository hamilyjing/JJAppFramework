//
//  JJNSMutableArrayHelper.m
//  YiZhangTong_iOS_Service
//
//  Created by JJ on 2/25/16.
//  Copyright © 2016 PingAn. All rights reserved.
//

#import "JJNSMutableArrayHelper.h"

@implementation JJNSMutableArrayHelper

#pragma mark - public

+ (void)mArray:(NSMutableArray *)mArray addObj:(id)i
{
    if (i)
    {
        [mArray addObject:i];
    }
}

@end
