//
//  JJPresenter.h
//  PANewToapAPP
//
//  Created by JJ on 12/30/15.
//  Copyright © 2015 Gavin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JJService.h"

@class JJPresenter;

@protocol JJPresenterDelegate <NSObject>

@optional

- (void)networkRequestSuccess:(JJPresenter *)presenter
                  requestType:(NSString *)requestType
                    parameter:(id)parameter
                       object:(id)object
               responseString:(NSString *)responseString
                    otherInfo:(id)otherInfo;

- (void)networkRequestFail:(JJPresenter *)presenter
               requestType:(NSString *)requestType
                 parameter:(id)parameter
                     error:(id)error
                 otherInfo:(id)otherInfo;

@end

@interface JJPresenter : NSObject <JJServiceDelegate>

@property (nonatomic, weak) id<JJPresenterDelegate> delegate;

@end
