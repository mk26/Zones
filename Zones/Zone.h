//
//  Zone.h
//  Zone
//
//  Created by Karthik on 5/18/14.
//  Copyright (c) 2014 Karthik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Zone : NSObject

/*Designated initializer*/
- (Zone*)initWithName:(NSString*) name
                 info:(NSString*) info
             timeZone:(NSTimeZone*) timeZone
             location:(CLLocationCoordinate2D) location;
- (id)init;

+ (NSInteger)getActualIndexOf:(Zone*)current; //used for filter views
- (NSString*)currentTimeWithOffset:(NSTimeInterval)offset;
- (NSString*)getflagIcon:(NSTimeInterval)offset;
- (void)addReminder:(NSString*)reminder;

@property (strong,nonatomic) NSString* name;
@property (strong,nonatomic) NSString* info;
@property (strong,nonatomic) NSTimeZone* timeZone;
@property (assign,nonatomic) CLLocationCoordinate2D location;
@property (strong,nonatomic) NSMutableArray* reminders;

@end
