//
//  JJNSDataHelper.h
//  YiZhangTong_iOS_Service
//
//  Created by JJ on 2/25/16.
//  Copyright © 2016 PingAn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJNSDataHelper : NSObject

+ (NSDictionary *)dictionaryWithJSON:(NSData *)data;

+ (NSDictionary *)dictionaryWithJSONByFilePath:(NSString *)filePath;

@end
