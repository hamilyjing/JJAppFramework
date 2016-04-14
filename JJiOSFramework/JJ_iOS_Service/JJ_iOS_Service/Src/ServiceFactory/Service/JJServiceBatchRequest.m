//
//  JJServiceBatchRequest.m
//  JJ_iOS_Service
//
//  Created by JJ on 1/8/16.
//  Copyright © 2016 JJ. All rights reserved.
//

#import "JJServiceBatchRequest.h"

#import "JJServiceNotification.h"

@interface JJServiceBatchRequest ()

@property (nonatomic, strong) NSArray *notificationNames;
@property (nonatomic, copy) void (^completion)(NSDictionary *content);
@property (nonatomic, strong) NSMutableDictionary *responseContent;
@property (nonatomic, assign) NSInteger responseCount;

@end

@implementation JJServiceBatchRequest

#pragma mark - life cycle

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

#pragma mark - public

- (void)performBatchRequest:(void (^)())batchRequest_
  responseNotificationNames:(NSArray *)notificationNames_
                 completion:(void (^)(NSDictionary *responseContent))completion_
{
    if (!completion_)
    {
        return;
    }
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    
    self.notificationNames = notificationNames_;
    self.completion = completion_;
    [self.responseContent removeAllObjects];
    self.responseCount = 0;
    
    for (NSString *name in notificationNames_)
    {
        [nc removeObserver:self name:name object:nil];
        [nc addObserver:self selector:@selector(responseNotification:) name:name object:nil];
    }
    
    if (batchRequest_)
    {
        batchRequest_();
    }
}

#pragma mark - notification

- (void)responseNotification:(NSNotification *)notification_
{
    NSString *name = notification_.name;
    NSDictionary *content = notification_.userInfo ? notification_.userInfo : @{};
    
    self.responseContent[name] = content;
    
    self.responseCount = self.responseCount + 1;
    
    if ([self.notificationNames count] == self.responseCount)
    {
        self.completion(self.responseContent);
    }
}

#pragma mark - getter and setter

- (NSMutableDictionary *)responseContent
{
    if (_responseContent)
    {
        return _responseContent;
    }
    
    _responseContent = [NSMutableDictionary dictionary];
    return _responseContent;
}

@end
