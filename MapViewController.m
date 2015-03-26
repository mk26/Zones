//
//  MapViewController.m
//  Zones
//
//  Created by Karthik on 5/18/14.
//  Copyright (c) 2014 Karthik. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize mapView, locationField, addFromContact;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPin:(UILongPressGestureRecognizer*)sender
{
    if (sender.state != UIGestureRecognizerStateBegan)
        return;

    CGPoint touchPoint = [sender locationInView:mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [mapView convertPoint:touchPoint toCoordinateFromView:mapView];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [mapView addAnnotation:[self prepareAnnotationWithCoordinates:touchMapCoordinate]];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(50, 50);
    tempRegion = MKCoordinateRegionMake(touchMapCoordinate, span);
    
    //[mapView showAnnotations:mapView.annotations animated:YES];
}


- (MKPointAnnotation*)prepareAnnotationWithCoordinates:(CLLocationCoordinate2D)coordinate
{
    CLLocation *coordinates = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    MKPointAnnotation *place = [[MKPointAnnotation alloc] init];
    
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:coordinates completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark* determinedLocation = [placemarks objectAtIndex:0];
        
        place.title = [self getNameFor:determinedLocation];
        place.coordinate = determinedLocation.location.coordinate;
        
        tempLocation = determinedLocation.location.coordinate;
        tempLocationName = place.title;
    }];
    
    return place;
}

/* Zooms to pin and shows its callout view */

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    [self.mapView setRegion:tempRegion animated:YES];
    [self performSelector:@selector(selectLastAnnotation) withObject:nil afterDelay:0.5];
}

-(void)selectLastAnnotation
{
    [mapView selectAnnotation:[[mapView annotations] lastObject] animated:YES];
}

/* Text field delegates */

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString* location = [NSString stringWithString:textField.text];
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark* determinedLocation = [placemarks objectAtIndex:0];
        CLLocation* coordinates = determinedLocation.location;
        
        MKPointAnnotation* annotation = [[MKPointAnnotation alloc]init];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(coordinates.coordinate.latitude,coordinates.coordinate.longitude);
        annotation.coordinate=coord;
        annotation.title=[self getNameFor:determinedLocation];
        
        if(![annotation.title isEqualToString:[NSString stringWithFormat:@"%f,%f",determinedLocation.location.coordinate.latitude,determinedLocation.location.coordinate.longitude]])
        {
            MKCoordinateSpan span = MKCoordinateSpanMake(50, 50);
            tempRegion = MKCoordinateRegionMake(coord, span);
            [mapView setRegion:tempRegion animated:YES];
            [self.mapView removeAnnotations:self.mapView.annotations];
            [mapView addAnnotation:annotation];
            tempLocation=coord;
            tempLocationName=annotation.title;
        }
    }];
    
    [locationField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    [mapView removeAnnotations:[mapView annotations]];
    return YES;
}



/* Callout view */

//Callout Base View
- (MKAnnotationView *)mapView:(MKMapView *)sender viewForAnnotation:(id < MKAnnotation >)annotation
{
    //if ([annotation isMemberOfClass:[MKUserLocation class]]) return nil;
    NSString *annotationID = @"placePin";
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[sender dequeueReusableAnnotationViewWithIdentifier:annotationID];
    
    if (annotationView == nil)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                         reuseIdentifier:annotationID];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
        annotationView.canShowCallout = YES;
        annotationView.alpha=0.9;
    }
    
    return annotationView;
}

//Callout Add button selector
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    AddViewController* addVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"AddVC"];
    
    NSBlockOperation *fetchoperation = [NSBlockOperation blockOperationWithBlock:^{
        NSURL* timeZoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/timezone/json?location=%f,%f&timestamp=%f",tempLocation.latitude,tempLocation.longitude,[[NSDate date] timeIntervalSince1970]]];
        
        NSData* rawtimeZoneData = [NSData dataWithContentsOfURL:timeZoneURL];
        NSDictionary* timeZoneData = [NSJSONSerialization JSONObjectWithData:rawtimeZoneData options:0 error:nil];
        
        //Create Time zone object from retrieved data
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:[timeZoneData objectForKey:@"timeZoneId"]];
        
        //addVC.zoneNameLabel.text=view.annotation.title;
        addVC.timeZone=timeZone;
    }];
    
    NSBlockOperation *segueOperation = [NSBlockOperation blockOperationWithBlock:^{
        addVC.modalPresentationStyle=UIModalPresentationOverFullScreen;
        [self presentViewController:addVC animated:YES completion:nil];
    }];
    
    [segueOperation addDependency:fetchoperation];
    
    NSArray* operations = [[NSArray alloc] initWithObjects:fetchoperation, segueOperation, nil];
    
    [[NSOperationQueue mainQueue] addOperations:operations waitUntilFinished:NO];
}

- (IBAction)dismissKeyboard:(UITapGestureRecognizer*)sender;
{
    [locationField resignFirstResponder];
}

- (NSString*)getNameFor:(CLPlacemark*)placemark;
{
    NSString* locationName = [[NSString alloc] init];
    
    if(placemark.locality!=nil)
       locationName=placemark.locality;
    else if (placemark.administrativeArea!=nil)
        locationName=[NSString stringWithFormat:@"%@, %@",placemark.administrativeArea,placemark.country];
    else locationName=[NSString stringWithFormat:@"%f,%f",placemark.location.coordinate.latitude,placemark.location.coordinate.longitude];
    
    return locationName;
}

@end
