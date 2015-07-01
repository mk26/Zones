//
//  AddViewController.m
//  Zones
//
//  Created by Karthik on 6/19/14.
//  Copyright (c) 2014 Karthik. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController


@synthesize timeZone, zoneNameField, latLabel, longLabel, timeZoneLabel, timeLabel, dstLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.previousVC = (UITabBarController*) self.presentingViewController;
    [zoneNameField becomeFirstResponder];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        //Set labels on screen
        zoneNameField.text=[NSString stringWithFormat:@"%@",tempLocationName];
        latLabel.text=[NSString stringWithFormat:@"%f",tempLocation.latitude];
        longLabel.text=[NSString stringWithFormat:@"%f",tempLocation.longitude];
        timeZoneLabel.text=[NSString stringWithFormat:@"%@",timeZone.abbreviation];
        
        if ([timeZone isDaylightSavingTime])
            dstLabel.backgroundColor=[UIColor colorWithRed:0.93 green:0.29 blue:0.13 alpha:1];
        else dstLabel.backgroundColor=[UIColor grayColor];
        
        //Set Time
        [NSTimer scheduledTimerWithTimeInterval:0.1
                                         target:self
                                       selector:@selector(updateTime)
                                       userInfo:nil
                                        repeats:YES];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Add timezone
- (void)addZone:(UIBarButtonItem *)sender
{
    if(timeZone!=nil)
    {
        Zone *zone = [[Zone alloc] initWithName:zoneNameField.text info:nil timeZone:timeZone location:tempLocation];
        [allZones addObject:zone];
        [self dismissViewControllerAnimated:YES completion:^{
            [self.previousVC setSelectedIndex:0];
        }];
    }
}

//Cancel adding timezone
- (void)addCancelled:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismiss:(UIGestureRecognizer*)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateTime
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [formatter setTimeZone:timeZone];
        [formatter setDateStyle:NSDateFormatterNoStyle];
        [formatter setTimeStyle:NSDateFormatterMediumStyle];
        timeLabel.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
    }];
}

@end