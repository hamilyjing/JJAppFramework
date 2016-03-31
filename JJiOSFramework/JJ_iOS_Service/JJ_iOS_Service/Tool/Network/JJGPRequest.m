//
//  JJGPRequest.m
//  YiZhangTong_iOS_Service
//
//  Created by JJ on 12/9/15.
//  Copyright © 2015 JJ. All rights reserved.
//

#import "JJGPRequest.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "JJNSArrayHelper.h"
#import "JJNSMutableArrayHelper.h"
#import "JJNSMutableDictionaryHelper.h"
#import "JJNSStringHelper.h"
#import "YYModel.h"
#import "JJConfigService.h"
#import "JJGPModel.h"
#import "JJLoginService.h"
#import "JJLoginServiceNotification.h"
#import "JJConfigServiceConfigModel.h"
#import "JJServiceFactory.h"
#import "JJServiceNotification.h"
#import "JJConfigURLModel.h"

NSString *PrefixOfSavedFileNameForUnrelatedAccount = @"AllAccount";

@implementation JJGPRequest

#pragma mark - life cycle

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
        
        self.requestMethodType = YTKRequestMethodPost;
        
        self.isSaveToMemory = isSaveToMemory_;
        self.isSaveToDisk = isSaveToDisk_;
        
        if (modelClass_)
        {
            self.modelClass = modelClass_;
        }
        else
        {
            self.modelClass = [JJGPModel class];
        }
        
        self.sensitiveDataForSavedFileName = [JJ_SERVICE(JJLoginService) clientNo];
        self.parametersForSavedFileName = self.parameters;
    }
    
    return self;
}

- (id)initWithOperationType:(NSString *)operationType_
                 parameters:(NSDictionary *)parameters_
{
    NSAssert(NO, @"Use initWithOperationType:parameters:modelClass:isSaveToMemory:isSaveToDisk: instead of.");
    return nil;
}

+ (instancetype)GPRequestWithOperationType:(NSString *)operationType_ parameters:(NSDictionary *)parameters_
{
    NSAssert(NO, @"Use initWithOperationType:parameters:modelClass:isSaveToMemory:isSaveToDisk: instead of.");
    return nil;
}

- (instancetype)init
{
    NSAssert(NO, @"Use initWithOperationType:parameters:modelClass:isSaveToMemory:isSaveToDisk: instead of.");
    return nil;
}

#pragma mark - overwrite

- (NSString *)baseUrl
{
    NSString *baseUrl = JJ_SERVICE(JJConfigService).URLModel.SERVER_GP_BASE_URL_TOA;
    return baseUrl;
}

- (NSString *)requestUrl
{
    NSString *requestUrl = JJ_SERVICE(JJConfigService).URLModel.SERVER_GP_PATH_URL_TOA;
    return requestUrl;
}

- (id)requestArgument
{
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    
    [JJNSMutableDictionaryHelper mDictionary:query setObj:self.operationType forKey:@"operationType"];
    
    NSDictionary *commonQuery = [self JJ_commonQuery];
    NSMutableArray *requestArray = [NSMutableArray array];
    [JJNSMutableArrayHelper mArray:requestArray addObj:commonQuery];
    [JJNSMutableArrayHelper mArray:requestArray addObj:self.parameters];
    NSString *requestData = [JJNSArrayHelper JSONString:requestArray];
    requestData = [requestData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    requestData = [requestData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    requestData = [requestData stringByReplacingOccurrencesOfString:@" " withString:@""];
    [JJNSMutableDictionaryHelper mDictionary:query setObj:requestData forKey:@"requestData"];
    
    return query;
}

- (void)start
{
    [[NSNotificationCenter defaultCenter] postNotificationName:JJServiceNetworkRequestStartNotification object:self];
    
    [super start];
}

- (void)requestCompleteFilter
{
    [[NSNotificationCenter defaultCenter] postNotificationName:JJServiceNetworkRequestSuccessedNotification object:self];
    
    [super requestCompleteFilter];
    
    [self JJ_processAbnormalStatus];
}

- (void)requestFailedFilter
{
    [[NSNotificationCenter defaultCenter] postNotificationName:JJServiceNetworkRequestFailedNotification object:self];
    
    [super requestFailedFilter];
}

- (id)convertToModel:(NSString *)JSONString_
{
    NSString *responseString = [self responseString];
    NSDictionary *responseDic = [JJNSStringHelper dictionaryWithJSON:responseString];
    if (![responseDic isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    
    NSDictionary *resultDic = [self getConvertModelContent:responseDic];
    JJGPModel *model;
    
    if ([resultDic isKindOfClass:[NSDictionary class]])
    {
        model = [[self modelClass] yy_modelWithDictionary:resultDic];
    }
    else if ([resultDic isKindOfClass:[NSArray class]])
    {
        model = [[[self modelClass] alloc] init];
        model.responseResultList = [NSArray yy_modelArrayWithClass:[self modelClass] json:resultDic];
    }
    else if ([resultDic isKindOfClass:[NSString class]])
    {
        model = [[[self modelClass] alloc] init];
        model.responseResultString = (NSString *)resultDic;
    }
    else
    {
        model = [[[self modelClass] alloc] init];
    }
    
    [model setGPModelData:responseDic];
    
    return model;
}

- (BOOL)successForBussiness:(id)model
{
    if ([model isKindOfClass:[JJGPModel class]])
    {
        return [(JJGPModel *)model success];
    }
    
    return [super successForBussiness:model];
}

- (NSString *)savedFileDirectory
{
    NSString *cachesDirectory = JJ_SERVICE(JJConfigService).cacheDirectory;
    
    if ([self.userCacheDirectory length] > 0)
    {
        cachesDirectory = [cachesDirectory stringByAppendingPathComponent:self.userCacheDirectory];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cachesDirectory])
    {
        [fileManager createDirectoryAtPath:cachesDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return cachesDirectory;
}

- (NSString *)savedFileName
{
    NSMutableString *cacheFileName;
    
    NSString *sensitiveData = self.sensitiveDataForSavedFileName;
    if ([sensitiveData length] <= 0)
    {
        sensitiveData = PrefixOfSavedFileNameForUnrelatedAccount;
    }
    cacheFileName = [NSMutableString stringWithFormat:@"%@_", sensitiveData];
    
    NSString *operationType = self.operationType ? self.operationType : @"";
    [cacheFileName appendString:operationType];
    [cacheFileName appendString:@"_"];
    
    NSDictionary *parameters = self.parametersForSavedFileName ? self.parametersForSavedFileName : @{};
    NSString *cacheFileNameSuffix = [NSString stringWithFormat:@"Parameters:%@", parameters];
    cacheFileNameSuffix = [JJNSStringHelper md5String:cacheFileNameSuffix];
    
    if (cacheFileNameSuffix)
    {
        [cacheFileName appendString:cacheFileNameSuffix];
    }
    else
    {
        NSAssert(NO, @"Cannot convert String(Parameters:%@) to MD5", parameters);
    }
    
    return cacheFileName;
}

#pragma mark - public

- (id)getConvertModelContent:(NSDictionary *)responseDictionary_
{
    id content = responseDictionary_[@"result"];
    return content;
}

+ (id)GPCacheModelWithOperationType:(NSString *)operationType_
                         parameters:(NSDictionary *)parameters_
                         modelClass:(Class)modelClass_
{
    return [self GPCacheModelWithOperationType:operationType_
                                    parameters:parameters_
                                    modelClass:modelClass_
                 sensitiveDataForSavedFileName:[JJ_SERVICE(JJLoginService) clientNo]];
}

+ (id)GPCacheModelWithOperationType:(NSString *)operationType_
                         parameters:(NSDictionary *)parameters_
                         modelClass:(Class)modelClass_
      sensitiveDataForSavedFileName:(NSString *)sensitiveDataForSavedFileName_
{
    JJGPRequest *request = [[self alloc] initWithOperationType:operationType_ parameters:parameters_ modelClass:modelClass_ isSaveToMemory:NO isSaveToDisk:NO];
    request.sensitiveDataForSavedFileName = sensitiveDataForSavedFileName_;
    id model = [request cacheModel];
    return model;
}

#pragma mark - private

- (NSDictionary *)JJ_commonQuery
{
    JJConfigService *configService = JJ_SERVICE(JJConfigService);
    JJLoginService *loginService = JJ_SERVICE(JJLoginService);
    
    NSString *deviceID = JJ_SERVICE(JJConfigService).deviceID;
    
    NSString *appClientID = JJ_SERVICE(JJConfigService).appClientID;
    
    NSString *latitude = configService.latitude;
    NSString *longitude = configService.longitude;
    
    NSString *sessionId = [loginService sessionID];
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDict objectForKey:@"CFBundleVersion"];
    NSString *osVersion = [UIDevice currentDevice].systemVersion;
    NSString *osType = @"1";
    
    CFUUIDRef cfUuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfUuid));
    CFRelease(cfUuid);
    
    NSString *reqTracer = [NSString stringWithFormat:@"%@%@", deviceID, cfuuidString];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    NSInteger scale = [UIScreen mainScreen].scale;
    NSInteger dpiWidth = screenSize.width * scale;
    NSInteger dpiHeight = screenSize.height * scale;
    NSString *dpiString = [NSString stringWithFormat:@"%ldx%ld", (long)dpiWidth, (long)dpiHeight];
    
    NSMutableDictionary *commonQuery = [NSMutableDictionary dictionary];
    [JJNSMutableDictionaryHelper mDictionary:commonQuery setObj:osType forKey:@"osType"];
    [JJNSMutableDictionaryHelper mDictionary:commonQuery setObj:osVersion forKey:@"osVersion"];
    [JJNSMutableDictionaryHelper mDictionary:commonQuery setObj:appVersion forKey:@"appVersion"];
    [JJNSMutableDictionaryHelper mDictionary:commonQuery setObj:deviceID forKey:@"deviceId"];
    [JJNSMutableDictionaryHelper mDictionary:commonQuery setObj:appClientID forKey:@"appClientId"];
    [JJNSMutableDictionaryHelper mDictionary:commonQuery setObj:sessionId forKey:@"sessionId"];
    [JJNSMutableDictionaryHelper mDictionary:commonQuery setObj:latitude forKey:@"latitude"];
    [JJNSMutableDictionaryHelper mDictionary:commonQuery setObj:longitude forKey:@"longitude"];
    [JJNSMutableDictionaryHelper mDictionary:commonQuery setObj:reqTracer forKey:@"reqTracer"];
    [JJNSMutableDictionaryHelper mDictionary:commonQuery setObj:dpiString forKey:@"dpi"];
    
    return commonQuery;
}

- (void)JJ_processAbnormalStatus
{
    id userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    BOOL haveLogined = (userName != nil);
#pragma mark - TODO: use below if using login service
    //BOOL haveLogined = JJ_SERVICE(JJLoginService).isUserOnLine;
    if(!haveLogined)
    {
        return;
    }
    
    long resultStatus;
    
    NSDictionary *content = [JJNSStringHelper dictionaryWithJSON:self.responseString];
    if ([content isKindOfClass:[NSDictionary class]])
    {
        resultStatus = [content[@"resultStatus"] longValue];
    }
    
    if (resultStatus < 9000)
    {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:JJLoginServiceServerForceLogoutNotification object:@(resultStatus)];
}

@end
