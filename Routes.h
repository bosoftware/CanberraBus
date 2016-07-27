//
//  Routes.h
//  brisbane.transit
//
//  Created by Bo Wang on 12/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Routes : NSObject
@property(nonatomic,retain) NSString * route_id;
@property(nonatomic,retain) NSString * route_short_name;
@property(nonatomic,retain) NSString * route_long_name;
@property(nonatomic,retain) NSString * route_desc;
@property(nonatomic,retain) NSString * route_type;

@end
