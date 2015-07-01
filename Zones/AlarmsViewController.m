//
//  AlarmsViewController.m
//  Zones
//
//  Created by Karthik on 3/23/15.
//  Copyright (c) 2015 Karthik. All rights reserved.
//

#import "AlarmsViewController.h"

@interface AlarmsViewController ()

@end

@implementation AlarmsViewController

@synthesize datePicker, reminderName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.datePicker.timeZone = self.zone.timeZone;
    self.datePicker.minimumDate = [NSDate date];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismiss:(UIGestureRecognizer*)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addAlarm
{
    UILocalNotification* alarm = [[UILocalNotification alloc] init];
	alarm.alertBody = self.reminderName.text;
    alarm.fireDate = self.datePicker.date;
    alarm.repeatInterval = 0;
	alarm.userInfo = [NSDictionary dictionaryWithObject:[[NSProcessInfo processInfo] globallyUniqueString] forKey:@"alarmID"];
	
	NSDictionary *alarmInfo = [NSDictionary dictionaryWithObjectsAndKeys:
						   [alarm.userInfo objectForKey:@"alarmID"], @"alarmID",
						   alarm.fireDate, @"date",
						   alarm.alertBody, @"name", nil];
    
    [defaultFormatter setDateStyle:NSDateFormatterMediumStyle];
    [defaultFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [defaultFormatter setTimeZone:self.zone.timeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:alarm];
    [[[allZones objectAtIndex:[Zone getActualIndexOf:self.zone]] reminders] addObject: alarmInfo];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[[allZones objectAtIndex:[Zone getActualIndexOf:self.zone]] reminders] count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* alarmID = [[[[allZones objectAtIndex:[Zone getActualIndexOf:self.zone]] reminders] objectAtIndex:indexPath.row] objectForKey:@"alarmID"];
	
	for(UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
  if([[notification.userInfo objectForKey:@"alarmID"] isEqualToString:alarmID]) {
	  [[UIApplication sharedApplication] cancelLocalNotification:
notification];
	  break;
  }
	}
	[[[allZones objectAtIndex:[Zone getActualIndexOf:self.zone]] reminders] removeObjectAtIndex:indexPath.row];
	[tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellID = @"ZoneCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	
	if (cell==nil)
	{
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
	}
	NSDictionary* reminder = [[[allZones objectAtIndex:[Zone getActualIndexOf:self.zone]] reminders] objectAtIndex:indexPath.row];
	cell.textLabel.text = [reminder objectForKey:@"name"];
	[defaultFormatter setDateStyle:NSDateFormatterMediumStyle];
	[defaultFormatter setTimeStyle:NSDateFormatterShortStyle];
	[defaultFormatter setTimeZone:self.zone.timeZone];
	cell.detailTextLabel.text = [defaultFormatter stringFromDate:[reminder objectForKey:@"date"]];
	return cell;
}
@end
