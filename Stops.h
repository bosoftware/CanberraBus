//
//  Stops.h
//  brisbane.transit
//
//  Created by Bo Wang on 12/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stops : NSObject
@property(nonatomic,retain) NSString * stop_id;
@property(nonatomic,retain) NSString * stop_code;
@property(nonatomic,retain) NSString * stop_name;
@property(nonatomic,retain) NSString * stop_desc;
@property(nonatomic,retain) NSString * parent_station;
@property(nonatomic,retain) NSString * platform_code;
@property(nonatomic,retain) NSString * direction_id;
@property(nonatomic,retain) NSString * stop_sequence;
@property(nonatomic,retain) NSString * stop_lon;
@property(nonatomic,retain) NSString * stop_lat;

@end
