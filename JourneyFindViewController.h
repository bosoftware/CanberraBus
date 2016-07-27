//
//  JourneyFindViewController.h
//  brisbane.transit
//
//  Created by Bo Wang on 18/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface JourneyFindViewController : UIViewController<CLLocationManagerDelegate> 
@property (weak, nonatomic) IBOutlet UIButton *getCurrentLocationBtn;
@property (weak, nonatomic) IBOutlet UITextField *startFrom;
@property (weak, nonatomic) IBOutlet UITextField *stopTo;
@property (weak, nonatomic) IBOutlet UIButton *findJourney;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegment;
@property (weak, nonatomic) IBOutlet UIDatePicker *myDatePicker;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *myIndicator;
@property (nonatomic,retain) NSString *departType;
@end
