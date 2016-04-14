//
//  JJLocationManager.h
//  JJ_iOS_Service
//
//  Created by JJ on 12/28/15.
//  Copyright © 2015 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;
@class JJLocationManager;

@protocol JJLocationManagerDelegate <NSObject>

@required
- (void)locateSuccess:(JJLocationManager *)locationManager location:(CLLocation *)location;
- (void)locateFail:(JJLocationManager *)locationManager error:(NSError *)error;

@end

@interface JJLocationManager : NSObject

@property (nonatomic, weak) id<JJLocationManagerDelegate> delegate;

- (BOOL)isOpenLocationPermission;

- (NSInteger)startLocation;
- (void)stopLocation;

@end
