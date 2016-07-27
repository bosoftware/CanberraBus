//
//  MapPin.h
//  Arrived
//
//  Created by Bo Wang on 28/01/2015.
//  Copyright (c) 2015 Bo Wang. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapViewController.h"
#import "Stops.h"

@interface MapPin : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property(nonatomic,retain) MapViewController * mapViewController;
@property(nonatomic,retain) Stops * stop;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString *)placeName description:(NSString *)description;

-(MKAnnotationView*) annotationView;

@end
