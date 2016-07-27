//
//  RouteJson.h
//  brisbane.transit
//
//  Created by Bo Wang on 19/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RouteJson : NSObject
@property(nonatomic,retain) NSString *arriveTime;
@property(nonatomic,retain) NSString *departTime;
@property(nonatomic,retain) NSString *distance;
@property(nonatomic,retain) NSString *duration;
@property(nonatomic,retain) NSMutableArray * steps;
@end
