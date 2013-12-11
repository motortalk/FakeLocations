//
//  CLFakeHeading.h
//  HTTPLocationsExample
//
//  Created by Philip Brechler on 10.12.13.
//  Copyright (c) 2013 Call a Nerd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface CLFakeHeading : NSObject

@property (nonatomic) CLLocationDirection magneticHeading;
@property (nonatomic) CLLocationDegrees heading;
@property (nonatomic) CLLocationDirection trueHeading;
@property (nonatomic) CLLocationDirection headingAccuracy;
@property (nonatomic) NSDate *timeStamp;
@property (readonly, nonatomic) CLHeadingComponentValue *x;
@property (readonly, nonatomic) CLHeadingComponentValue *y;
@property (readonly, nonatomic) CLHeadingComponentValue *z;

- (instancetype)initWithMagneticHeading:(CLLocationDirection)magneticHeading trueHeading:(CLLocationDirection)trueHeading headingAccuracy:(CLLocationDirection)accuracy;
@end
