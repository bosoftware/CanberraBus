//
//  GoogleDirectionUtil.m
//  brisbane.transit
//
//  Created by Bo Wang on 19/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import "GoogleDirectionUtil.h"
#import "NetworkResponseProtocol.h"
#import "AFHTTPClient.h"
#import "GtfsUtility.h"
#import "RouteJson.h"
#import "prefix.h"
#import "StepJson.h"

@implementation GoogleDirectionUtil
+(void) getGoogleJsonRoutes:(NSString*) url indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control{
    [GoogleDirectionUtil networkQuery:url indicator:indicatorView controller:control];
}


+(void) networkQuery:(NSString *) url  indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control{
    NSDictionary * parameters = nil;
    NSString *newurl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSString * newurl = [GoogleDirectionUtil urlencode:url];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:newurl]];
    [client getPath:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *rss = nil;
        if ([responseObject isKindOfClass:[NSData class]]) {
            rss = (NSData*)responseObject;//[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        } else {
            rss = (NSString *)responseObject;
        }
        if ([control conformsToProtocol:@protocol(NetworkResponseProtocol)]==YES){
            NSMutableArray *    array =[self  getJsonRoutes:rss];
            [control setResponseArray:array];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [indicatorView stopAnimating];
        [GtfsUtility ToastNotification:@"Sorry, Network Issue, Please try it again. thanks"  andView:self andLoading:NO andIsBottom:NO];
        //ShowAlerViewWithMessage( @"Sorry, Network Issue, Please try it again. thanks" );
    }];
    
}

+(StepJson*) getStepJson:(NSMutableDictionary*)step{
    StepJson * stepJson = [[StepJson alloc]init];
    stepJson.distance = (NSMutableDictionary*)step[@"distance"][@"text"];
    stepJson.duration = (NSMutableDictionary*)step[@"duration"][@"text"];
    stepJson.htmlInstruction = step[@"html_instructions"];
    stepJson.travelMode = step[@"travel_mode"];
    NSMutableDictionary * transdetails = step[@"transit_details"];
    if (transdetails!=nil){
        stepJson.transitJson = [GoogleDirectionUtil getTransitJson:transdetails];
    }
    NSArray * stepsStep = step[@"steps"];
    stepJson.stepJsonList=[[NSMutableArray alloc]init];
    if (stepsStep!=nil){
        for (NSMutableDictionary * stepDic in stepsStep){
            [stepJson.stepJsonList addObject:[GoogleDirectionUtil getStepJson:stepDic]];
        }
    }
    return stepJson;
}

+(TransitJson*) getTransitJson:(NSMutableDictionary*)transit{
    TransitJson * transitJson = [[TransitJson alloc]init];
    NSMutableDictionary * line = transit[@"line"];
    transitJson.transitName = line[@"short_name"];
    transitJson.longName = line[@"name"];
    transitJson.type = (NSMutableDictionary*)line[@"vehicle"][@"type"];
    transitJson.fromStop = (NSMutableDictionary*)transit[@"departure_stop"][@"name"];
    transitJson.fromTime=(NSMutableDictionary*)transit[@"departure_time"][@"text"];
    transitJson.toStop=(NSMutableDictionary*)transit[@"arrival_stop"][@"name"];
    transitJson.toTime=(NSMutableDictionary*)transit[@"arrival_time"][@"text"];

    return transitJson;
}

+(NSMutableArray *)getJsonRoutes:(NSData*)response{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    NSError *localError = nil;
    //-- JSON Parsing
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&localError];
    if (localError != nil) {
        ShowAlerViewWithMessage( @"Sorry, Cannot find your trip, please search it with accurate address." );
        return nil;
    }
    NSArray *routesResult = [result valueForKey:@"routes"];
    
    for (NSMutableDictionary *dic in routesResult)
    {
        
        RouteJson *routes = [[RouteJson alloc]init];
        routes.steps = [[NSMutableArray alloc]init];
        NSArray * legs = dic[@"legs"];
        NSMutableDictionary * legdic = [legs objectAtIndex:0];
        routes.arriveTime = ((NSMutableDictionary*)legdic[@"arrival_time"])[@"text"];
        routes.departTime = (NSMutableDictionary*)legdic[@"departure_time"][@"text"];
        routes.distance = (NSMutableDictionary*)legdic[@"distance"][@"text"];
        routes.duration = (NSMutableDictionary*)legdic[@"duration"][@"text"];
        NSArray *legsteps = legdic[@"steps"];
        if (legsteps!=nil){
            for (NSMutableDictionary *stepDic in legsteps){
                [routes.steps addObject:[GoogleDirectionUtil getStepJson:stepDic]];
            }
        }
        [array addObject:routes];
    }
    
    return array;
}
+(NSString *)urlencode:(NSString*)org {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[org UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}
@end
