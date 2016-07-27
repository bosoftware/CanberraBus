//
//  prefix.h
//  brisbane.transit
//
//  Created by Bo Wang on 12/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#ifndef brisbane_transit_prefix_h
#define brisbane_transit_prefix_h

#define DATABASE_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingString:@"/brisbanetransit.db"]

#define QUERY_URL @"http://yourphpurl.php"


#define ShowAlerViewWithMessage(msg) \
[[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil \
cancelButtonTitle:NSLocalizedString(@"Ok", @"OK") otherButtonTitles:nil] show];


#define TABLE_NAME @"savedTrip"


#define GOOGLE_MAP_URL @"https://maps.googleapis.com/maps/api/directions/json?origin=<start>&destination=<stop>&<depart_type>=<depart_time>&mode=transit&alternatives=true&key=AIzaSyCAbiRAqhQOANyYgD65N6-a00K4kDKRcWo"


static NSString * letters =  @"abcdefghijklmnopqrstuvwxyz";

#define ViewControllerFromStoryboard(vcID) [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcID]

#endif
