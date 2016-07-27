//
//  Utilities.h
//  BuildingInspection
//
//  Created by Bo Wang on 14/09/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utilities : NSObject
+(NSString *)documentsPath:(NSString *)fileName;
+(NSString *)getPresentDateTime;
+(NSString *)getDateString:(NSDate*)date;
+(NSDate *)getDateFromString:(NSString*)dateStr;

+(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;
+(NSData*)getImageData:(UIImage*)uiImage;

+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom;

@end
