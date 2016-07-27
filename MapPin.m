//
//  MapPin.m
//  Arrived
//
//  Created by Bo Wang on 28/01/2015.
//  Copyright (c) 2015 Bo Wang. All rights reserved.
//

#import "MapPin.h"
#import "prefix.h"
#import "Utilities.h"

#import "ToStopTableViewController.h"
@implementation MapPin

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:placeName description:description {
    self = [super init];
    if (self != nil) {
        coordinate = location;
        title = placeName;
        
        subtitle = description;
        
    }
    return self;
}

-(MKAnnotationView*) annotationView{
    MKAnnotationView * annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MapPin"];
    annotationView.enabled=YES;
    annotationView.canShowCallout=YES;
    annotationView.image = [UIImage imageNamed:@"arrived"];
    UIButton *pinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pinButton.frame = CGRectMake(2, 2, 28, 29);
    [pinButton setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
    pinButton.tag = title;
    [pinButton addTarget:self action:@selector(saveAddress:) forControlEvents:UIControlEventTouchUpInside];

    annotationView.rightCalloutAccessoryView=pinButton;
    return annotationView;
}

-(void) saveAddress:(id)sender  {
    //_mapViewController.selectLocation.latitude = [NSNumber numberWithFloat:coordinate.latitude];
    //_mapViewController.selectLocation.longitude = [NSNumber numberWithFloat:coordinate.longitude];
   // [_mapViewController.navigationController popViewControllerAnimated:TRUE];
    ToStopTableViewController *toStopController = ViewControllerFromStoryboard(@"ToStopTableViewController");
    toStopController.stopsFrom=_stop;
    // Present the log in view controller
    [_mapViewController.navigationController.visibleViewController.navigationController pushViewController:toStopController animated:YES];
    //[Utilities ToastNotification:@"Address has been selected and will be monitored" andView:self andLoading:YES andIsBottom:YES];
    
}

@end
