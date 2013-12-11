# HTTPLocations #

A hacky little thing to fake locations in MKMapView and CLLocationManager. 

## Usage ##

The needed classes come as class extensions and two normal classes to imitate the behaviour of some classes needed.

**This code is ment to be used in testing and not in AppStore apps! This code is in a very early state!** 

To prevent that the code is ran in a live app we are using a `#ifdef FAKE_LOCATIONS` macro in each file. See the example.

### MKMapView ###

`#import "MKMapView+HTTPLocations` in your ViewController. To let the mapview listen for fake locations do a `[self.mapView listenForFakeLocations]`. To stop do a `[self.mapView stopListening]`. Everything else shoulde behave like your would expect.

### CLLocationManager ###

`#import "CLLocationManager+HTTPLocations` in your ViewController or location managment class. To let the location manager listen for fake locations do a `[self.locationManager listenForFakeLocations]`. To stop do a `[self.locationManager stopListening]`. Everything else shoulde behave like your would expect. Right now the location manager will give you delegate calls for errors, heading and location updates.

### Injecting locations ###

Injection is done by using UDP sockets. Why's that? Because it enables everyone on the same WiFi knowing the IP of the phone to inject locations. On first sight this seems like a security flaw but it is great if your QA is not on a Mac (poor QA) or your test runner is a Linux maschine.

#### CLI Example ####

`echo -n '{"latitude":52.12313131,"longitude":13.1231123123,"speed":40,"heading":100.1234,"verticalAccuracy":100,"horizontalAccuracy":200,"course":30.123}' | nc -4u -w1 <IPOFPHONE> 9931`

Your don't need to supply all keys but latitude and longitude. Every missing key will be a 0'

### Injecting headings ###

If you need to inject headings to your CLLocationMaanger you can do this via a UDB socket as well. 

#### CLI Example ####

`echo -n '{"magneticHeading":120.5,"trueHeading":110,"headingAccuracy":10}' | nc -4u -w1 <IPOFPHONE> 9931`

As in locations missing keys will be a 0