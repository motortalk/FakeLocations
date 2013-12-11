//
//  ViewController.h
//  FakeLocationsExample
//
//  Created by Philip Brechler on 09.12.13.
//  Copyright (c) 2013 Call a Nerd. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>


@interface MapViewViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

- (IBAction)switchUserTrackingMode:(id)sender;

@end
