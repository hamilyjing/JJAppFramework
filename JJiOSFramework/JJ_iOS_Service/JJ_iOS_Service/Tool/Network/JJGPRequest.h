//
//  JJGPRequest.h
//  YiZhangTong_iOS_Service
//
//  Created by JJ on 12/9/15.
//  Copyright © 2015 JJ. All rights reserved.
//

#import "JJBaseRequest.h"

@interface JJGPRequest : JJBaseRequest

@property (nonatomic, strong) NSString *operationType;
@property (nonatomic, strong) NSDictionary *parameters;

@property (nonatomic, strong) NSDictionary *parametersForSavedFileName;

- (instancetype)initWithOperationType:(NSString *)operationType
                           parameters:(NSDictionary *)parameters
                           modelClass:(Class)modelClass
                       isSaveToMemory:(BOOL)isSaveToMemory
                         isSaveToDisk:(BOOL)isSaveToDisk;

- (id)initWithOperationType:(NSString *)operationType
                 parameters:(NSDictionary *)parameters;

+ (instancetype)GPRequestWithOperationType:(NSString *)operationType
                                parameters:(NSDictionary *)parameters;

- (id)getConvertModelContent:(NSDictionary *)responseDictionary;

#pragma mark - get GP cache model

+ (id)GPCacheModelWithOperationType:(NSString *)operationType
                         parameters:(NSDictionary *)parameters
                         modelClass:(Class)modelClass;

+ (id)GPCacheModelWithOperationType:(NSString *)operationType
                         parameters:(NSDictionary *)parameters
                         modelClass:(Class)modelClass
      sensitiveDataForSavedFileName:(NSString *)sensitiveDataForSavedFileName;

@end
