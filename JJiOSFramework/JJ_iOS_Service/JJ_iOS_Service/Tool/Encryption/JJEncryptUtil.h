//
//  JJEncryptUtil.h
//  JJ_iOS_Service
//
//  Created by JJ on 2/25/16.
//  Copyright © 2016 PingAn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJEncryptUtil : NSObject

+ (NSData *)encryptedWith3DESUsingKey:(NSString *)key andIV:(NSString *)iv source:(NSData *)source;
+ (NSData *)decryptedWith3DESUsingKey:(NSString *)key andIV:(NSString *)iv source:(NSData *)source;

@end
