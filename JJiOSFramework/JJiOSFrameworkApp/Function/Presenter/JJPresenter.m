//
//  JJPresenter.m
//  PANewToapAPP
//
//  Created by JJ on 12/30/15.
//  Copyright © 2015 Gavin. All rights reserved.
//

#import "JJPresenter.h"

@implementation JJPresenter

#pragma mark - delegate

#pragma mark -- JJServiceDelegate

- (void)networkSuccessResponse:(JJService *)service_
                   requestType:(NSString *)requestType_
                     parameter:(id)parameter_
                        object:(id)object_
                responseString:(NSString *)responseString_
                     otherInfo:(id)otherInfo_
{
    if ([self.delegate respondsToSelector:@selector(networkRequestSuccess:requestType:parameter:object:responseString:otherInfo:)])
    {
        [self.delegate networkRequestSuccess:self
                                 requestType:requestType_
                                   parameter:parameter_
                                      object:object_
                              responseString:responseString_
                                   otherInfo:otherInfo_];
    }
}

- (void)networkFailResponse:(JJService *)service_
                requestType:(NSString *)requestType_
                  parameter:(id)parameter_
                      error:(id)error_
                  otherInfo:(id)otherInfo_
{
    if ([self.delegate respondsToSelector:@selector(networkRequestFail:requestType:parameter:error:otherInfo:)])
    {
        [self.delegate networkRequestFail:self
                              requestType:requestType_
                                parameter:parameter_
                                    error:error_
                                otherInfo:otherInfo_];
    }
}

@end
