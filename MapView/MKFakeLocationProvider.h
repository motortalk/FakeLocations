//
//  MKFakeLocationProvider.h
//  FakeLocationsExample
//
//  Created by Philip Brechler on 10.12.13.
//  Copyright (c) 2013 Call a Nerd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MKFakeLocationProvider : NSObject

@property (nonatomic, strong) CLLocation *lastLocation;
@property (nonatomic, strong) CLHeading *heading;
@property (nonatomic, strong) CLHeading *throttledHeading;

+ (MKFakeLocationProvider *)sharedProvider;
@end
