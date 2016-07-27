//
//  StopTimeTableDetailsItem.h
//  brisbane.transit
//
//  Created by Bo Wang on 18/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StopTimeTableDetailsItem : NSObject
@property(nonatomic,retain) NSString* stopId;
@property(nonatomic,retain) NSString * stopName;
@property(nonatomic,retain) NSString * arrive_time;
@property(nonatomic,retain) NSString * stop_sequence;
@end
