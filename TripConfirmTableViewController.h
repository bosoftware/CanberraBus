//
//  TripConfirmTableViewController.h
//  SydneyTransit
//
//  Created by Bo Wang on 4/03/2015.
//  Copyright (c) 2015 Bo Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stops.h"
#import "Routes.h"

@interface TripConfirmTableViewController : UITableViewController
@property(nonatomic,retain) Stops *stopsFrom;

@property(nonatomic,retain) Stops *stopsTo;
@property(nonatomic,retain) NSString *routeType;
@property(nonatomic,retain) Routes * route;
@end
