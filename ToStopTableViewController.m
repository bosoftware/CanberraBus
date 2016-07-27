//
//  ToStopTableViewController.m
//  brisbane.transit
//
//  Created by Bo Wang on 17/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import "ToStopTableViewController.h"
#import "GtfsUtility.h"
#import "TimeTableTableViewController.h"
#import "prefix.h"
#import "TripConfirmTableViewController.h"

@interface ToStopTableViewController ()

@end

@implementation ToStopTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _indexs = [[NSMutableArray alloc]init];
    _stops = [[NSMutableArray alloc]init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [_myIndicator startAnimating];
    if(_route!=nil&&_stopsFrom!=nil){
        [GtfsUtility getStopsByRouteAndFrom:_route.route_id stopFrom:_stopsFrom routeType:_routeType indicator:_myIndicator controller:self];
    }
    else if (_route!=nil){
        [GtfsUtility getStopsByRoute:_route.route_id routeType:_routeType indicator:_myIndicator controller:self];
    }else if(_stopsFrom!=nil){
        [GtfsUtility getStopsByStopFrom:_stopsFrom.stop_id routeType:_routeType indicator:_myIndicator controller:self];
    }else{
        [GtfsUtility getStopsByRouteType:_routeType indicator:_myIndicator controller:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_indexs count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[_stops objectAtIndex:section] objectForKey:@"stops"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stopTo"];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"stopTo"];
        
    }

    Stops *stops = [[[_stops objectAtIndex:indexPath.section] objectForKey:@"stops"]
                    objectAtIndex:indexPath.row];

    cell.textLabel.text = stops.stop_name;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [_stops valueForKey:@"index"];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [_indexs indexOfObject:title];
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
    return [[_stops objectAtIndex:section] objectForKey:@"index"];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
     NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    if ([segue.identifier isEqualToString:@"showTimeTable"]){
        
        TimeTableTableViewController * timetableController = [segue destinationViewController];
        timetableController.route = _route;
        timetableController.stopsFrom = _stopsFrom;
        timetableController.routeType=_routeType;
        timetableController.stopsTo = [[[_stops objectAtIndex:indexPath.section] objectForKey:@"stops"]
                                       objectAtIndex:indexPath.row];
        
    }else if ([segue.identifier isEqualToString:@"tripConfirm"]){
        TripConfirmTableViewController * tripConfirmController = [segue destinationViewController];
        tripConfirmController.route = _route;
        tripConfirmController.stopsFrom=_stopsFrom;
        tripConfirmController.stopsTo=[[[_stops objectAtIndex:indexPath.section] objectForKey:@"stops"]
                                       objectAtIndex:indexPath.row];
        tripConfirmController.routeType=_routeType;
    }
}


-(void) setResponseArray:(id)responseArray{
    _stops = [[NSMutableArray alloc]init];
    _indexs = [[NSMutableArray alloc]init];
    if ([responseArray count]>0){
        for (int i = 0; i < [letters length]; i++ ) {
            NSMutableArray *stops = [[NSMutableArray alloc] init];
            char c = { toupper([letters characterAtIndex:i]), '\0'};
            NSString * s = [NSString stringWithFormat:@"%c",c ];
            NSMutableDictionary *row = [[NSMutableDictionary alloc] init] ;
            for(Stops * stop in responseArray){
                
                NSString * stopName = stop.stop_name;
                if ([[stopName uppercaseString] hasPrefix:s]){
                    [stops addObject:stop];
                }
            }
            if (stops.count>0){
                [row setValue:s forKey:@"index"];
                [row setValue:stops forKey:@"stops"];
                [_stops addObject:row];
            }
            
        }
        _indexs =[_stops valueForKey:@"index"];
        
    }
    [self.tableView reloadData];
    [_myIndicator stopAnimating];

}
@end
