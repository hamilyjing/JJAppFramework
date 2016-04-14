//
//  JJNSDictionaryHelper.h
//  JJ_iOS_Service
//
//  Created by JJ on 2/25/16.
//  Copyright © 2016 PingAn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJNSDictionaryHelper : NSObject

+ (NSString *)JSONString:(NSDictionary *)dic;
+ (NSData *)JSONSData:(NSDictionary *)dic;

@end
