//
//  AppDelegate.h
//  Zones
//
//  Created by Karthik on 5/18/14.
//  Copyright (c) 2014 Karthik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Zone.h"

NSMutableArray *allZones;
NSMutableArray *temp;
CLLocationCoordinate2D tempLocation;
NSString* tempLocationName;
NSDateFormatter* formatter;
NSDateFormatter* defaultFormatter;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
