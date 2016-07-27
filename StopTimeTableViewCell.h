//
//  StopTimeTableViewCell.h
//  brisbane.transit
//
//  Created by Bo Wang on 18/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StopTimeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLeft;
@property (weak, nonatomic) IBOutlet UILabel *stopFromName;
@property (weak, nonatomic) IBOutlet UILabel *stopToName;
@property (weak, nonatomic) IBOutlet UILabel *stopFromTime;
@property (weak, nonatomic) IBOutlet UILabel *stopToTime;
@property (weak, nonatomic) IBOutlet UILabel *routeName;

@end
