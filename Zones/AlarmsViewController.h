//
//  AlarmsViewController.h
//  Zones
//
//  Created by Karthik on 3/23/15.
//  Copyright (c) 2015 Karthik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Zone.h"

@interface AlarmsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) Zone* zone;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *reminderName;

- (IBAction)dismiss:(UIGestureRecognizer*)sender;
- (IBAction)dismiss;
- (IBAction)addAlarm;

@end
