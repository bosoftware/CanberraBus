//
//  TransitJson.h
//  brisbane.transit
//
//  Created by Bo Wang on 19/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransitJson : NSObject
@property(nonatomic,retain) NSString *transitName;
@property(nonatomic,retain) NSString *fromStop;
@property (nonatomic,retain) NSString *toStop;
@property (nonatomic,retain) NSString *fromTime;
@property(nonatomic,retain) NSString *toTime;
@property(nonatomic,retain) NSString *longName;
@property(nonatomic,retain) NSString *type;
@property(nonatomic,retain) NSString *fromStopId;
@property(nonatomic,retain) NSString *toStopId;
@end
