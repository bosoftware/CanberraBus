//
//  SavedTrips.h
//  brisbane.transit
//
//  Created by Bo Wang on 12/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SavedTrips : NSObject
@property(nonatomic,retain) NSString * saved_trip_id;
@property(nonatomic,retain) NSString * stop_from;
@property(nonatomic,retain) NSString * stop_to;
@property(nonatomic,retain) NSString * stop_from_name;
@property(nonatomic,retain) NSString * stop_to_name;
@property(nonatomic,retain) NSString * route_id;
@property(nonatomic,retain) NSString * route_name;
+(NSMutableArray *) getSavedTrips;
+(BOOL) saveTrip:(SavedTrips*)trip;
+(BOOL)deleteTrip:(SavedTrips*)trip;
@end
