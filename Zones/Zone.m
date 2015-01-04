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

- (NSString*)currentTimeWithOffset:(NSTimeInterval)offset
{
    [formatter setTimeZone:self.timeZone];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    if(offset<=0)
    return [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
    else return [NSString stringWithFormat:@"%@",[formatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:offset]]];
}

- (NSDate*)currentTime
{
    [formatter setTimeZone:self.timeZone];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    return [NSDate date];
}

/* For archiving */

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.info = [aDecoder decodeObjectForKey:@"info"];
        self.timeZone = [aDecoder decodeObjectForKey:@"timeZone"];
        CLLocationDegrees latitude = [aDecoder decodeDoubleForKey:@"latitude"];
        CLLocationDegrees longitude = [aDecoder decodeDoubleForKey:@"longitude"];
        self.location = CLLocationCoordinate2DMake(latitude,longitude);
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.info forKey:@"info"];
    [aCoder encodeObject:self.timeZone forKey:@"timeZone"];
    [aCoder encodeDouble:self.location.latitude forKey:@"latitude"];
    [aCoder encodeDouble:self.location.longitude forKey:@"longitude"];
}


@end
