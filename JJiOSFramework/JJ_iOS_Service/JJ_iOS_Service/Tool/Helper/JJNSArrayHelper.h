//
//  JJNSArrayHelper.h
//  YiZhangTong_iOS_Service
//
//  Created by JJ on 2/25/16.
//  Copyright © 2016 PingAn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJNSArrayHelper : NSObject

+ (NSString *)JSONString:(NSArray *)array;
+ (NSData *)JSONSData:(NSArray *)array;

@end
