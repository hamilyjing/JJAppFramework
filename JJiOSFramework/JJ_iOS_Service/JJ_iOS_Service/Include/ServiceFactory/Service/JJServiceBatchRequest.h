//
//  JJServiceBatchRequest.h
//  JJ_iOS_Service
//
//  Created by JJ on 1/8/16.
//  Copyright © 2016 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJServiceBatchRequest : NSObject

/**
 *  perform all request asynchronous. You should write all request in "batchRequest" block.
 *
 *  @param batchRequest      perform request block
 *  @param notificationNames notification name list
 *  @param completion        completion callback
 */
- (void)performBatchRequest:(void (^)())batchRequest
  responseNotificationNames:(NSArray *)notificationNames
                 completion:(void (^)(NSDictionary *responseContent))completion;

@end
