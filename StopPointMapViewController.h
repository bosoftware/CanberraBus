//
//  StopPointMapViewController.h
//  SydneyTransit
//
//  Created by Bo Wang on 19/04/2015.
//  Copyright (c) 2015 Bo Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "StopTimeTableDetailsItem.h"
#import "NetworkResponseProtocol.h"

@interface StopPointMapViewController : UIViewController<MKMapViewDelegate,NetworkResponseProtocol>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property(nonatomic,retain)  StopTimeTableDetailsItem * stopItem;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property(nonatomic,retain) NSMutableArray * stopDetails;
@end
