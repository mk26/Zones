//
//  ZoneCell.m
//  Zones
//
//  Created by Karthik on 3/24/15.
//  Copyright (c) 2015 Karthik. All rights reserved.
//

#import "ZoneCell.h"

@implementation ZoneCell

@synthesize locationName, timestamp, flagIcon, alarms;

- (void)awakeFromNib
{
    // Initialization code
    self.locationName = locationName;
    self.timestamp = timestamp;
    self.flagIcon = flagIcon;
    self.alarms = alarms;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
