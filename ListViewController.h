//
//  ListViewController.h
//  Zones
//
//  Created by Karthik on 5/18/14.
//  Copyright (c) 2014 Karthik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AddViewController.h"
#import "AlarmsViewController.h"
#import "ZoneCell.h"

NSTimer *timer;

@interface ListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (IBAction)editZones:(UIBarButtonItem*)sender;
- (IBAction)timePeekChanged:(UISlider*)sender;
- (IBAction)timePeekSwipe:(UIGestureRecognizer*)sender;

@property (weak, nonatomic) IBOutlet UISlider *timePeekSlider;
@property (weak, nonatomic) IBOutlet UITableView *zonesTable;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editZonesButton;

@end
