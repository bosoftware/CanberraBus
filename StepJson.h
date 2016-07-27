//
//  StepJson.h
//  brisbane.transit
//
//  Created by Bo Wang on 19/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransitJson.h"
@interface StepJson : NSObject
@property(nonatomic,retain) NSString *htmlInstruction;
@property(nonatomic,retain) NSString *distance;
@property(nonatomic,retain) NSString *duration;
@property(nonatomic,retain) NSString *travelMode;
@property(nonatomic,retain) TransitJson *transitJson;
@property(nonatomic,retain) NSMutableArray * stepJsonList;
@end
