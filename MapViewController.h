//
//  MapViewController.h
//  Zones
//
//  Created by Karthik on 5/18/14.
//  Copyright (c) 2014 Karthik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "AddViewController.h"

MKCoordinateRegion tempRegion;

@interface MapViewController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate>


- (IBAction)addPin:(UILongPressGestureRecognizer*)sender;
- (IBAction)dismissKeyboard:(UITapGestureRecognizer*)sender;
- (void)updateTab;

@property (strong) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *locationField;

@end
