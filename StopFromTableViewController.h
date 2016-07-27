//
//  StopFromTableViewController.h
//  brisbane.transit
//
//  Created by Bo Wang on 12/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkResponseProtocol.h"
#import "Routes.h"
@interface StopFromTableViewController : UITableViewController<NetworkResponseProtocol>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *myIndicator;
@property(nonatomic,retain) NSMutableArray * stops;
@property(nonatomic,retain) Routes * route;
@property(nonatomic,retain) NSMutableArray * indexs;
@property(nonatomic,retain) NSString *routeType;

@end
