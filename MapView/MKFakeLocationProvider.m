//
//  MKFakeLocationProvider.m
//  HTTPLocationsExample
//
//  Created by Philip Brechler on 10.12.13.
//  Copyright (c) 2013 Call a Nerd. All rights reserved.
//

#import "MKFakeLocationProvider.h"
#import "CLFakeHeading.h"
#ifdef FAKE_LOCATIONS

@implementation MKFakeLocationProvider

+ (MKFakeLocationProvider *)sharedProvider {
    static MKFakeLocationProvider *sharedProvider = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedProvider = [[self alloc] init];
        sharedProvider.lastLocation = [[CLLocation alloc]initWithLatitude:0 longitude:0];
    });
    return sharedProvider;
}

- (CLLocation *)lastLocation {
    return _lastLocation;
}



- (CLHeading *)heading {
    CLFakeHeading *fakeHeading = [[CLFakeHeading alloc]initWithMagneticHeading:self.lastLocation.course trueHeading:self.lastLocation.course headingAccuracy:20];
    return (CLHeading *)fakeHeading;
}

- (CLHeading *)throttledHeading {
    CLFakeHeading *fakeHeading = [[CLFakeHeading alloc]initWithMagneticHeading:self.lastLocation.course trueHeading:self.lastLocation.course headingAccuracy:20];
    return (CLHeading *)fakeHeading;
}

- (double)expectedGpsUpdateInterval {
    return 5;
}

- (int)lastLocationSource {
    return 0;
}

- (BOOL)hasLocation {
    return YES;
}

- (BOOL)isHeadingServicesAvailable {
    return YES;
}

@end
#endif