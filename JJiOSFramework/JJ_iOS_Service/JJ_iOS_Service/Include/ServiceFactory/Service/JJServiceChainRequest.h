//
//  JJServiceChainRequest.h
//  YiZhangTong_iOS_Service
//
//  Created by JJ on 1/8/16.
//  Copyright © 2016 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJServiceChainRequest : NSObject

/**
 *  perform all request synchronous.
 *
 *  @param chainRequestList  request block list, block type is "BOOL (^)(NSArray *)" and the parameter is all response content before this request.
 *  @param notificationNames notification name list
 *  @param continueWhenFail  YES: do not perform next request when current request fail
 *  @param completion        completion callback
 */
- (void)performChainRequest:(NSArray *)chainRequestList
  responseNotificationNames:(NSArray *)notificationNames
           continueWhenFail:(BOOL)continueWhenFail
                 completion:(void (^)(BOOL success, NSArray *responseContent))completion;

@end
