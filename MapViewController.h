//
//  MapViewController.h
//  Arrived
//
//  Created by Bo Wang on 26/01/2015.
//  Copyright (c) 2015 Bo Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "NetworkResponseProtocol.h"



@interface MapViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,NetworkResponseProtocol,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation* currentLocation;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
