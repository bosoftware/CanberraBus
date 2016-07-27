//
//  GtfsUtility.m
//  brisbane.transit
//
//  Created by Bo Wang on 12/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import "GtfsUtility.h"
#import "prefix.h"
#import "AFHTTPClient.h"
#import  <UIKit/UIKit.h>
#import "NetworkResponseProtocol.h"
#import "Routes.h"
#import "Stops.h"
#import "StopTimeTableItem.h"
#import "StopTimeTableDetailsItem.h"
#import "GCDiscreetNotificationView.h"
#define ROUTE_QUERY  1
#define STOP_QUERY  2
#define STOP_TO_QUERY 3
#define STOP_TIME_TABLE_QUERY 4
#define TRIP_DETAILS_QUERY 5

@implementation GtfsUtility


+(void) networkQuery:(NSString *) sql  indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control  queryType:(NSInteger) type{
    NSDictionary * parameters = @{@"query":sql};
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:QUERY_URL]];
    [client postPath:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *rss = nil;
        if ([responseObject isKindOfClass:[NSData class]]) {
            rss = (NSData*)responseObject;//[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        } else {
            rss = (NSString *)responseObject;
        }
        if ([control conformsToProtocol:@protocol(NetworkResponseProtocol)]==YES){
            //[control ]control = [self getRoutes:rss];
            NSMutableArray * array = [[NSMutableArray alloc]init];
            if (type==ROUTE_QUERY){
                array =[self  getRoutes:rss];
            }else if(type == STOP_QUERY){
                array = [self getStops:rss];
            }else if(type==STOP_TO_QUERY){
                array = [self getStopsTo:rss];
            }else if(type==STOP_TIME_TABLE_QUERY){
                array = [self getStopTimeTable:rss];
            }else if (type==TRIP_DETAILS_QUERY){
                array = [self getTripDetails:rss];
            }
            [control setResponseArray:array];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [indicatorView stopAnimating];
        [GtfsUtility ToastNotification:@"Sorry, Network Issue, Please try it again. thanks"  andView:self andLoading:NO andIsBottom:NO];
        //ShowAlerViewWithMessage( @"Sorry, Network Issue, Please try it again. thanks" );
    }];
    
}



+(void) getRoutesByType:(NSString*) routeType indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control{
    NSString * value = [NSString stringWithFormat:@"select distinct route_id,route_short_name,route_long_name,route_desc from routes where route_type = '%@'",routeType];
    [self networkQuery:value indicator:indicatorView controller:control queryType:ROUTE_QUERY];
}

+(NSMutableArray *)getRoutes:(NSData*)response{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    NSError *localError = nil;
    //-- JSON Parsing
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&localError];
    //NSLog(@"Result = %@",result);
    NSMutableArray * tarray = [[NSMutableArray alloc]init];
    for (NSMutableDictionary *dic in result)
    {
        NSString * routeShortName =dic[@"route_short_name"];
        if (![tarray containsObject:routeShortName]){
            Routes *routes = [[Routes alloc]init];
            [tarray addObject:routeShortName];
            NSString *route_id = dic[@"route_id"];
            routes.route_id = route_id;
            routes.route_long_name = dic[@"route_long_name"];
            routes.route_short_name=dic[@"route_short_name"];
            routes.route_desc=dic[@"route_desc"];
            routes.route_type=dic[@"route_type"];
            [array addObject:routes];
        }
    }
    
    return array;
}


+(NSMutableArray *)getStops:(NSData*)response{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    NSError *localError = nil;
    //-- JSON Parsing
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&localError];
    //NSLog(@"Result = %@",result);
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setMaximumFractionDigits:4];
    NSMutableArray * tarray = [[NSMutableArray alloc]init];
    for (NSMutableDictionary *dic in result)
    {
        NSString * stopId =dic[@"stop_id"];
        if (![tarray containsObject:stopId]){
            [tarray addObject:stopId];
            Stops *stops = [[Stops alloc]init];
            stops.stop_id = dic[@"stop_id"];
            stops.stop_name=dic[@"stop_name"];
            stops.stop_desc=dic[@"stop_desc"];
            stops.direction_id = dic[@"direction_id"];
            stops.stop_sequence = dic[@"stop_sequence"];
            stops.stop_lat= dic[@"stop_lat"] ;
            //stops.stop_lon= [fmt stringFromNumber:[NSNumber numberWithDouble:[dic[@"stop_lon"] doubleValue]]] ;
            stops.stop_lon= dic[@"stop_lon"];
            stops.parent_station=dic[@"parent_station"];
            [array addObject:stops];
        }
    }
    
    return array;
}

+(NSMutableArray *)getStopsTo:(NSData*)response{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    NSError *localError = nil;
    //-- JSON Parsing
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&localError];
    //NSLog(@"Result = %@",result);
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setMaximumFractionDigits:2];
    for (NSMutableDictionary *dic in result)
    {
        Stops *stops = [[Stops alloc]init];
        stops.stop_id = dic[@"stop_id"];
        stops.stop_name=dic[@"stop_name"];
        stops.stop_desc=dic[@"stop_desc"];
        stops.direction_id = dic[@"direction_id"];
        stops.stop_sequence = dic[@"stop_sequence"];
        stops.stop_lat= dic[@"stop_lat"];
        stops.stop_lon= dic[@"stop_lon"] ;
        stops.parent_station=dic[@"parent_station"];
        [array addObject:stops];
    }
    
    return array;
}


+(NSMutableArray *)getStopTimeTable:(NSData*)response{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    NSError *localError = nil;
    //-- JSON Parsing
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&localError];
    //NSLog(@"Result = %@",result);
    
    for (NSMutableDictionary *dic in result)
    {
        StopTimeTableItem *stopTime = [[StopTimeTableItem alloc]init];
        stopTime.stopRouteName = dic[@"route_name"];
        stopTime.stopFrom1Name = dic[@"departure_stop"];
        stopTime.stopFrom1Time = dic[@"departure_time"];
        stopTime.stopTo1Name = dic[@"arrival_stop"];
        stopTime.stopTo1Time = dic[@"arrival_time"];
        stopTime.tripId = dic[@"trip_id"];
        if ([array containsObject:stopTime]==FALSE){
            [array addObject:stopTime];
        }
    }
    array = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        StopTimeTableItem * stopTime = obj1;
        StopTimeTableItem * stopTime1 = obj2;
        return [stopTime compare:stopTime1];
    }];
    return array;
}


+(NSMutableArray *)getTripDetails:(NSData*)response{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    NSError *localError = nil;
    //-- JSON Parsing
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&localError];
    //NSLog(@"Result = %@",result);
    
    for (NSMutableDictionary *dic in result)
    {
        StopTimeTableDetailsItem *item = [[StopTimeTableDetailsItem alloc]init];
        item.stopId = dic[@"stop_id"];
        item.stopName = dic[@"stop_name"];
        item.arrive_time = dic[@"arrival_time"];
        item.stop_sequence = dic[@"stop_sequence"];
        [array addObject:item];
    }
    
    return array;
}

+(void) getStopsByRouteType:(NSString*) routeType indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control{
    if ([routeType isEqualToString:@"2"]){
        
        NSString * value = @"select distinct s.* from  stops s, route_stop r where r.route_type='2' and s.stop_id=r.parent_station order by s.stop_name";
        [self networkQuery:value indicator:indicatorView controller:control queryType:STOP_QUERY];
    }else{
        NSString * value = [NSString stringWithFormat:@"SELECT  distinct * FROM route_stop WHERE route_type ='%@' order by stop_name",routeType];
        [self networkQuery:value indicator:indicatorView controller:control queryType:STOP_QUERY];
    }
    
}


+(void) getStopsByStopFrom:(NSString*) stopFromId routeType:(NSString*)routeType indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control{
    if ([routeType isEqualToString:@"2"]){
        
        NSString * value = [NSString stringWithFormat:@"select * from stops where stop_id in (SELECT distinct end_s.parent_station FROM trips t INNER JOIN calendar c ON t.service_id = c.service_id   INNER JOIN routes r ON t.route_id = r.route_id  INNER JOIN stop_times start_st ON t.trip_id = start_st.trip_id   INNER JOIN stops start_s ON start_st.stop_id = start_s.stop_id   INNER JOIN stop_times end_st ON t.trip_id = end_st.trip_id   INNER JOIN stops end_s ON end_st.stop_id = end_s.stop_id  WHERE  start_s.parent_station='%@'  and end_st.arrival_time > start_st.arrival_time)",stopFromId];
        
        //NSString * value = [NSString stringWithFormat:@"select * from stops where stop_id in (select distinct parent_station from route_stop  WHERE route_id in (select distinct route_id from route_stop where parent_station = '%@') ) and stop_id != '%@'",stopFromId,stopFromId];
        
        //NSString * value = [NSString stringWithFormat:@" select distinct * from stops where stop_id in (select distinct b.parent_station from route_stop r, route_stop b where r.route_id=b.route_id and r.parent_station = '%@') and stop_id != '%@' order by stop_name ",stopFromId,stopFromId];
        [self networkQuery:value indicator:indicatorView controller:control queryType:STOP_QUERY];
    }
    else{
        //NSString * value = [NSString stringWithFormat:@"select distinct * from stops where stop_id in (select distinct b.stop_id from route_stop r, route_stop b where r.route_id=b.route_id and r.stop_id='%@' )",stopFromId];
        NSString * value = [NSString stringWithFormat:@"select * from stops where stop_id in (SELECT distinct end_s.stop_id FROM trips t INNER JOIN calendar c ON t.service_id = c.service_id   INNER JOIN routes r ON t.route_id = r.route_id  INNER JOIN stop_times start_st ON t.trip_id = start_st.trip_id   INNER JOIN stops start_s ON start_st.stop_id = start_s.stop_id   INNER JOIN stop_times end_st ON t.trip_id = end_st.trip_id   INNER JOIN stops end_s ON end_st.stop_id = end_s.stop_id  WHERE  start_s.stop_id='%@'  and end_st.arrival_time > start_st.arrival_time)",stopFromId];
        
        [self networkQuery:value indicator:indicatorView controller:control queryType:STOP_QUERY];
    }
    
}

+(void) getStopsByRouteType:(NSString*) routeType stopName:(NSString *)stopNameLike  indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control{
    
    if(stopNameLike!=nil&&stopNameLike.length>1){
        
        NSString * value = [NSString stringWithFormat:@"SELECT  distinct * FROM route_stop WHERE route_type ='%@' and lower(stop_name) like '%@' order by stop_sequence",routeType,[NSString stringWithFormat:@"%%%@%%",stopNameLike]];
        [self networkQuery:value indicator:indicatorView controller:control queryType:STOP_QUERY];
    }
}


+(void) getStopsByRouteAndFrom:(NSString*) routeId stopFrom:(Stops*)stopFrom routeType:(NSString*)routeType indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control{
    if ([routeType isEqualToString:@"2"]){
        //NSString * value = [NSString stringWithFormat:@"select distinct * from stops where stop_id in (  SELECT DISTINCT stops.parent_station FROM trips INNER JOIN stop_times ON stop_times.trip_id = trips.trip_id  INNER JOIN stops ON stops.stop_id = stop_times.stop_id  WHERE route_id = '%@' and stops.parent_station != '%@' )",routeId,stopFrom.stop_id];
        NSString * value = [NSString stringWithFormat:@"select * from stops where stop_id in (SELECT distinct end_s.parent_station FROM trips t INNER JOIN calendar c ON t.service_id = c.service_id   INNER JOIN routes r ON t.route_id = r.route_id  INNER JOIN stop_times start_st ON t.trip_id = start_st.trip_id   INNER JOIN stops start_s ON start_st.stop_id = start_s.stop_id   INNER JOIN stop_times end_st ON t.trip_id = end_st.trip_id   INNER JOIN stops end_s ON end_st.stop_id = end_s.stop_id  WHERE  start_s.parent_station='%@' and r.route_id='%@' and end_st.arrival_time > start_st.arrival_time)",stopFrom.stop_id,routeId];
        // NSString * value = [NSString stringWithFormat:@"SELECT  distinct * FROM route_stop WHERE route_id ='%@' and stop_id != '%@' order by stop_sequence",routeId,stopFrom];
        [self networkQuery:value indicator:indicatorView controller:control queryType:STOP_QUERY];
    }else{
        
        NSString * value = [NSString stringWithFormat:@"select * from stops where stop_id in (SELECT distinct end_s.stop_id FROM trips t INNER JOIN calendar c ON t.service_id = c.service_id   INNER JOIN routes r ON t.route_id = r.route_id  INNER JOIN stop_times start_st ON t.trip_id = start_st.trip_id   INNER JOIN stops start_s ON start_st.stop_id = start_s.stop_id   INNER JOIN stop_times end_st ON t.trip_id = end_st.trip_id   INNER JOIN stops end_s ON end_st.stop_id = end_s.stop_id  WHERE  start_s.stop_id='%@' and r.route_id='%@' and end_st.arrival_time > start_st.arrival_time)",stopFrom.stop_id,routeId];
        [self networkQuery:value indicator:indicatorView controller:control queryType:STOP_QUERY];
        /*
         if (stopFrom.direction_id!=nil&&stopFrom.direction_id.length!=0){
         NSString * value = [NSString stringWithFormat:@" select distinct * from stops where stop_id in (SELECT DISTINCT stops.stop_id, stops.stop_name FROM trips INNER JOIN stop_times ON stop_times.trip_id = trips.trip_id  INNER JOIN stops ON stops.stop_id = stop_times.stop_id  WHERE route_id = '%@') and stop_id != '%@' and direction_id='%@'",routeId,stopFrom.stop_id,stopFrom.direction_id];
         [self networkQuery:value indicator:indicatorView controller:control queryType:STOP_QUERY];
         }else{
         NSString * value = [NSString stringWithFormat:@" SELECT DISTINCT stops.stop_id, stops.stop_name FROM trips INNER JOIN stop_times ON stop_times.trip_id = trips.trip_id  INNER JOIN stops ON stops.stop_id = stop_times.stop_id  WHERE route_id = '%@' and stops.stop_id != '%@' ",routeId,stopFrom];
         [self networkQuery:value indicator:indicatorView controller:control queryType:STOP_QUERY];
         }
         */
        // NSString * value = [NSString stringWithFormat:@"SELECT  distinct * FROM route_stop WHERE route_id ='%@' and stop_id != '%@' order by stop_sequence",routeId,stopFrom];
        
    }
}

+(void) getStopByStopId:(NSString*) stopId indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control{
    NSString * value = [NSString stringWithFormat:@"select * from stops where stop_id = '%@'",stopId];
    [self networkQuery:value indicator:indicatorView controller:control queryType:STOP_QUERY];
}

+(void) getStopsByRoute:(NSString*) routeId  routeType:(NSString*)routeType indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control{
    if ([routeType isEqualToString:@"2"]){
        NSString * value = [NSString stringWithFormat:@" select distinct * from stops where stop_id in (SELECT DISTINCT stops.parent_station FROM trips INNER JOIN stop_times ON stop_times.trip_id = trips.trip_id  INNER JOIN stops ON stops.stop_id = stop_times.stop_id  WHERE route_id = '%@')",routeId];
        //NSString * value = [NSString stringWithFormat:@"SELECT  distinct * FROM route_stop WHERE route_id ='%@' order by stop_sequence",routeId];
        [self networkQuery:value indicator:indicatorView controller:control queryType:STOP_QUERY];
    }else{
        NSString * value = [NSString stringWithFormat:@" SELECT DISTINCT stops.stop_id, stops.stop_name FROM trips INNER JOIN stop_times ON stop_times.trip_id = trips.trip_id  INNER JOIN stops ON stops.stop_id = stop_times.stop_id  WHERE route_id = '%@'",routeId];
        //NSString * value = [NSString stringWithFormat:@"SELECT  distinct * FROM route_stop WHERE route_id ='%@' order by stop_sequence",routeId];
        [self networkQuery:value indicator:indicatorView controller:control queryType:STOP_QUERY];
    }
    
}

+(void) getStopsByRoute:(NSString*) routeId indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control stopFrom:(Stops*)from{
    
    NSString * value = [NSString stringWithFormat:@"SELECT  distinct stop_id, stop_name,  direction_id,stop_sequence FROM route_stop WHERE route_id ='%@' and direction_id='%@' and CAST(stop_sequence as integer) > %@ order by CAST(stop_sequence as integer) ",routeId ,from.direction_id,from.stop_sequence];
    
    
    [self networkQuery:value indicator:indicatorView controller:control queryType:STOP_TO_QUERY];
    
}



+(void) getTimeTable:(NSString*) routeId indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control stopFrom:(Stops*)from stopTo:(Stops*) to dayStr:(NSString*) day  routeType:(NSString*)routeType{
    if ([routeType isEqualToString:@"2"]){
        NSString * sql =[NSString stringWithFormat:@"SELECT distinct t.trip_id, r.route_short_name as route_name, start_s.stop_name as departure_stop, start_st.departure_time as departure_time, end_s.stop_name as arrival_stop,end_st.arrival_time as arrival_time 	FROM trips t INNER JOIN calendar c ON t.service_id = c.service_id   INNER JOIN routes r ON t.route_id = r.route_id  INNER JOIN stop_times start_st ON t.trip_id = start_st.trip_id   INNER JOIN stops start_s ON start_st.stop_id = start_s.stop_id   INNER JOIN stop_times end_st ON t.trip_id = end_st.trip_id   INNER JOIN stops end_s ON end_st.stop_id = end_s.stop_id  WHERE c.%@= '1'  AND start_s.parent_station='%@'  AND end_s.parent_station='%@'  ",day,from.stop_id,to.stop_id];
        [self networkQuery:sql indicator:indicatorView controller:control queryType:STOP_TIME_TABLE_QUERY ];
    }else{
        NSString * sql =[NSString stringWithFormat:@"SELECT distinct t.trip_id, r.route_short_name as route_name, start_s.stop_name as departure_stop, start_st.departure_time as departure_time, end_s.stop_name as arrival_stop,end_st.arrival_time as arrival_time 	FROM trips t INNER JOIN calendar c ON t.service_id = c.service_id   INNER JOIN routes r ON t.route_id = r.route_id  INNER JOIN stop_times start_st ON t.trip_id = start_st.trip_id   INNER JOIN stops start_s ON start_st.stop_id = start_s.stop_id   INNER JOIN stop_times end_st ON t.trip_id = end_st.trip_id   INNER JOIN stops end_s ON end_st.stop_id = end_s.stop_id  WHERE c.%@= '1'  AND start_s.stop_id='%@'  AND end_s.stop_id='%@'  ",day,from.stop_id,to.stop_id];
        [self networkQuery:sql indicator:indicatorView controller:control queryType:STOP_TIME_TABLE_QUERY ];
    }
}




+(void) getOneRoutes:stopFrom:(Stops*)from stopTo:(Stops*) to indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control {
    NSString * value = [NSString stringWithFormat:@"select * from routes where route_id in (select distinct (r.route_id) from route_stop r,route_stop b where r.stop_id = '%@' and b.stop_id = '%@' and r.route_id = b.route_id)",from.stop_id,to.stop_id];
    [self networkQuery:value indicator:indicatorView controller:control queryType:ROUTE_QUERY];
}
+(void) getStopsByLatLot:(NSString*)nwLat nwLon:(NSString*)nwLon seLat:(NSString*)seLat seLon:(NSString*)seLon indicator:(UIActivityIndicatorView*) indicatorView controller:(id<NetworkResponseProtocol>) control{
    NSString * value = [NSString stringWithFormat:@"SELECT * from stops where CAST(stop_lat as double) >= %@ and CAST(stop_lat as double)<= %@ and CAST(stop_lon as double) >= %@ and CAST(stop_lon as double) <=  %@",nwLat,seLat,nwLon,seLon];
    [self networkQuery:value indicator:indicatorView controller:control queryType:STOP_TO_QUERY];
}

+(NSString*) getTimeString:(NSString*) originStr{
    NSString * seconds = [originStr substringWithRange:NSMakeRange(4, 2)];
    NSString * minutes = [originStr substringWithRange:NSMakeRange(2,2)];
    NSString * hours = [originStr substringWithRange:NSMakeRange(0, 2)];
    int hour = [hours integerValue];
    NSString * amPm = @"am";
    if (hour>=12){
        amPm = @"pm";
    }
    if (hour > 12){
        hour = hour - 12;
    }
    hours = [NSString stringWithFormat:@"%d", hour];
    NSString * time = [NSString stringWithFormat:@"%@:%@ %@",hours,minutes,amPm];
    return time;
}


+(void) getTripDetails:(NSString *) tripId indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control{
    NSString * sql = [NSString stringWithFormat:@"SELECT s.stop_id as stop_id,stop_name, arrival_time, stop_sequence FROM stop_times st JOIN stops s ON s.stop_id=st.stop_id WHERE trip_id='%@' order by CAST(stop_sequence as integer)",tripId];
    [self networkQuery:sql indicator:indicatorView controller:control queryType:TRIP_DETAILS_QUERY];
}

+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom
{
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    
    int duration = 1; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}



@end
