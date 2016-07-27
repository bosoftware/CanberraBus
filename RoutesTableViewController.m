//
//  RoutesTableViewController.m
//  brisbane.transit
//
//  Created by Bo Wang on 17/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import "RoutesTableViewController.h"
#import "GtfsUtility.h"
#import "Routes.h"
#import "StopFromTableViewController.h"
@interface RoutesTableViewController ()

@end

@implementation RoutesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [_myIndicator startAnimating];
    [GtfsUtility getRoutesByType:_routeType indicator:_myIndicator controller:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_filteredRoutes count];
    } else {
        return [_routes count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Routes *routes;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        routes = [_filteredRoutes objectAtIndex:indexPath.row];
    } else {
        routes = [_routes objectAtIndex:indexPath.row];
    }
    static NSString *CellIdentifier = @"routeIdentifier";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
//    Routes *routes =[_routes objectAtIndex:indexPath.row];
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",routes.route_short_name, routes.route_long_name];
    
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"fromStop"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Routes * routes;
        
        if (self.searchDisplayController.active == YES){
            routes = [_filteredRoutes objectAtIndex:self.searchDisplayController.searchResultsTableView.indexPathForSelectedRow.row];
        }else{
            routes = [_routes objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        }
        StopFromTableViewController * stopController = [segue destinationViewController];
        stopController.route = routes;
        stopController.routeType=_routeType;
    }
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self performSegueWithIdentifier:@"fromStop" sender:self];
//    
//}


-(void) setResponseArray:(id)responseArray{
    _routes = responseArray;
    _filteredRoutes = [NSMutableArray arrayWithCapacity:[_routes count]];
    [self.tableView reloadData];
    [_myIndicator stopAnimating];
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.filteredRoutes removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.route_short_name contains[c] %@ or SELF.route_long_name contains[c] %@",searchText,searchText];
    _filteredRoutes = [NSMutableArray arrayWithArray:[_routes filteredArrayUsingPredicate:predicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
@end
