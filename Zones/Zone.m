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

//Designated initializer
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
        self.reminders=[[NSMutableArray alloc] init];
    }
    return self;
}

- (id)init
{
    return [self initWithName:@"Name" info:@"info" timeZone:nil location:CLLocationCoordinate2DMake(0, 0)];
}

//Find exact match during filtering
+ (NSInteger)getActualIndexOf:(Zone*)current
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

- (NSString*)currentTimeWithOffset:(NSTimeInterval)offset
{
    [formatter setTimeZone:self.timeZone];
    NSString* currentTime = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:offset]]];
    return currentTime;
}

- (NSString*)getflagIcon:(NSTimeInterval)offset
{
    //Compare if next or prev day
    [defaultFormatter setTimeZone:self.timeZone];
    NSString* currentZone = [defaultFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:offset]];
    [defaultFormatter setTimeZone:[[allZones firstObject] timeZone]];
    NSString* refZone = [defaultFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:offset]];
    
    if([currentZone intValue] > [refZone intValue])
        return @" ⃕";
    else if ([currentZone intValue] < [refZone intValue])
        return @" ⃔";
    else
        return @"";
}

- (void)addReminder:(NSString*)reminder
{
    [self.reminders addObject:reminder];
}

- (NSDate*)currentTime
{
    [formatter setTimeZone:self.timeZone];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    return [NSDate date];
}

/* For archiving */

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.info = [aDecoder decodeObjectForKey:@"info"];
        self.timeZone = [aDecoder decodeObjectForKey:@"timeZone"];
        CLLocationDegrees latitude = [aDecoder decodeDoubleForKey:@"latitude"];
        CLLocationDegrees longitude = [aDecoder decodeDoubleForKey:@"longitude"];
        self.location = CLLocationCoordinate2DMake(latitude,longitude);
        self.reminders = [aDecoder decodeObjectForKey:@"reminders"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.info forKey:@"info"];
    [aCoder encodeObject:self.timeZone forKey:@"timeZone"];
    [aCoder encodeDouble:self.location.latitude forKey:@"latitude"];
    [aCoder encodeDouble:self.location.longitude forKey:@"longitude"];
    [aCoder encodeObject:self.reminders forKey:@"reminders"];
}

@end
