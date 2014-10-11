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
    
    /*self.view.backgroundColor = [UIColor clearColor];
    UIToolbar* bgToolbar = [[UIToolbar alloc] initWithFrame:self.view.frame];
    bgToolbar.barStyle = UIBarStyleDefault;
    [self.view.superview insertSubview:bgToolbar belowSubview:self.view];*/
    
    //self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [zoneNameField becomeFirstResponder];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
       /* NSURL* timeZoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/timezone/json?location=%f,%f&timestamp=%f",tempLocation.latitude,tempLocation.longitude,[[NSDate date] timeIntervalSince1970]]];
        
        NSData* rawtimeZoneData = [NSData dataWithContentsOfURL:timeZoneURL];
        NSDictionary* timeZoneData = [NSJSONSerialization JSONObjectWithData:rawtimeZoneData options:0 error:nil];
        
        //Create Time zone object from retrieved data
        timeZone = [NSTimeZone timeZoneWithName:[timeZoneData objectForKey:@"timeZoneId"]];
        */
        
        //Set labels on screen
        zoneNameField.text=[NSString stringWithFormat:@"%@",tempLocationName];
        latLabel.text=[NSString stringWithFormat:@"%f",tempLocation.latitude];
        longLabel.text=[NSString stringWithFormat:@"%f",tempLocation.longitude];
        timeZoneLabel.text=[NSString stringWithFormat:@"%@",timeZone.abbreviation];
        
        if ([timeZone isDaylightSavingTime])
            dstLabel.backgroundColor=[UIColor colorWithRed:0.93 green:0.29 blue:0.13 alpha:1];
        else dstLabel.backgroundColor=[UIColor grayColor];
        
        //Set Time
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [NSTimer scheduledTimerWithTimeInterval:0.01
                                             target:self
                                           selector:@selector(updateTime)
                                           userInfo:nil
                                            repeats:YES];
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Add or cancel */

- (void)addZone:(UIBarButtonItem *)sender
{
    if(timeZone!=nil)
    {
        Zone *zone = [[Zone alloc] initWithName:zoneNameField.text info:nil timeZone:timeZone location:tempLocation];
        [allZones addObject:zone];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

- (void)addCancelled:(UIBarButtonItem *)sender
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
