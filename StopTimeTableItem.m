//
//  StopTimeTableItem.m
//  brisbane.transit
//
//  Created by Bo Wang on 17/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import "StopTimeTableItem.h"

@implementation StopTimeTableItem

- (NSComparisonResult)compare:(StopTimeTableItem *)otherObject {
    int stoptime1 = [_stopFrom1Time integerValue];
    int stoptime2 = [otherObject.stopFrom1Time integerValue];
    return stoptime1-stoptime2;
}

-(BOOL)isEqual:(id)object{
    BOOL rtn = FALSE;
    StopTimeTableItem * other = (StopTimeTableItem*)object;
    if ([self.stopFrom1Time isEqual:other.stopFrom1Time ]&& [ self.stopFrom1Name isEqual:other.stopFrom1Name] && [self.stopRouteName isEqual:other.stopRouteName]
        && [self.stopTo1Name isEqual:other.stopTo1Name] && [self.stopTo1Time isEqual:other.stopTo1Time]){
        rtn = TRUE;
        
    }
    return rtn;
}
@end
