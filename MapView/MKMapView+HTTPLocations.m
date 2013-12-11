//
//  MKMapView+HTTPLocations.m
//  HTTPLocationsExample
//
//  Created by Philip Brechler on 10.12.13.
//  Copyright (c) 2013 Call a Nerd. All rights reserved.
//
#ifdef FAKE_LOCATIONS
#import "MKMapView+HTTPLocations.h"
#import <objc/runtime.h>
#import "MKFakeLocationProvider.h"
#import "MKUserLocation+FakeLocation.h"
static int __port = PORT;
static dispatch_source_t input_src;

@implementation MKMapView (HTTPLocations)

- (void)listenForFakeLocations {
    static struct sockaddr_in __si_me, __si_other;
    static char __buffer[BUFLEN];
    static int __socket;
    
    if ((__socket=socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP))==-1) {
        //NSLog(@"MKMapView+HTTPLocations: socket error");
    }
    
    memset((char *) &__si_me, 0, sizeof(__si_me));
    __si_me.sin_family = AF_INET;
    __si_me.sin_port = htons(__port);
    __si_me.sin_addr.s_addr = htonl(INADDR_ANY);
    
    if (bind(__socket, (struct sockaddr*)&__si_me, sizeof(__si_me))==-1) {
        //NSLog(@"MKMapView+HTTPLocations: bind error");
    }
    
    input_src = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ, __socket, 0, dispatch_get_main_queue());
    dispatch_source_set_event_handler(input_src,  ^{
        socklen_t slen=sizeof(__si_other);
        ssize_t size = 0;
        if ((size = recvfrom(__socket, __buffer, BUFLEN, 0, (struct sockaddr*)&__si_other, &slen))==-1) {
            //NSLog(@"MKMapView+HTTPLocations: recvfrom error");
        }
        //NSLog(@"MKMapView+HTTPLocations: received from %s:%d data = %s\n\n", inet_ntoa(__si_other.sin_addr), ntohs(__si_other.sin_port), __buffer);
        __buffer[size] = 0;
        NSString *string = [NSString stringWithUTF8String:__buffer];
        
        //NSLog(@"MKMapView+HTTPLocations: received string = %@", string);
        
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
        if (!dict) {
            NSLog(@"MKMapView+HTTPLocations: error = %@", error);
        } else if (![dict isKindOfClass:[NSDictionary class]]) {
            NSLog(@"MKMapView+HTTPLocations: message error (not a dictionary)");
        } else {
            CLLocationDegrees latFromDict = [dict[@"latitude"] doubleValue];
            CLLocationDegrees longFromDict = [dict[@"longitude"] doubleValue];
            CLLocationDistance altFromDict = [dict[@"altitude"] doubleValue];
            CLLocationAccuracy horAccuracy = [dict[@"horizontalAccuracy"] doubleValue];
            CLLocationAccuracy verAccuracy = [dict[@"verticalAccuracy"] doubleValue];
            CLLocationDirection courseFromDict = [dict[@"course"] doubleValue];
            CLLocationSpeed speedFromDict = [dict[@"speed"]doubleValue];
            NSDate *date = [NSDate date];
            
            CLLocation *locationToSend = [[CLLocation alloc]initWithCoordinate:CLLocationCoordinate2DMake(latFromDict, longFromDict) altitude:altFromDict horizontalAccuracy:horAccuracy verticalAccuracy:verAccuracy course:courseFromDict speed:speedFromDict timestamp:date];
            [[MKFakeLocationProvider sharedProvider] setLastLocation:locationToSend];
            [self updateFakedLocation];
        }
    });
    dispatch_source_set_cancel_handler(input_src,  ^{
        NSLog(@"MKMapView+HTTPLocations: socket closed");
        close(__socket);
    });
    dispatch_resume(input_src);
    NSLog(@"MKMapView+HTTPLocations: listening on %@:%d", [self getIPAddress], self.remoteNotificationsPort);
    [self updateFakedLocation];
}

- (void)stopListening {
    dispatch_source_cancel(input_src);
}

- (void)updateFakedLocation {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector" // of course this is completeley unofficial
    [self performSelector:@selector(resumeUserLocationUpdates)];
    [self performSelector:@selector(resumeUserHeadingUpdates)];
    [self swizzled_locationManagerUpdatedLocation:[MKFakeLocationProvider sharedProvider]];
    [self swizzled_locationManagerUpdatedHeading:[MKFakeLocationProvider sharedProvider]];
    [self performSelector:@selector(pauseUserLocationUpdates)];
    [self performSelector:@selector(pauseUserHeadingUpdates)];
#pragma clan diagnostic pop
    id userAnnotation = [self.userLocation performSelector:@selector(annotation)];
    SEL theSelector = NSSelectorFromString(@"setCoordinate:");
    NSInvocation *anInvocation = [NSInvocation invocationWithMethodSignature: [[userAnnotation class]instanceMethodSignatureForSelector:theSelector]];
    
    [anInvocation setSelector:theSelector];
    [anInvocation setTarget:userAnnotation];
    CLLocationCoordinate2D coordinateToSet = [MKFakeLocationProvider sharedProvider].lastLocation.coordinate;
    [anInvocation setArgument:&coordinateToSet atIndex:2];
    [anInvocation performSelector:@selector(invoke)];

    id userAnnotationView = [self performSelector:@selector(userLocationView)];
    if (userAnnotationView) {
        SEL setCoordinateSelector = NSSelectorFromString(@"setPresentationCoordinate:");
        NSInvocation *viewIncovation = [NSInvocation invocationWithMethodSignature: [[userAnnotationView class]instanceMethodSignatureForSelector:setCoordinateSelector]];
        
        [viewIncovation setSelector:setCoordinateSelector];
        [viewIncovation setTarget:userAnnotationView];
        [viewIncovation setArgument:&coordinateToSet atIndex:2];
        [viewIncovation performSelector:@selector(invoke)];
    }
    
}

#pragma mark - Method swizzeling

- (void)swizzled_locationManagerUpdatedLocation:(id)manager {
    [self swizzled_locationManagerUpdatedLocation:manager];
}

- (void)swizzled_locationManagerUpdatedHeading:(id)manager {
    [self swizzled_locationManagerUpdatedHeading:manager];

}


+ (void)load
{
    Method originalUpdateLocation, swizzledUpdateLocation;
    
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wundeclared-selector" // of course this is completeley unofficial
    originalUpdateLocation = class_getInstanceMethod(self, @selector(locationManagerUpdatedLocation:));
    #pragma clan diagnostic pop
    swizzledUpdateLocation = class_getInstanceMethod(self, @selector(swizzled_locationManagerUpdatedLocation:));
    method_exchangeImplementations(originalUpdateLocation, swizzledUpdateLocation);
    
    Method originalUpdateHeading, swizzledUpdateHeading;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector" // of course this is completeley unofficial
    originalUpdateHeading = class_getInstanceMethod(self, @selector(locationManagerUpdatedHeading:));
#pragma clan diagnostic pop
    swizzledUpdateHeading = class_getInstanceMethod(self, @selector(swizzled_locationManagerUpdatedHeading:));
    method_exchangeImplementations(originalUpdateHeading, swizzledUpdateHeading);

    
}


#pragma mark - port configuration

- (void)setRemoteNotificationsPort:(int)port {
    __port = port;
}

- (int)remoteNotificationsPort {
    return __port;
}

#pragma mark - ip address

- (NSString *)getIPAddress {
    
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    
    NSString *result = nil;
    
    // retrieve the current interfaces - returns 0 on success
    if (!getifaddrs(&interfaces)) {
        
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if(sa_type == AF_INET || sa_type == AF_INET6) {
                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                //NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                //NSLog(@"Interface \"%@\" addr %@", name, addr);
                
                if (!result ||
                    [result isEqualToString:@"0.0.0.0"] ||
                    ([result isEqualToString:@"127.0.0.1"] && ![addr isEqualToString:@"0.0.0.0"])
                    ) {
                    result = addr;
                }
                
            }
            temp_addr = temp_addr->ifa_next;
        }
        freeifaddrs(interfaces);
    }
    return result ? result : @"0.0.0.0";
}

@end
#endif
