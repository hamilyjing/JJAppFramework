//
//  JJNSFileManagerHelper.h
//  YiZhangTong_iOS_Service
//
//  Created by JJ on 2/25/16.
//  Copyright © 2016 PingAn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJNSFileManagerHelper : NSObject

+ (NSString *)filePathWithFileName:(NSString *)fileName;

+ (NSArray *)getFileNameOrPathList:(BOOL)needFullPath
                       fromDirPath:(NSString *)dirPath
             needCheckSubDirectory:(BOOL)needCheckSubDirectory
              fileNameCompareBlock:(BOOL (^)(NSString *fileName))fileNameCompareBlock;

+ (BOOL)isFileExistAtPath:(NSString*)fileFullPath isDirectory:(BOOL *)isDir;

@end
