//
//  MKUserLocation+FakeLocation.m
//  HTTPLocationsExample
//
//  Created by Philip Brechler on 10.12.13.
//  Copyright (c) 2013 Call a Nerd. All rights reserved.
//
#ifdef FAKE_LOCATIONS

#import "MKUserLocation+FakeLocation.h"
#import "MKFakeLocationProvider.h"
@implementation MKUserLocation (FakeLocation)

- (CLLocation *)location {
    return [[MKFakeLocationProvider sharedProvider] lastLocation];
}

- (CLLocation *)predictedLocation {
    return [[MKFakeLocationProvider sharedProvider] lastLocation];
}

- (CLLocationCoordinate2D)coordinate {
    return [[[MKFakeLocationProvider sharedProvider] lastLocation]coordinate];
}

- (CLLocation *)fixedLocation {
    return [[MKFakeLocationProvider sharedProvider] lastLocation];
}


@end
#endif
