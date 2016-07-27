//
//  TimeTableDetailsTableViewController.h
//  brisbane.transit
//
//  Created by Bo Wang on 18/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkResponseProtocol.h"
@interface TimeTableDetailsTableViewController : UITableViewController<NetworkResponseProtocol>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *myIndicator;
@property(nonatomic,retain) NSMutableArray * stopDetails;
@property(nonatomic,retain) NSString * tripId;
@end
