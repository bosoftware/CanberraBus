//
//  Utilities.m
//  BuildingInspection
//
//  Created by Bo Wang on 14/09/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import "Utilities.h"


#define DATE_FORMMAT @"yyyy-MM-dd"

@implementation Utilities
+(NSString *)documentsPath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}
+(NSString *)getPresentDateTime{
    
    NSDateFormatter *dateTimeFormat = [[NSDateFormatter alloc] init];
    [dateTimeFormat setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *theDateTime = [dateTimeFormat stringFromDate:now];
    
    dateTimeFormat = nil;
    now = nil;
    
    return theDateTime;
}


+(NSString *)getDateString:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMMAT];
    NSString *stringDate = [dateFormatter stringFromDate:date];
    return stringDate;
}
+(NSDate *)getDateFromString:(NSString*)dateStr{
   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:DATE_FORMMAT];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:dateStr];
    return dateFromString;
}
+(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(NSData*)getImageData:(UIImage*)uiImage{
    NSData *imageData = UIImagePNGRepresentation(uiImage);
    return imageData;
}

+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom
{
//    GCDiscreetNotificationView *notificationView = [[GCDiscreetNotificationView alloc] initWithText:text showActivity:isLoading inPresentationMode:isBottom ? GCDiscreetNotificationViewPresentationModeBottom : GCDiscreetNotificationViewPresentationModeTop inView:view];
//    [notificationView show:YES];
//    [notificationView hideAnimatedAfter:2.6];
//    
//    NSString *message = @"Please input item name";
    
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
