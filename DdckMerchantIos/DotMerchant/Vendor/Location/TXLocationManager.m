//
//  TXLocationManager.m
//  TailorX
//
//  Created by Qian Shen on 8/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface TXLocationManager ()<CLLocationManagerDelegate>

/** 定位*/
@property (nonatomic, strong) CLLocationManager *locationManager;


@end

@implementation TXLocationManager

- (instancetype)init {
    if (self = [super init]) {
        [self locate];
    }
    return self;
}

- (void)locate {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100.0f;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0){
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

#pragma mark CoreLocation delegate

- (void)locationManagerWithsuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    self.failureBlock =  failure;
    self.successBlock = success;
}

/**
 * 定位失败
 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (self.failureBlock) {
        self.failureBlock(error);
    }
}

/**
 * 定位成功
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    NSString *longitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    NSLog(@"longitude = %@ latitude = %@", longitude, latitude);
    
    if (![NSString isTextEmpty:longitude]) {
        [TXModelAchivar updateUserModelWithKey:@"longitude" value:longitude];
    }
    if (![NSString isTextEmpty:latitude]) {
        [TXModelAchivar updateUserModelWithKey:@"latitude" value:latitude];
    }
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    //反编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            __weak typeof(self) weakSelf = self;
            // 当前城市
            CLPlacemark *placeMark = placemarks[0];
            if (!placeMark.locality) {
                if (weakSelf.successBlock) {
                    weakSelf.successBlock(@"无法定位当前城市",@"暂无");
                }
            }else {
                NSString *currentCity = placeMark.locality;
                NSString *currentArea = placeMark.subLocality;
                if (weakSelf.successBlock) {
                    weakSelf.successBlock(currentCity,currentArea);
                }
            }
        }else if (error == nil && placemarks.count == 0) {
            if (self.failureBlock) {
                self.failureBlock(error);
            }
        }else if (error) {
            if (self.failureBlock) {
                self.failureBlock(error);
            }
        }
    }];
}

/**
 * 根据地名获取经纬度
 */
- (void)geocodeAddressToLocation:(NSString*)addressName {
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:addressName completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil) {
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            NSString *longitude = [NSString stringWithFormat:@"%f",firstPlacemark.location.coordinate.longitude];
            
            NSString *latitude = [NSString stringWithFormat:@"%f",firstPlacemark.location.coordinate.latitude];
            NSLog(@"longitude === %@ latitude === %@", longitude, latitude);
            if (![NSString isTextEmpty:longitude]) {
                [TXModelAchivar updateUserModelWithKey:@"longitude" value:longitude];
            }
            if (![NSString isTextEmpty:latitude]) {
                [TXModelAchivar updateUserModelWithKey:@"latitude" value:latitude];
            }
            
        }
        else if ([placemarks count] == 0 && error == nil) {
            
        } else if (error != nil) {
            
        }
    }];
}

- (void)dealloc {
    NSLog(@"-----------------------------------定位dealloc-----------------------------");
}

@end
