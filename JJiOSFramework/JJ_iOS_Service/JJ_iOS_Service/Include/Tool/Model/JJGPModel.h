//
//  JJGPModel.h
//  YiZhangTong_iOS_Service
//
//  Created by JJ on 12/15/15.
//  Copyright © 2015 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JJModel.h"

@interface JJGPModel : JJModel

@property (nonatomic, assign) long response_id;
@property (nonatomic, copy) NSString *response_tips;
@property (nonatomic, copy) NSString *response_memo;
@property (nonatomic, copy) NSString *response_operationType;
@property (nonatomic, assign) long response_resultStatus;

/// the value for "result" key is array
@property (nonatomic, strong) NSArray *responseResultList;

/// the value for "result" key is string
@property (nonatomic, copy) NSString *responseResultString;

- (BOOL)success;

- (NSString *)responseMessage;

- (void)setGPModelData:(NSDictionary *)content;

@end
