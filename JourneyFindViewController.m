//
//  JourneyFindViewController.m
//  brisbane.transit
//
//  Created by Bo Wang on 18/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import "JourneyFindViewController.h"
#import "GtfsUtility.h"
#import "JourneyFindTableViewController.h"
#import "prefix.h"
@interface JourneyFindViewController (){
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

@end

@implementation JourneyFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _departType = @"departure_time";
    [_myIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (IBAction)findJourney:(id)sender {
//    NSString * startAddress = _startFrom.text;
//    NSString * endAddress = _stopTo.text;
//    int seconds = [[_myDatePicker date] timeIntervalSince1970];
//    NSString * url = [GOOGLE_MAP_URL stringByReplacingOccurrencesOfString:@"<start>" withString:startAddress];
//    url = [url stringByReplacingOccurrencesOfString:@"<stop>" withString:endAddress];
//    url = [url stringByReplacingOccurrencesOfString:@"<depart_type>" withString:_departType];
//    url = [url stringByReplacingOccurrencesOfString:@"<depart_time>" withString:[NSString stringWithFormat:@"%d",seconds]];
//    url = [url stringByAddingPercentEscapesUsingEncoding:url];
//}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"findJourney"]){
        NSString * startAddress = _startFrom.text;
        NSString * endAddress = _stopTo.text;
        JourneyFindTableViewController *controller = [segue destinationViewController];
        controller.startAddress=startAddress;
        controller.stopAddress=endAddress;
        int seconds = [[_myDatePicker date] timeIntervalSince1970];
        NSString * url = [GOOGLE_MAP_URL stringByReplacingOccurrencesOfString:@"<start>" withString:startAddress];
        url = [url stringByReplacingOccurrencesOfString:@"<stop>" withString:endAddress];
        url = [url stringByReplacingOccurrencesOfString:@"<depart_type>" withString:_departType];
        url = [url stringByReplacingOccurrencesOfString:@"<depart_time>" withString:[NSString stringWithFormat:@"%d",seconds]];
        //url = [url stringByAddingPercentEscapesUsingEncoding:url];
        controller.url = url;
    }
}
- (IBAction)changeSeg:(id)sender {
    if (_mySegment.selectedSegmentIndex==1){
        _departType=@"arrival_time";
    }
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    BOOL rtn = TRUE;
    NSString * startAddress = _startFrom.text;
    if ([startAddress length]==0){
        ShowAlerViewWithMessage(@"Please input departure address");
        return FALSE;
    }
    NSString * endAddress = _stopTo.text;
    if ([endAddress length]==0){
        //[GtfsUtility ToastNotification:@"Please input destination address" andView:self.view andLoading:NO andIsBottom:NO];
        ShowAlerViewWithMessage(@"Please input destination address");
        return FALSE;
    }
    return rtn;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [_myIndicator stopAnimating];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"\nCurrent Location Detected\n");
             NSLog(@"placemark %@",placemark);
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             NSString *Address = [[NSString alloc]initWithString:locatedAt];
             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
             NSString *Country = [[NSString alloc]initWithString:placemark.country];
             
             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
             
             //NSString *address = [NSString stringWithFormat:@"%@ %@ %@",Address,Area, Country];
             _startFrom.text = Address;
             NSLog(@"%@",CountryArea);
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             [GtfsUtility ToastNotification:@"Sorry,Cannot get your current location!" andView:self.view andLoading:NO andIsBottom:NO];
         }
         /*---- For more results
          placemark.region);
          placemark.country);
          placemark.locality);
          placemark.name);
          placemark.ocean);
          placemark.postalCode);
          placemark.subLocality);
          placemark.location);
          ------*/
     }];
}
- (IBAction)getCurrentLocation:(id)sender {
    [locationManager requestWhenInUseAuthorization];
    [_myIndicator startAnimating];
    [locationManager startUpdatingLocation];
}
- (IBAction)switch:(id)sender {
    NSString * from = _startFrom.text;
    NSString * to = _stopTo.text;
    _startFrom.text=to;
    _stopTo.text=from;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
@end
