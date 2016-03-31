//
//  JJBaseRequest.h
//  YiZhangTong_iOS_CommonLayer
//
//  Created by JJ on 12/12/15.
//  Copyright © 2015 yizhangtong. All rights reserved.
//

#import "YTKBaseRequest.h"

@interface JJBaseRequest : YTKBaseRequest

@property (nonatomic, assign) YTKRequestMethod requestMethodType;

@property (nonatomic, assign) BOOL isSaveToMemory;
@property (nonatomic, assign) BOOL isSaveToDisk;

@property (nonatomic, copy) NSString *userCacheDirectory;
@property (nonatomic, copy) NSString *sensitiveDataForSavedFileName;

@property (nonatomic, strong) Class modelClass;

@property (nonatomic, copy) id (^operation)(id newObject, id oldObject);

@property (nonatomic, copy) void (^networkSuccessResponse)(id object, id otherInfo);
@property (nonatomic, copy) void (^networkFailResponse)(id error, id otherInfo);

// get cache
- (id)cacheModel;

- (id)currentResponseModel;

// save cache
- (void)saveObjectToMemory:(id)object;
- (BOOL)saveObjectToDiskCache:(id)object;
- (BOOL)haveDiskCache;

// remove cache
- (void)removeMemoryCache;
- (void)removeDiskCache;
- (void)removeAllCache;

// convert and operate
- (id)convertToModel:(NSString *)JSONString;
- (id)operateWithNewObject:(id)newObject
                 oldObject:(id)oldObject
               updateCount:(NSInteger *)updateCount;
- (BOOL)successForBussiness:(id)model;

// file config
- (NSString *)savedFilePath;
- (NSString *)savedFileDirectory;
- (NSString *)savedFileName;

@end
