//
//  CLFakeHeading.m
//  HTTPLocationsExample
//
//  Created by Philip Brechler on 10.12.13.
//  Copyright (c) 2013 Call a Nerd. All rights reserved.
//

#import "CLFakeHeading.h"

@implementation CLFakeHeading

- (instancetype)initWithMagneticHeading:(CLLocationDirection)magneticHeading trueHeading:(CLLocationDirection)trueHeading headingAccuracy:(CLLocationDirection)accuracy {
    self = [super init];
    if (self){
        _magneticHeading = magneticHeading;
        _trueHeading = trueHeading;
        _headingAccuracy = accuracy;
        _timeStamp = [NSDate date];
    }
    return self;
}

- (double)heading {
    return _trueHeading;
}

- (BOOL)hasGeomagneticVector {
    return NO;
}

- (CLHeadingComponentValue *)x {
    return self.x;
}

- (CLHeadingComponentValue *)y {
    return self.y;
}

- (CLHeadingComponentValue *)z {
    return self.z;
}
@end
