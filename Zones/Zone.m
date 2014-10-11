//
//  Zone.m
//  Zone
//
//  Created by Karthik on 5/18/14.
//  Copyright (c) 2014 Karthik. All rights reserved.
//

#import "Zone.h"
#import "AppDelegate.h"

@implementation Zone

/*Designated initializer*/
- (Zone*)initWithName:(NSString*) name
                 info:(NSString*) info
             timeZone:(NSTimeZone*) timeZone
             location:(CLLocationCoordinate2D) location
{
    if(self=[super init])
    {
        self.name=name;
        self.info=info;
        self.timeZone=timeZone;
        self.location=location;
    }
    return self;
}

/*Simple Initializer*/

- (id) init
{
    return [self initWithName:@"Name" info:@"info" timeZone:nil location:CLLocationCoordinate2DMake(0, 0)];
}

/*To find index of object for filtered views*/
+ (NSInteger) getActualIndexOf:(Zone*)current
{
    NSInteger index = 0;
    for (temp in allZones)
    {
        if([temp isEqual:current])
        {
            index=[allZones indexOfObject:current];
        }
    }
    return index;
}

- (NSString*)currentTime
{
    [formatter setTimeZone:self.timeZone];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    return [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
}

@end
