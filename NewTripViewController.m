//
//  NewTripViewController.m
//  brisbane.transit
//
//  Created by Bo Wang on 16/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import "NewTripViewController.h"
#import "RoutesTableViewController.h"
#import "StopFromTableViewController.h"
#import "StopFromViewController.h"

@interface NewTripViewController ()

@end

@implementation NewTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"railwayRoute"]){
        RoutesTableViewController * routesTableViewController = [segue destinationViewController];
        routesTableViewController.routeType = @"2";
    }
    else if ([segue.identifier isEqualToString:@"busRoute"]){
        RoutesTableViewController * routesTableViewController = [segue destinationViewController];
        routesTableViewController.routeType = @"3";
    }
    else if ([segue.identifier isEqualToString:@"ferryRoute"]){
        RoutesTableViewController * routesTableViewController = [segue destinationViewController];
        routesTableViewController.routeType = @"4";

    }
    else if ([segue.identifier isEqualToString:@"lightRail"]){
        RoutesTableViewController * routesTableViewController = [segue destinationViewController];
        routesTableViewController.routeType = @"0";
        
    }
    else if([segue.identifier isEqualToString:@"byStation"]){
        StopFromTableViewController * stopFrom = [segue destinationViewController];
        stopFrom.routeType=@"2";
    }
    else if([segue.identifier isEqualToString:@"byBusStop"]){
        StopFromViewController * stopFrom = [segue destinationViewController];
        stopFrom.routeType=@"3";
    }
    else if([segue.identifier isEqualToString:@"byWharf"]){
        StopFromViewController * stopFrom = [segue destinationViewController];
        stopFrom.routeType=@"4";
    }
    else if([segue.identifier isEqualToString:@"byLightRailStop"]){
        StopFromViewController * stopFrom = [segue destinationViewController];
        stopFrom.routeType=@"0";
    }


}


@end
