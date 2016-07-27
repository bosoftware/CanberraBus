//
//  StopPointMapViewController.m
//  SydneyTransit
//
//  Created by Bo Wang on 19/04/2015.
//  Copyright (c) 2015 Bo Software. All rights reserved.
//

#import "StopPointMapViewController.h"
#import "GtfsUtility.h"
#import "Stops.h"
#import "MapPin.h"

@interface StopPointMapViewController ()

@end

@implementation StopPointMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_indicator startAnimating];
    [GtfsUtility getStopByStopId:_stopItem.stopId indicator:_indicator controller:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) setResponseArray:(id)responseArray{
    _stopDetails = responseArray;
    
    [_indicator stopAnimating];
    
    Stops * stop = [_stopDetails objectAtIndex:0];
    
    CLLocationCoordinate2D location;
    location.latitude = [stop.stop_lat doubleValue];
    location.longitude = [stop.stop_lon doubleValue];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 200, 200);
//                             MKCoordinateRegion region = self.mapView.region;
//                             region.center = placemark.region.center;
//                             region.span.longitudeDelta /= 8.0;
//                             region.span.latitudeDelta /= 8.0;
    
    
    [self.mapView setRegion:region animated:YES];
    
    MapPin * pin = [[MapPin alloc] initWithCoordinates:location placeName:stop.stop_name description:stop.stop_desc];
    pin.mapViewController = self;
    pin.stop=stop;
    [self.mapView addAnnotation:pin];
    
}
@end
