//
//  JJGPModel.m
//  YiZhangTong_iOS_Service
//
//  Created by JJ on 12/15/15.
//  Copyright © 2015 JJ. All rights reserved.
//

#import "JJGPModel.h"

@implementation JJGPModel

#pragma mark - public

- (BOOL)success
{
    return (1000 == self.response_resultStatus);
}

- (NSString *)responseMessage
{
    if ([self.response_tips length] > 0)
    {
        return self.response_tips;
    }
    else if ([self.response_memo length] > 0)
    {
        return self.response_memo;
    }
    
    return nil;
}

- (void)setGPModelData:(NSDictionary *)content_
{
    if (![content_ isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    
    id responseID = content_[@"id"];
    if ([responseID isKindOfClass:[NSNumber class]])
    {
        self.response_id = [responseID longValue];
    }
    else if ([responseID isKindOfClass:[NSString class]])
    {
        self.response_id = [responseID integerValue];
    }
    self.response_tips = content_[@"tips"];
    self.response_memo = content_[@"memo"];
    self.response_operationType = content_[@"operationType"];
    self.response_resultStatus = [content_[@"resultStatus"] longValue];
}

@end
