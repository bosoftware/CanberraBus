//
//  GoogleDirectionUtil.h
//  brisbane.transit
//
//  Created by Bo Wang on 19/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NetworkResponseProtocol.h"
#import "StepJson.h"
#import "TransitJson.h"

@interface GoogleDirectionUtil : NSObject
+(void) getGoogleJsonRoutes:(NSString*) url indicator:(UIActivityIndicatorView*) indicatorView  controller:(id<NetworkResponseProtocol>) control;
+(StepJson*) getStepJson:(NSMutableDictionary*)step;
+(TransitJson*) getTransitJson:(NSMutableDictionary*)transit;
@end
