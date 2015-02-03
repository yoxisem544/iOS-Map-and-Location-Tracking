//
//  ViewController.h
//  learn
//
//  Created by David on 2015/2/2.
//  Copyright (c) 2015年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager *manager;
}

@property (strong, nonatomic) IBOutlet MKMapView *map;

@end

