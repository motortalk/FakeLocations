//
//  CoreLocationViewController.m
//  HTTPLocationsExample
//
//  Created by Philip Brechler on 11.12.13.
//  Copyright (c) 2013 Call a Nerd. All rights reserved.
//

#import "CoreLocationViewController.h"
#ifdef FAKE_LOCATIONS
#import "CLLocationManager+HTTPLocations.h"
#endif

@interface CoreLocationViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation CoreLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager setDelegate:self];
#ifdef FAKE_LOCATIONS
    [self.locationManager listenForFakeLocations];
#else
    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];
#endif
}

- (void)viewWillDisappear:(BOOL)animated {
#ifdef FAKE_LOCATIONS
    [self.locationManager stopListening];
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *latestLocation = [locations firstObject];
    [self.coordinateLabel setText:[NSString stringWithFormat:@"%f %f +- %.2fm",latestLocation.coordinate.latitude,latestLocation.coordinate.longitude,latestLocation.horizontalAccuracy]];
    [self.speedLabel setText:[NSString stringWithFormat:@"Speed: %.2fm/s",latestLocation.speed]];
    [self.headingLabel setText:[NSString stringWithFormat:@"Heading: %.2f°",latestLocation.course]];
    [self.altLabel setText:[NSString stringWithFormat:@"Alt: %.2fm",latestLocation.altitude]];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    [self.headingLabel setText:[NSString stringWithFormat:@"Heading: %.2f°",newHeading.magneticHeading]];
}

@end
