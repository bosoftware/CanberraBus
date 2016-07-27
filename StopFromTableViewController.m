//
//  StopFromTableViewController.m
//  brisbane.transit
//
//  Created by Bo Wang on 12/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import "StopFromTableViewController.h"
#import "GtfsUtility.h"
#import "Stops.h"
#import "ToStopTableViewController.h"
#import "prefix.h"
@interface StopFromTableViewController ()

@end

@implementation StopFromTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _indexs = [[NSMutableArray alloc]init];
    _stops = [[NSMutableArray alloc]init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [_myIndicator startAnimating];
    if (_route!=nil&&_routeType!=nil){
        [GtfsUtility getStopsByRoute:_route.route_id routeType:_routeType  indicator:_myIndicator controller:self];
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [_indexs count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSInteger number =[[[_stops objectAtIndex:section] objectForKey:@"stops"] count];
    //NSLog([NSString stringWithFormat:@"%d",number]);
    return number;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stopIdentifier"];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"stopIdentifier"];
        
    }
    Stops *stops = [[[_stops objectAtIndex:indexPath.section] objectForKey:@"stops"]
                    objectAtIndex:indexPath.row];
    cell.textLabel.text = stops.stop_name;
    // Configure the cell...
    cell.textLabel.numberOfLines = 0;
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
    if (_stops.count>0 && [_stops objectAtIndex:section]!=nil){
        return [[_stops objectAtIndex:section] objectForKey:@"index"];
    }else{
        return @"Not Found";
    }
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"stopTo"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ToStopTableViewController *toStopController = [segue destinationViewController];
        toStopController.route = _route;
        toStopController.routeType=_routeType;
        toStopController.stopsFrom = [[[_stops objectAtIndex:indexPath.section] objectForKey:@"stops"]
                                      objectAtIndex:indexPath.row];
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
