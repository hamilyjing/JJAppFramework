//
//  JJLocationManager.m
//  YiZhangTong_iOS_Service
//
//  Created by JJ on 12/28/15.
//  Copyright © 2015 JJ. All rights reserved.
//

#import "JJLocationManager.h"

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface JJLocationManager () <CLLocationManagerDelegate>

@property(nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, assign) BOOL isLocationSuccess;

@end

@implementation JJLocationManager

#pragma mark - public

- (BOOL)isOpenLocationPermission
{
    BOOL isOpen = YES;
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (kCLAuthorizationStatusDenied == status ||
        kCLAuthorizationStatusRestricted == status ||
        ![CLLocationManager locationServicesEnabled])
    {
        
        isOpen = NO;
    }
    
    return isOpen;
}

- (NSInteger)startLocation
{
    if (self.isLocationSuccess)
    {
        return 1;
    }
    
    if (![self isOpenLocationPermission])
    {
        return 2;
    }
    
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    
    return 0;
}

- (void)stopLocation
{
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
}

#pragma mark - delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if (self.isLocationSuccess)
    {
        return;
    }
    
    self.isLocationSuccess = YES;
    
    [self.locationManager stopUpdatingLocation];
    
    [self.delegate locateSuccess:self location:[locations lastObject]];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.delegate locateFail:self error:error];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (kCLAuthorizationStatusNotDetermined == status)
    {
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
}

#pragma mark - getter and setter

- (CLLocationManager *)locationManager
{
    if (_locationManager)
    {
        return _locationManager;
    }
    
    _locationManager = [[CLLocationManager alloc] init];
    return _locationManager;
}

@end
