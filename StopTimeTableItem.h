//
//  StopTimeTableItem.h
//  brisbane.transit
//
//  Created by Bo Wang on 17/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StopTimeTableItem : NSObject
@property(nonatomic,retain) NSString * stopRouteName;
@property(nonatomic,retain) NSString * stopFrom1Name;
@property(nonatomic,retain) NSString * stopTo1Name;
@property(nonatomic,retain) NSString * stopFrom1Time;
@property(nonatomic,retain) NSString * stopTo1Time;
@property(nonatomic,retain) NSString * tripId;
- (NSComparisonResult)compare:(StopTimeTableItem *)otherObject;


@end
