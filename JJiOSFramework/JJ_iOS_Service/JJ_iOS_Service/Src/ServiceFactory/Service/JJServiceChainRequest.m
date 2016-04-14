//
//  JJServiceChainRequest.m
//  JJ_iOS_Service
//
//  Created by JJ on 1/8/16.
//  Copyright © 2016 JJ. All rights reserved.
//

#import "JJServiceChainRequest.h"

#import "JJServiceNotification.h"

@interface JJServiceChainRequest ()

@property (nonatomic, strong) NSMutableArray *chainRequestList;
@property (nonatomic, assign) BOOL continueWhenFail;
@property (nonatomic, copy) void (^completion)(BOOL success, NSArray *content);
@property (nonatomic, strong) NSMutableArray *responseContent;

@property (nonatomic, assign) NSInteger requestCount;

@end

@implementation JJServiceChainRequest

#pragma mark - life cycle

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

#pragma mark - public

- (void)performChainRequest:(NSArray *)chainRequestList_
  responseNotificationNames:(NSArray *)notificationNames_
           continueWhenFail:(BOOL)continueWhenFail_
                 completion:(void (^)(BOOL success, NSArray *responseContent))completion_
{
    if (!completion_)
    {
        return;
    }
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    
    self.requestCount = 0;
    self.continueWhenFail = continueWhenFail_;
    
    [self.chainRequestList removeAllObjects];
    BOOL (^request)(NSArray *);
    for (request in chainRequestList_)
    {
        [self.chainRequestList addObject:[request copy]];
    }
    self.completion = completion_;
    [self.responseContent removeAllObjects];
    
    for (NSString *name in notificationNames_)
    {
        [nc removeObserver:self name:name object:nil];
        [nc addObserver:self selector:@selector(responseNotification:) name:name object:nil];
    }
    
    request = [self.chainRequestList firstObject];
    request(self.responseContent);
}

#pragma mark - private

- (void)JJ_resetObject {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
     self.requestCount = 0;
    [self.chainRequestList removeAllObjects];
    [self.responseContent removeAllObjects];

}
#pragma mark - notification

- (void)responseNotification:(NSNotification *)notification_
{
    NSDictionary *content = notification_.userInfo ? notification_.userInfo : @{};
    [self.responseContent addObject:content];
    
    BOOL success = YES;
    NSNumber *successNumber = content[JJServiceNotificationKeySuccess];
    if ([successNumber isKindOfClass:[NSNumber class]])
    {
        success = [successNumber boolValue];
    }
    
    BOOL stop = !success && !self.continueWhenFail;
    
    self.requestCount = self.requestCount + 1;
    
    if (self.requestCount == [self.chainRequestList count]
        || stop)
    {
        self.completion(!stop, self.responseContent);
        [self JJ_resetObject];

    }
    else
    {
        BOOL (^request)(NSArray *) = self.chainRequestList[self.requestCount];
        BOOL needToCallBack = request(self.responseContent);
        if (needToCallBack) {
             self.completion(NO, self.responseContent);
            [self JJ_resetObject];

        }
    }
}

#pragma mark - getter and setter

- (NSMutableArray *)chainRequestList
{
    if (_chainRequestList)
    {
        return _chainRequestList;
    }
    
    _chainRequestList = [NSMutableArray array];
    return _chainRequestList;
}

- (NSMutableArray *)responseContent
{
    if (_responseContent)
    {
        return _responseContent;
    }
    
    _responseContent = [NSMutableArray array];
    return _responseContent;
}

@end
