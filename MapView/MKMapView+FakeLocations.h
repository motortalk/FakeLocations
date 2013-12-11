//
//  MKMapView+FakeLocations.h
//  FakeLocationsExample
//
//  Created by Philip Brechler on 10.12.13.
//  Copyright (c) 2013 Call a Nerd. All rights reserved.
//

#import <MapKit/MapKit.h>

#import <arpa/inet.h>
#import <netinet/in.h>
#import <stdio.h>
#import <sys/types.h>
#import <sys/socket.h>
#import <unistd.h>
#import <ifaddrs.h>

/* Note on payload length:
 * udp max length is 65,507 bytes
 * apns max length is 256 bytes
 */
#define BUFLEN 512
#define PORT 9931

@interface MKMapView (FakeLocations)

- (void)setRemoteNotificationsPort:(int)port;
- (int)remoteNotificationsPort;

- (void)listenForFakeLocations;
- (void)stopListening;

- (NSString*)getIPAddress;

@end
