//
//  GwLocationManager.m
//  GwGroup
//
//  Created by gao wenjian on 14-4-18.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwLocationManager.h"

#import <CoreLocation/CoreLocation.h>

static GwLocationManager *loactionManger = nil;

@interface GwLocationManager()<CLLocationManagerDelegate>
{
    CLLocationManager *_manger;
}

@end

@implementation GwLocationManager

+ (GwLocationManager *)shareLocationManger
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       loactionManger = [[[self class] alloc] init];
    });
    
    return loactionManger;
}

- (void)startLocation
{
    if (!_manger) {
        _manger = [[CLLocationManager alloc] init];
        _manger.delegate = self;
        _manger.desiredAccuracy = kCLLocationAccuracyBest;
        _manger.distanceFilter = 1000.0f;
    }
    
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized ||  [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            [_manger startUpdatingLocation];
    }else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(locationFail:)]) {
            [_delegate locationFail:@"请开启定位"];
        }
    }
}

#pragma mark cllocation delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [_manger stopUpdatingHeading];
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coord = location.coordinate;
    NSString *latude = [NSString stringWithFormat:@"%f",coord.latitude];
    NSString *loitude = [NSString stringWithFormat:@"%f",coord.longitude];
    
    [self storelotitu:loitude lat:latude];
    
    CLGeocoder *geo = [[CLGeocoder alloc] init];
    [geo reverseGeocodeLocation:location
              completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *mark = [placemarks lastObject];
        GWLog(@"mark --- %@",mark.addressDictionary);
        if (self.delegate && [self.delegate respondsToSelector:@selector(locationSuccess:)]) {
            [self storeCity:[mark.addressDictionary objectForKey:@"City"]];
            [_delegate locationSuccess:[mark.addressDictionary objectForKey:@"City"]];
        }else if([self.delegate respondsToSelector:@selector(locationFail:)]){
            [_delegate locationFail:@"定位失败"];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(locationFail:)]) {
        [_delegate locationFail:@"定位失败"];
    }
}

- (void)storeCity:(NSString *)city
{
    [[NSUserDefaults standardUserDefaults] setObject:city forKey:CURPLACE];
}

- (void)storelotitu:(NSString *)lou lat:(NSString *)lat
{
    GWLog(@"---- logti %@ %@",lou,lat);
    [[NSUserDefaults standardUserDefaults] setObject:lou forKey:LONGITU];
    [[NSUserDefaults standardUserDefaults] setObject:lat forKey:LATITU];
}

@end
