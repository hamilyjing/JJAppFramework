//
//  JJBaseResponseModel.h
//  YiZhangTong_iOS_CommonLayer
//
//  Created by JJ on 12/16/15.
//  Copyright © 2015 yizhangtong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JJBaseRequestProtocol.h"

@interface JJBaseResponseModel : NSObject <JJBaseRequestProtocol>

/// the value for root key is array
@property (nonatomic, strong) NSArray *responseResultList;

/// the value for root key is string
@property (nonatomic, copy) NSString *responseResultString;

@end
