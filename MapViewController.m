//
//  MapViewController.m
//  Arrived
//
//  Created by Bo Wang on 26/01/2015.
//  Copyright (c) 2015 Bo Wang. All rights reserved.
//

#import "MapViewController.h"
#import "MapPin.h"
#import "GtfsUtility.h"
@interface MapViewController (){
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    bool isMoved ;
}

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mapView.delegate = self;
    UIPanGestureRecognizer* panRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragMap:)];
    [panRec setDelegate:self];
    [self.mapView addGestureRecognizer:panRec];
    
}

-(void) viewWillAppear:(BOOL)animated{
     [super viewDidAppear:animated];
    isMoved=false;
    if ([CLLocationManager locationServicesEnabled] )
    {
        
        if (self.locationManager == nil )
        {
            self.locationManager = [[CLLocationManager alloc] init];
            
            self.locationManager.delegate = self;
            self.locationManager.distanceFilter = kCLDistanceFilterNone;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
                
                
            }
            
            
            CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
            
            if (authorizationStatus == kCLAuthorizationStatusAuthorized ||
                authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
                authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
                
                [self.locationManager startUpdatingLocation];
                _mapView.showsUserLocation = YES;
                
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You have to enable local service" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }else{
            [self.locationManager startUpdatingLocation];
        }
        
        
        
        
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations lastObject];
    // here we get the current location
   
    if (!isMoved){
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, 200, 200);
    //                         MKCoordinateRegion region = self.mapView.region;
    //                         region.center = placemark.region.center;
    //                         region.span.longitudeDelta /= 8.0;
    //                         region.span.latitudeDelta /= 8.0;
    
    
    [self.mapView setRegion:region animated:YES];
        //[self drawNearbyStops];
        isMoved=true;
    }
    //MapPin * pin = [[MapPin alloc] initWithCoordinates:self.currentLocation.coordinate placeName:@"Select this address" description:@""];
    //pin.mapViewController = self;
    //[self.mapView addAnnotation:pin];
    
    
   
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */




- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MapPin class]]){
        MapPin * mapPin = (MapPin *)annotation;
        MKAnnotationView * annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapPin"];
        if (annotationView==nil){
            annotationView = mapPin.annotationView;
        }else{
            annotationView.annotation=annotation;
        }
        return annotationView;
    }
    return nil;
    
    
}

-(void) setResponseArray:(id)responseArray{
    NSMutableArray * array = responseArray;
    for (Stops *stop in array){
        CLLocationCoordinate2D location;
        location.latitude = [stop.stop_lat doubleValue];
        location.longitude = [stop.stop_lon doubleValue];
        MapPin * pin = [[MapPin alloc] initWithCoordinates:location placeName:stop.stop_name description:stop.stop_desc];
        pin.mapViewController = self;
        pin.stop=stop;
        [self.mapView addAnnotation:pin];
    }
    [_indicator stopAnimating];
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)didDragMap:(UIGestureRecognizer*)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        NSLog(@"drag ended");
        //[self drawNearbyStops];
    }
}

-(void) drawNearbyStops{
    MKCoordinateRegion region = self.mapView.region;
    CLLocationCoordinate2D center   = region.center;
    CLLocationCoordinate2D northWestCorner, southEastCorner;
    northWestCorner.latitude  = center.latitude  - (region.span.latitudeDelta  / 2.0);
    northWestCorner.longitude = center.longitude - (region.span.longitudeDelta / 2.0);
    southEastCorner.latitude  = center.latitude  + (region.span.latitudeDelta  / 2.0);
    southEastCorner.longitude = center.longitude + (region.span.longitudeDelta / 2.0);
    
    NSString * nwLat = [NSString stringWithFormat:@"%f",northWestCorner.latitude];
    NSString * nwLon = [NSString stringWithFormat:@"%f",northWestCorner.longitude];
    NSString * seLat =[NSString stringWithFormat:@"%f",southEastCorner.latitude];
    NSString * seLon = [NSString stringWithFormat:@"%f",southEastCorner.longitude];
    
    [GtfsUtility getStopsByLatLot:nwLat nwLon:nwLon seLat:seLat seLon:seLon indicator:_indicator controller:self];
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    // Image creation code here
    [self drawNearbyStops];
}
@end
