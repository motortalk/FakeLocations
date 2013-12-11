//
//  ViewController.m
//  HTTPLocationsExample
//
//  Created by Philip Brechler on 09.12.13.
//  Copyright (c) 2013 Call a Nerd. All rights reserved.
//

#import "MapViewViewController.h"
#ifdef FAKE_LOCATIONS
    #import "MKMapView+HTTPLocations.h"
#endif
@interface MapViewViewController ()

@end

@implementation MapViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
#ifdef FAKE_LOCATIONS
    [self.mapView listenForFakeLocations];
#endif
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
#ifdef FAKE_LOCATIONS
    [self.mapView stopListening];
#endif
}

- (IBAction)switchUserTrackingMode:(id)sender {
    switch (self.mapView.userTrackingMode) {
        case MKUserTrackingModeFollow:
            [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
            break;
        case MKUserTrackingModeFollowWithHeading:
            [self.mapView setUserTrackingMode:MKUserTrackingModeNone animated:YES];
            break;
        case MKUserTrackingModeNone:
            [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
            break;
    }
}

@end
