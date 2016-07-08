
//
//  JJRequest.m
//  JJ_iOS_CommonLayer
//
//  Created by JJ on 12/12/15.
//  Copyright © 2015 JJ. All rights reserved.
//

#import "JJRequest.h"

#import "YYModel.h"
#import "JJNSStringHelper.h"
#import "JJRequestProtocol.h"
#import "JJServiceLog.h"
#import "JJBaseResponseModel.h"
#import "JJEncryptUtil.h"

#define k3DesKey @"(7Bg[#KjbmSegR/#"
#define k3DesIV @"jj"

@interface JJRequest ()

@property (nonatomic, strong) id jjCacheModel;

@property (nonatomic, strong) id oldModel;

@end

@implementation JJRequest

- (instancetype)initWithOperationType:(NSString *)operationType_
                           parameters:(NSDictionary *)parameters_
                           modelClass:(Class)modelClass_
                       isSaveToMemory:(BOOL)isSaveToMemory_
                         isSaveToDisk:(BOOL)isSaveToDisk_
{
    self = [super init];
    if (self)
    {
        self.operationType = operationType_;
        self.parameters = parameters_;
        
        self.requestMethodType = YTKRequestMethodGet;
        
        self.isSaveToMemory = isSaveToMemory_;
        self.isSaveToDisk = isSaveToDisk_;
        
        if (modelClass_)
        {
            self.modelClass = modelClass_;
        }
        else
        {
            self.modelClass = [JJBaseResponseModel class];
        }
        
        self.parametersForSavedFileName = self.parameters;
    }
    
    return self;
}

#pragma mark - overwrite

- (BOOL)ignoreCache
{
    return YES;
}

- (YTKRequestMethod)requestMethod
{
    return self.requestMethodType;
}

- (void)requestCompleteFilter
{
    if (!self.isSaveToMemory && !self.isSaveToDisk)
    {
        return;
    }
    
    id model = [self convertToModel:[self responseString]];
    
    self.oldModel = [self cacheModel];
    
    NSInteger updateCount;
    model = [self operateWithNewObject:model oldObject:self.oldModel updateCount:&updateCount];
    
    if (![self successForBussiness:model])
    {
        return;
    }
    
    if (self.isSaveToMemory)
    {
        self.jjCacheModel = model;
    }
    
    if (self.isSaveToDisk)
    {
        [self saveObjectToDiskCache:model];
    }
}

#pragma mark - public

- (id)cacheModel
{
    id cacheModel = self.jjCacheModel;
    if (!self.isSaveToMemory)
    {
        self.jjCacheModel = nil;
    }
    
    return cacheModel;
}

- (id)currentResponseModel
{
    id model = [self convertToModel:[self responseString]];
    
    NSInteger updateCount;
    model = [self operateWithNewObject:model oldObject:self.oldModel updateCount:&updateCount];
    
    return model;
}

- (void)saveObjectToMemory:(id)object_
{
    self.jjCacheModel = object_;
}

- (BOOL)saveObjectToDiskCache:(id)object_
{
    NSParameterAssert(object_);
    
    if (!object_)
    {
        return YES;
    }
    
    NSString *filePath = [self savedFilePath];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object_];
    if (data.length > 0) {
        data = [JJEncryptUtil encryptedWith3DESUsingKey:k3DesKey andIV:k3DesIV source:data];
    }
    BOOL success = [data writeToFile:filePath atomically:YES];
    return success;
}

- (BOOL)haveDiskCache
{
    NSString *filePath = [self savedFilePath];
    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    return fileExist;
}

- (void)removeMemoryCache
{
    self.jjCacheModel = nil;
}

- (void)removeDiskCache
{
    NSString *filePath = [self savedFilePath];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    if (error)
    {
    }
    else
    {
    }
}

- (void)removeAllCache
{
    [self removeMemoryCache];
    [self removeDiskCache];
}

- (id)getConvertModelContent:(NSDictionary *)responseDictionary_
{
    return responseDictionary_;
}

- (id)convertToModel:(NSString *)JSONString_
{
    NSString *responseString = [self responseString];
    
    NSDictionary *responseDic = [JJNSStringHelper dictionaryWithJSON:responseString];
    if (![responseDic isKindOfClass:[NSDictionary class]])
    {
        JJServiceLog(@"-- [error] response string:\n%@", responseString);
        return nil;
    }
    
    JJServiceLog(@"-- response dictionary:\n%@", responseDic);
    
    NSDictionary *resultDic = [self getConvertModelContent:responseDic];
    NSObject *model;
    
    if ([resultDic isKindOfClass:[NSDictionary class]])
    {
        model = [[self modelClass] yy_modelWithDictionary:resultDic];
    }
    else if ([resultDic isKindOfClass:[NSArray class]])
    {
        model = [[[self modelClass] alloc] init];
        if ([model isKindOfClass:[JJBaseResponseModel class]])
        {
            ((JJBaseResponseModel *)model).responseResultList = [NSArray yy_modelArrayWithClass:[self modelClass] json:resultDic];
        }
    }
    else if ([resultDic isKindOfClass:[NSString class]])
    {
        model = [[[self modelClass] alloc] init];
        if ([model isKindOfClass:[JJBaseResponseModel class]])
        {
            ((JJBaseResponseModel *)model).responseResultString = responseDic;
        }
    }
    else
    {
        model = [[[self modelClass] alloc] init];
    }
    
    if ([model respondsToSelector:@selector(setData:)])
    {
        [(id<JJRequestProtocol>)model setData:responseDic];
    }
    
    return model;
}

- (id)operateWithNewObject:(id)newObject_
                 oldObject:(id)oldObject_
               updateCount:(NSInteger *)updateCount_
{
    if (self.operation)
    {
        return self.operation(newObject_, oldObject_);
    }
    
    *updateCount_ = 1;
    return newObject_;
}

- (BOOL)successForBussiness:(id)model_
{
    BOOL successForBussiness = YES;
    
    if ([(NSObject *)model_ respondsToSelector:@selector(successForBussiness:)])
    {
        successForBussiness = [(id<JJRequestProtocol>)model_ successForBussiness:model_];
    }
    
    return successForBussiness;
}

- (NSString *)savedFilePath
{
    NSString *directory = [self savedFileDirectory];
    NSString *fileName = [self savedFileName];
    NSString *filePath = [directory stringByAppendingPathComponent:fileName];
    return filePath;
}

- (NSString *)savedFileDirectory
{
    NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    cachesDirectory = [cachesDirectory stringByAppendingPathComponent:@"JJRequest"];
    
    if ([self.userCacheDirectory length] > 0)
    {
        cachesDirectory = [cachesDirectory stringByAppendingPathComponent:self.userCacheDirectory];
    }
    
    [self __checkDirectory:cachesDirectory];
    
    return cachesDirectory;
}

- (NSString *)savedFileName
{
    NSString *baseUrl = [self baseUrl];
    NSString *requestUrl = [self requestUrl];
    NSDictionary *parameters = self.parametersForSavedFileName ? self.parametersForSavedFileName : @{};;
    NSString *requestInfo = [NSString stringWithFormat:@"Method:%ld Host:%@ Url:%@ Argument:%@ Sensitive:%@",
                             (long)[self requestMethod], baseUrl, requestUrl,
                             parameters, self.sensitiveDataForSavedFileName];
    NSString *cacheFileName = [JJNSStringHelper md5String:requestInfo];
    return cacheFileName;
}

#pragma mark - private

- (void)__checkDirectory:(NSString *)path_
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:path_ isDirectory:&isDir])
    {
        [self __createBaseDirectoryAtPath:path_];
    }
    else
    {
        if (!isDir)
        {
            NSError *error = nil;
            [fileManager removeItemAtPath:path_ error:&error];
            [self __createBaseDirectoryAtPath:path_];
        }
    }
}

- (void)__createBaseDirectoryAtPath:(NSString *)path_
{
    __autoreleasing NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path_
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    if (error)
    {
    }
    else
    {
    }
}

#pragma mark - getter and setter

- (id)jjCacheModel
{
    if (_jjCacheModel)
    {
        return _jjCacheModel;
    }
    
    NSString *filePath = [self savedFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath isDirectory:nil])
    {
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
        if (data.length > 0)
        {
            data = [JJEncryptUtil decryptedWith3DESUsingKey:k3DesKey andIV:k3DesIV source:data];
            _jjCacheModel = data.length > 0 ? [NSKeyedUnarchiver unarchiveObjectWithData:data] : nil;
        }
    }
    
    return _jjCacheModel;
}

@end
