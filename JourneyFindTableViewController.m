//
//  JourneyFindTableViewController.m
//  brisbane.transit
//
//  Created by Bo Wang on 18/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import "JourneyFindTableViewController.h"
#import "GoogleDirectionUtil.h"
#import "RouteJson.h"
@interface JourneyFindTableViewController ()

@end

@implementation JourneyFindTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [_myIndicator startAnimating];
    [GoogleDirectionUtil getGoogleJsonRoutes:_url indicator:_myIndicator controller:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return _routeList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    RouteJson * route = [_routeList objectAtIndex:section];
    return route.steps.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jsonRoute" forIndexPath:indexPath];
    RouteJson * route =[_routeList objectAtIndex:section];
    StepJson * step = [route.steps objectAtIndex:row];
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    cell.textLabel.textColor = [UIColor orangeColor];
    cell.textLabel.numberOfLines = 3;
    NSString * text =[NSString stringWithFormat:@"%@",step.htmlInstruction];
    if (step.transitJson!=nil){
        text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ -- %@ %@",text,step.transitJson.transitName,step.transitJson.longName, step.transitJson.fromStop,step.transitJson.fromTime,step.transitJson.toStop,step.transitJson.toTime];
        if ([[step.transitJson.type uppercaseString] isEqualToString:@"FERRY"]){
            cell.imageView.image  = [UIImage imageNamed:@"ferry.png"];
        }else {
            cell.imageView.image  = [UIImage imageNamed:@"transit.png"];
        }
    }else{
        if ([[step.travelMode uppercaseString] isEqualToString:@"WALKING"]){
            cell.imageView.image  = [UIImage imageNamed:@"walker.png"];
        }
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",text];
    // Configure the cell...
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    RouteJson * route = [_routeList objectAtIndex:section];
    return [NSString stringWithFormat:@"Depart:%@  Arrive:%@ %@ %@",route.departTime,route.arriveTime,route.distance,route.duration];
}
-(void) setResponseArray:(id)responseArray{
    _routeList = responseArray;
    [self.tableView reloadData];
    [_myIndicator stopAnimating];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(20, 8, 320, 20);
    myLabel.font = [UIFont boldSystemFontOfSize:12];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    myLabel.textColor = [UIColor blueColor];
    myLabel.numberOfLines = 5;
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}



@end
