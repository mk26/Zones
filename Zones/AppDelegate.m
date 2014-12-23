//
//  AppDelegate.m
//  Zones
//
//  Created by Karthik on 5/18/14.
//  Copyright (c) 2014 Karthik. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    formatter = [[NSDateFormatter alloc] init];
    allZones = [[NSMutableArray alloc] init];
    [self loadData];
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/* Data Storage */
- (NSString*) savedDataLocation
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filename = [documentsDirectory stringByAppendingPathComponent:@"zonesdata.archive"];
    
    return filename;
}

- (void) saveData
{
    NSString *filename = [self savedDataLocation];
    
    NSMutableData *outputBuffer = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                 initForWritingWithMutableData:outputBuffer];
    
    [archiver encodeObject:allZones forKey:@"zoneList"];
    
    [archiver finishEncoding];
    [outputBuffer writeToFile:filename atomically:YES];
    
    NSLog(@"Saving data to %@", filename);
}

- (void) loadData
{
    NSMutableArray *loadedZones = [[NSMutableArray alloc] init];
    
    NSString *filename = [self savedDataLocation];
    NSData *inputData = [[NSData alloc] initWithContentsOfFile:filename];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]
                                     initForReadingWithData:inputData];
    
    loadedZones = [unarchiver decodeObjectForKey:@"zoneList"];
    
    if(loadedZones!=NULL)
        allZones=[NSMutableArray arrayWithArray:loadedZones];
    
    NSLog(@"Loading data from %@", filename);
}

@end
