//
//  JJNSFileManagerHelper.m
//  YiZhangTong_iOS_Service
//
//  Created by JJ on 2/25/16.
//  Copyright © 2016 PingAn. All rights reserved.
//

#import "JJNSFileManagerHelper.h"

@implementation JJNSFileManagerHelper

#pragma mark - public

+ (NSString *)filePathWithFileName:(NSString *)fileName_
{
    NSString *resource = fileName_;
    NSString *type= @"";
    
    NSRange range = [fileName_ rangeOfString:@"." options:NSBackwardsSearch];
    if (NSNotFound != range.location)
    {
        resource = [fileName_ substringToIndex:range.location];
        type = [fileName_ substringFromIndex:range.location + range.length];
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    return filePath;
}

+ (NSArray *)getFileNameOrPathList:(BOOL)needFullPath_
                       fromDirPath:(NSString *)dirPath_
             needCheckSubDirectory:(BOOL)needCheckSubDirectory_
              fileNameCompareBlock:(BOOL (^)(NSString *fileName))fileNameCompareBlock_
{
    NSMutableArray *fileList = [NSMutableArray arrayWithCapacity:10];
    
    NSError *error;
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath_ error:&error];
    NSAssert(!error, @"%@", error);
    
    for (NSString *fileName in tmplist)
    {
        NSString *fullpath = [dirPath_ stringByAppendingPathComponent:fileName];
        BOOL isDir;
        BOOL fileExist = [self isFileExistAtPath:fullpath isDirectory:&isDir];
        
        if (!fileExist)
        {
            continue;
        }
        
        if (isDir && needCheckSubDirectory_)
        {
            NSArray *subFileList = [self getFileNameOrPathList:needFullPath_ fromDirPath:fullpath needCheckSubDirectory:needCheckSubDirectory_ fileNameCompareBlock:fileNameCompareBlock_];
            if ([subFileList count] > 0)
            {
                [fileList addObjectsFromArray:subFileList];
            }
            continue;
        }
        
        if (fileNameCompareBlock_)
        {
            if (!fileNameCompareBlock_(fileName))
            {
                continue;
            }
        }
        
        if (needFullPath_)
        {
            [fileList addObject:fullpath];
        }
        else
        {
            [fileList addObject:fileName];
        }
    }
    
    return fileList;
}

+ (BOOL)isFileExistAtPath:(NSString*)fileFullPath isDirectory:(BOOL *)isDir
{
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath isDirectory:isDir];
    return isExist;
}

@end
