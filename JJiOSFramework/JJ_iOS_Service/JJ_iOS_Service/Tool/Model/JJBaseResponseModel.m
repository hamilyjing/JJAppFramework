//
//  JJBaseResponseModel.m
//  JJ_iOS_CommonLayer
//
//  Created by JJ on 12/16/15.
//  Copyright © 2015 JJ. All rights reserved.
//

#import "JJBaseResponseModel.h"

#import "YYModel.h"

@interface JJBaseResponseModel () <NSCoding, NSCopying>

@end;

@implementation JJBaseResponseModel

#pragma mark - life cycle

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self yy_modelCopy];
}

@end
