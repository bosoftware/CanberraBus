//
//  StopFromViewController.m
//  SydneyTransit
//
//  Created by Bo Wang on 4/03/2015.
//  Copyright (c) 2015 Bo Software. All rights reserved.
//

#import "StopFromViewController.h"
#import "Stops.h"
#import "GtfsUtility.h"
#import "ToStopTableViewController.h"

@interface StopFromViewController ()

@end

@implementation StopFromViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _stops = [[NSMutableArray alloc]init];
    _tableView.delegate=self;
    _tableView.dataSource=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"toStop"]){
         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
         ToStopTableViewController *toStopController = [segue destinationViewController];
         toStopController.routeType=_routeType;
         toStopController.stopsFrom = [_stops objectAtIndex:indexPath.row];
     }
 }
 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _stops.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Stops * stop = [_stops objectAtIndex:indexPath.row];
    
    cell.textLabel.text = stop.stop_name;
    
    return cell;
    
}


- (IBAction)searchStop:(id)sender {
    
    NSString * text = _searchText.text;
    if (text.length<3){
        [GtfsUtility ToastNotification:@"Please inform at least 3 characters" andView:nil andLoading:YES andIsBottom:YES];
    }else{
        [_myIndicator startAnimating];
        
        [GtfsUtility getStopsByRouteType:_routeType  stopName:text  indicator:_myIndicator controller:self];
    }
}

-(void) setResponseArray:(id)responseArray{
    [_stops removeAllObjects];
    [_stops addObjectsFromArray:responseArray];
    
    if (_stops.count==0){
        [GtfsUtility ToastNotification:@"No results found" andView:nil andLoading:YES andIsBottom:YES];
    }
    [self.tableView reloadData];
    
    [_myIndicator stopAnimating];
}
@end
