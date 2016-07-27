//
//  JourneyFindTableViewController.h
//  brisbane.transit
//
//  Created by Bo Wang on 18/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkResponseProtocol.h"
@interface JourneyFindTableViewController : UITableViewController<NetworkResponseProtocol>
@property(nonatomic,retain) NSString *startAddress;
@property(nonatomic,retain) NSString *stopAddress;
@property(nonatomic,retain) NSString *url;
@property(nonatomic,retain) NSMutableArray * routeList;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *myIndicator;
@end
