//
//  AddViewController.h
//  Zones
//
//  Created by Karthik on 6/19/14.
//  Copyright (c) 2014 Karthik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MapViewController.h"


NSTimeZone *timeZone;

@interface AddViewController : UIViewController

- (IBAction)addCancelled:(UIBarButtonItem*)sender;
- (IBAction)dismiss:(UIGestureRecognizer*)sender;
- (IBAction)addZone:(UIBarButtonItem *)sender;

@property (strong, nonatomic) NSTimeZone* timeZone;

@property (weak, nonatomic) IBOutlet UITextField *zoneNameField;
@property (weak, nonatomic) IBOutlet UILabel *latLabel;
@property (weak, nonatomic) IBOutlet UILabel *longLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeZoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dstLabel;

@end
