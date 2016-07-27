//
//  GtfsUtility.h
//  brisbane.transit
//
//  Created by Bo Wang on 12/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NetworkResponseProtocol.h"
#import "Stops.h"
@interface GtfsUtility : NSObject


+(void) getRoutesByType:(NSString*) routeType indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control;


+(void) getStopsByRoute:(NSString*) routeId  routeType:(NSString*)routeType indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control;

+(void) getStopsByRoute:(NSString*) routeId indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control stopFrom:(Stops*)from;

+(void) getTimeTable:(NSString*) routeId indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control stopFrom:(Stops*)from stopTo:(Stops*) to dayStr:(NSString*) day  routeType:(NSString*)routeType;
+(void) getTripDetails:(NSString *) tripId indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control;

+(NSString*) getTimeString:(NSString*) originStr;
+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom;
+(void) getStopsByRouteType:(NSString*) routeType indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control;
+(void) getStopsByRouteType:(NSString*) routeType stopName:(NSString *)stopName  indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control;

+(void) getStopsByStopFrom:(NSString*) stopFromId routeType:(NSString*)routeType indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control;
+(void) getStopsByRouteAndFrom:(NSString*) routeId stopFrom:(Stops*)stopFrom routeType:(NSString*)routeType indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control;

+(void) getStopsByLatLot:(NSString*)nwLat nwLon:(NSString*)nwLon seLat:(NSString*)seLat seLon:(NSString*)seLon indicator:(UIActivityIndicatorView*) indicatorView controller:(id<NetworkResponseProtocol>) control;

+(void) getStopByStopId:(NSString*) stopId indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control;


@end
