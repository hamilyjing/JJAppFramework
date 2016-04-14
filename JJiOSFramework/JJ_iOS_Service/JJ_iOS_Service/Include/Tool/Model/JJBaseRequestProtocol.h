//
//  JJBaseRequestProtocol.h
//  JJ_iOS_Service
//
//  Created by JJ on 4/14/16.
//  Copyright © 2016 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JJBaseRequestProtocol <NSObject>

@optional

- (BOOL)successForBussiness:(id)model;
- (void)setData:(id)content;

@end
