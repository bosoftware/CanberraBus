//
//  StopFromViewController.h
//  SydneyTransit
//
//  Created by Bo Wang on 4/03/2015.
//  Copyright (c) 2015 Bo Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkResponseProtocol.h"

@interface StopFromViewController : UIViewController<NetworkResponseProtocol,UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSMutableArray * stops;
@property(nonatomic,retain) NSString *routeType;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *myIndicator;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@end
