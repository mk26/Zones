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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allZones count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"ZoneCell";
    
    UITableViewCell *newCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (newCell==nil)
    {
        newCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        newCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    newCell.textLabel.text=[[allZones objectAtIndex:indexPath.row] name];
    newCell.detailTextLabel.text=[[allZones objectAtIndex:indexPath.row] currentTime];
    
    return newCell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [allZones removeObjectAtIndex:indexPath.row];
    [zonesTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [timer invalidate];
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self beginTimer];
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
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

//Edit zones list
- (IBAction)editZones:(UIBarButtonItem *)sender
{
    if([zonesTable isEditing]==YES)
    {
        sender.title=@"Edit";
        [zonesTable setEditing:NO animated:YES];
        [self beginTimer];
    }
    else if ([zonesTable isEditing]==NO)
    {
        [zonesTable setEditing:YES animated:YES];
        sender.title=@"Done";
        [timer invalidate];
    }
}

- (IBAction)timePeekChanged:(UISlider*)sender
{
    
    
}

- (void)beginTimer
{
    timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:0.01 target:zonesTable selector:@selector(reloadData) userInfo:nil repeats:YES];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [timer fire];
    }];
}

@end
