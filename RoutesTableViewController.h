//
//  RoutesTableViewController.h
//  brisbane.transit
//
//  Created by Bo Wang on 17/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkResponseProtocol.h"
#import "Routes.h"
@interface RoutesTableViewController : UITableViewController<NetworkResponseProtocol,UISearchBarDelegate, UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *myIndicator;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,retain) NSMutableArray *routes;
@property(nonatomic,retain) NSString * routeType;

@property (strong,nonatomic) NSMutableArray *filteredRoutes;
@end
