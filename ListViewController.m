//
//  ListViewController.m
//  Zones
//
//  Created by Karthik on 5/18/14.
//  Copyright (c) 2014 Karthik. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController

@synthesize zonesTable, editZonesButton, timePeekSlider;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self beginTimer];
    self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:0.11 green:0.72 blue:0.99 alpha:1];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [zonesTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    if([allZones count]==0) editZonesButton.enabled=NO;
    else editZonesButton.enabled=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* UITableView delegates */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allZones count];
}

- (ZoneCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"ZoneCell";
    
    ZoneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell==nil)
    {
        cell = [[ZoneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        //newCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.locationName.text=[[[allZones objectAtIndex:indexPath.row] name] uppercaseString];
    cell.timestamp.text=[[allZones objectAtIndex:indexPath.row] currentTimeWithOffset:timePeekSlider.value];
    //cell.timestamp.font=[UIFont fontWithName:@"Akkurat-Mono" size:29.0];
    cell.backgroundColor=[self backgroundColorForTime:cell.timestamp.text];
    
    //Mark reference point
    if(indexPath.row == 0)
    {
        cell.flagIcon.text = @"⚑";
    }
    else cell.flagIcon.text = [[allZones objectAtIndex:indexPath.row] getflagIcon:timePeekSlider.value];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [allZones removeObjectAtIndex:indexPath.row];
    [zonesTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [timer invalidate];
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self beginTimer];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSObject* temp = [[NSObject alloc] init];
    temp = [allZones objectAtIndex:sourceIndexPath.row];
    [allZones removeObjectAtIndex:sourceIndexPath.row];
    [allZones insertObject:temp atIndex:destinationIndexPath.row];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlarmsViewController* alarmsVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"AlarmsVC"];
    alarmsVC.modalPresentationStyle=UIModalPresentationOverFullScreen;
    [self presentViewController:alarmsVC animated:YES completion:nil];
}

//Edit zones list
- (IBAction)editZones:(UIBarButtonItem *)sender
{
    if([zonesTable isEditing]==YES)
    {
        sender.title=@"Edit";
        [zonesTable setEditing:NO animated:YES];
        [self beginTimer];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut animations:^{
                                timePeekSlider.alpha = 1.0;
                                [timePeekSlider setHidden:NO];
                            }
                         completion:^(BOOL finished) {
                         }];
    }
    else if ([zonesTable isEditing]==NO)
    {
        [zonesTable setEditing:YES animated:YES];
        sender.title=@"Done";
        [timer invalidate];
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut animations:^{
                                timePeekSlider.alpha = 0.0;
                            }
                         completion:^(BOOL finished) {
                             [timePeekSlider setHidden:YES];
                         }];
    }
}

- (IBAction)timePeekChanged:(UISlider*)sender
{
    if(allZones.count>0)
        [[allZones firstObject] currentTimeWithOffset:timePeekSlider.value];
    
    
    /*UIView* changeView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width/2)-50, ([UIScreen mainScreen].bounds.size.height/2)-50, 100, 100)];
     changeView.layer.cornerRadius=5;
     changeView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
     UILabel* offsetLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
     offsetLabel.font = [UIFont fontWithName:@"Menlo" size:40];
     offsetLabel.textColor = [UIColor whiteColor];
     offsetLabel.text = [NSString stringWithFormat:@"+ %0.0f",timePeekSlider.value/3600];
     [self.view addSubview:changeView];
     if(![offsetLabel isDescendantOfView:changeView])
     [changeView addSubview:offsetLabel];*/
    
    /*[UIView animateWithDuration:1.0
     delay:3.0
     options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAutoreverse
     animations: ^{
     
     }
     completion:^(BOOL finished){
     [changeView removeFromSuperview];
     }];*/
}

- (IBAction)timePeekSwipe:(UIPanGestureRecognizer*)sender
{
    CGPoint velocity = [sender velocityInView:self.view];
    if (velocity.x > 0) {
        timePeekSlider.value += fabs(velocity.x);
    }
    else {
        timePeekSlider.value -= fabs(velocity.x);
    }
}

- (void)beginTimer
{
    timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:0.1 target:zonesTable selector:@selector(reloadData) userInfo:nil repeats:YES];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        [timer fire];
    }];
}

- (UIColor*)backgroundColorForTime:(NSString*)currentTime
{
    NSDictionary* colors = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [UIColor colorWithHue:0.67 saturation:0.41 brightness:0.30 alpha:1.0],@"12AM",
                            [UIColor colorWithHue:0.67 saturation:0.41 brightness:0.30 alpha:1.0],@"1AM",
                            [UIColor colorWithHue:0.67 saturation:0.41 brightness:0.40 alpha:1.0],@"2AM",
                            [UIColor colorWithHue:0.67 saturation:0.41 brightness:0.45 alpha:1.0],@"3AM",
                            [UIColor colorWithHue:0.67 saturation:0.41 brightness:0.55 alpha:1.0],@"4AM",
                            [UIColor colorWithHue:0.67 saturation:0.61 brightness:0.65 alpha:1.0],@"5AM",
                            [UIColor colorWithHue:0.07 saturation:0.70 brightness:0.86 alpha:1.0],@"6AM",
                            [UIColor colorWithHue:0.13 saturation:0.60 brightness:0.90 alpha:1.0],@"7AM",
                            [UIColor colorWithHue:0.60 saturation:0.60 brightness:0.99 alpha:1.0],@"8AM",
                            [UIColor colorWithHue:0.60 saturation:0.75 brightness:0.99 alpha:1.9],@"9AM",
                            [UIColor colorWithHue:0.60 saturation:0.80 brightness:0.99 alpha:1.0],@"10AM",
                            [UIColor colorWithHue:0.55 saturation:0.85 brightness:0.99 alpha:1.0],@"11AM",
                            [UIColor colorWithHue:0.55 saturation:0.90 brightness:0.99 alpha:1.0],@"12PM",
                            [UIColor colorWithHue:0.55 saturation:0.95 brightness:0.99 alpha:1.0],@"1PM",
                            [UIColor colorWithHue:0.55 saturation:0.99 brightness:0.99 alpha:1.0],@"2PM",
                            [UIColor colorWithHue:0.55 saturation:0.95 brightness:0.85 alpha:1.0],@"3PM",
                            [UIColor colorWithHue:0.59 saturation:0.55 brightness:0.65 alpha:1.0],@"4PM",
                            [UIColor colorWithHue:0.85 saturation:0.51 brightness:0.61 alpha:1.0],@"5PM",
                            [UIColor colorWithHue:0.80 saturation:0.41 brightness:0.41 alpha:1.0],@"6PM",
                            [UIColor colorWithHue:0.61 saturation:0.71 brightness:0.51 alpha:1.0],@"7PM",
                            [UIColor colorWithHue:0.61 saturation:0.71 brightness:0.45 alpha:1.0],@"8PM",
                            [UIColor colorWithHue:0.61 saturation:0.61 brightness:0.40 alpha:1.0],@"9PM",
                            [UIColor colorWithHue:0.61 saturation:0.51 brightness:0.35 alpha:1.0],@"10PM",
                            [UIColor colorWithHue:0.61 saturation:0.51 brightness:0.30 alpha:1],@"11PM",
                            nil];
    
    NSMutableString* time = [NSMutableString stringWithString:[currentTime componentsSeparatedByString:@":"][0]];
    [time appendString:([currentTime containsString:@"AM"] ? @"AM" : @"PM")];
    
    return [colors valueForKey:time];
}

@end
