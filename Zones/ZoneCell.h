//
//  ZoneCell.h
//  Zones
//
//  Created by Karthik on 3/24/15.
//  Copyright (c) 2015 Karthik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *locationName;
@property (weak, nonatomic) IBOutlet UILabel *flagIcon;
@property (weak, nonatomic) IBOutlet UILabel *timestamp;
@property (weak, nonatomic) IBOutlet UILabel *alarms;
@end
