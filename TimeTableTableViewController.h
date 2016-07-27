//
//  TimeTableTableViewController.h
//  brisbane.transit
//
//  Created by Bo Wang on 17/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stops.h"
#import "Routes.h"
#import "NetworkResponseProtocol.h"
@interface TimeTableTableViewController : UITableViewController<NetworkResponseProtocol>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *myIndicator;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegment;
@property(nonatomic,retain) NSMutableArray * stopTimes;
@property(nonatomic,retain) Routes * route;
@property(nonatomic,retain) Stops *stopsFrom;

@property(nonatomic,retain) Stops *stopsTo;
@property(nonatomic,retain) NSString * routeType;

@end
