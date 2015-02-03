//
//  ViewController.m
//  learn
//
//  Created by David on 2015/2/2.
//  Copyright (c) 2015年 David. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *displayLocation;
@property (weak, nonatomic) MKUserLocation *userLocation;
@property (strong, nonatomic) NSMutableArray *trackRoute;
@property (strong, nonatomic) IBOutlet UILabel *showRoute;
@property (nonatomic) int *mode;
@property (nonatomic) MKPolyline *line;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // location tracker here
    manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    manager.distanceFilter = kCLDistanceFilterNone;
    manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    manager.distanceFilter = 7.0f;
    [manager requestWhenInUseAuthorization];
    
    self.trackRoute = [[NSMutableArray alloc] init];
    
    //backgroung test
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(q, ^{
//        int i = 0;
//        while (true) {
//            [NSThread sleepForTimeInterval:1.0];
//            i++;
//            NSLog(@"now %d", i);
//        }
//    });
//    
    // map kit
    self.map.delegate = self;
    
    // locate user
    [self.map setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
//    [self.map setUserTrackingMode:MKUserTrackingModeNone];
    MKPointAnnotation *point;
    
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(25.012526, 121.541487);
    point.title = @"NTUST";
    point.subtitle = @"R.O.C";
    [self.map addAnnotation:point];
    
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(35.6997, 139.6989);
    point.title = @"Tokyo";
    point.subtitle = @"Japan";
    [self.map addAnnotation:point];
    
}

- (void)viewDidAppear:(BOOL)animated
{
//    self.map.centerCoordinate = CLLocationCoordinate2DMake(25.012526, 121.541487);
    
//    [self.map setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(25.012526, 121.541487), MKCoordinateSpanMake(0.01, 0.01))];
}
- (IBAction)locateUser:(id)sender {
    [self.map setShowsUserLocation:YES];
    [self.map setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
    [self.map setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.map.userLocation.coordinate.latitude, self.map.userLocation.coordinate.longitude), MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
    NSLog(@"%f, %f", self.map.userLocation.coordinate.latitude, self.map.userLocation.coordinate.longitude);
}
- (IBAction)hideUserLocation:(id)sender {
    [self.map setShowsUserLocation:NO];
}
- (IBAction)startTracking:(id)sender {
    [manager startUpdatingLocation];
    self.trackRoute = [[NSMutableArray alloc] init];
}
- (IBAction)ClearTracking:(id)sender {
    [manager stopUpdatingLocation];
    self.trackRoute = [[NSMutableArray alloc] init];
    [self.map removeOverlays:self.map.overlays];
    NSLog(@"stop routing");
}

- (IBAction)Longpress:(UILongPressGestureRecognizer *)sender {
    NSLog(@"longpressed!");
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"prepare to end");
    } else {
        CGPoint touchPoint = [sender locationInView:self.map];
        CLLocationCoordinate2D touchOnMap = [self.map convertPoint:touchPoint toCoordinateFromView:self.map];
        
        MKPointAnnotation *pa = [[MKPointAnnotation alloc] init];
        pa.coordinate = touchOnMap;
        pa.title = @"hi pin";
        
        [self.map addAnnotation:pa];
    }
}
- (IBAction)CLearPins:(id)sender {
    [self.map removeAnnotations:self.map.annotations];
}

#pragma mark location
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *c in locations) {
        NSLog(@"%f, %f, %f", c.coordinate.latitude, c.coordinate.longitude, c.altitude);
//        [self.showRoute setText:[NSString stringWithFormat:@"%f, %f, %f", c.coordinate.latitude, c.coordinate.longitude, c.altitude]];
        [self updateRouteWithCurrentLocation:c];
    }
    [self drawPolyLineWithRoute:self.trackRoute];
}

- (void)updateRouteWithCurrentLocation:(CLLocation *)location
{
    NSLog(@"update location and appendding to mutablearray, %f, %f", location.coordinate.latitude, location.coordinate.longitude);
    [self.trackRoute addObject:location];
}

#pragma mark map kit


- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (MKAnnotationView *a in views) {
        if ([a.annotation isKindOfClass:[MKUserLocation class]]) {
            
        } else {
            CGRect endFrame = a.frame;
            a.frame = CGRectOffset(endFrame, 0, -300);
            [UIView animateWithDuration:0.5 animations:^{ a.frame = endFrame; }];
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKAnnotationView *annView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"hello drag pin"];
    if (annView == nil) {
        NSLog(@"did enter custom hello");
        annView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"hello drag pin"];
    } else {
        annView.annotation = annotation;
    }
    NSLog(@"enter i dont know adnnonon");
    
    annView.annotation = annotation; // what will this done?
    
    annView.image = [UIImage imageNamed:@"flag.png"];
    NSLog(@"%@", [UIImage imageNamed:@"flag.png"]);
    NSLog(@"ann img: %@", annView.image);
    annView.canShowCallout = YES;
    annView.draggable = YES;
    annView.layer.anchorPoint = CGPointMake(0.5, 1);
    
    return annView;
}

//drag event
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding) {
        NSLog(@"drag ended");
        //anitmat up
        CGRect originFrame = view.frame, jumpPosition;
        jumpPosition = CGRectOffset(originFrame, 0, -25);
        [UIView animateWithDuration:0.3 animations:^{ view.frame = jumpPosition; }];
        
//        [UIView animateWithDuration:0.5 animations:^{ view.frame = endPosition; }];
        [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionTransitionNone animations:^{ view.frame = originFrame; } completion:nil];
        // animate down
//        originFrame = view.frame;
//        endPosition = CGRectOffset(originFrame, 0, 50);
//        [UIView animateWithDuration:0.5 animations:^{ view.frame = endPosition; }];
        NSLog(@"pin dropping animate end");

        view.dragState = MKAnnotationViewDragStateNone;
    }
    if (newState == MKAnnotationViewDragStateStarting) {
        NSLog(@"start drag");
        CGRect originFrame = view.frame, endPosition, dropPostion;
        dropPostion = CGRectOffset(originFrame, 0, +10);
        [UIView animateWithDuration:0.1 animations:^{ view.frame = dropPostion; }];
        endPosition = CGRectOffset(originFrame, 0, -50-10);
        [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionTransitionNone animations:^{ view.frame = endPosition; } completion:nil];

        NSLog(@"animate end");

    }
    if (newState == MKAnnotationViewDragStateDragging) {
        NSLog(@"dragging");
    }
    if (newState == MKAnnotationViewDragStateCanceling) {
        NSLog(@"cancel");
        CGRect originFrame = view.frame, endPosition;
        endPosition = CGRectOffset(originFrame, 0, 50);
        [UIView animateWithDuration:0.5 animations:^{ view.frame = endPosition; }];
        view.dragState = MKAnnotationViewDragStateNone;
    }
    if (newState == MKAnnotationViewDragStateNone) {
        NSLog(@"none");
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
//    NSLog(@"user moved");
//    self.userLocation = userLocation;
//    [self.trackRoute addObject:userLocation];
//    NSLog(@"%f, %f", self.userLocation.coordinate.latitude, self.userLocation.coordinate.longitude);
//    [self.showRoute setText:[NSString stringWithFormat:@"%f, %f", self.userLocation.coordinate.latitude, self.userLocation.coordinate.longitude]];
//    [self drawPolyLineWithRoute:self.trackRoute];
}

-(MKOverlayPathRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    NSLog(@"renderer called");
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        NSLog(@"is ploy");
        NSLog(@"clean route");
        NSLog(@"after: selfmap overlay is %lu", [self.map.overlays count]);
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.strokeColor = [UIColor colorWithRed:0/255.0 green:102/255.0 blue:255/255.0 alpha:0.7];
        routeRenderer.lineWidth = 10;
        
        return routeRenderer;
    } else {
        NSLog(@"is not polyline");
        return nil;
    }
}

- (void)drawPolyLineWithRoute:(NSMutableArray *)route
{
    MKMapPoint points[[route count]];
    MKUserLocation *user;
    for (int i = 0; i < [route count]; i++) {
        user = route[i];
        points[i] = MKMapPointForCoordinate(CLLocationCoordinate2DMake(user.coordinate.latitude, user.coordinate.longitude));
    }
    
    //remove polylline
    [self.map removeOverlays:self.map.overlays];
    
    self.line = [MKPolyline polylineWithPoints:points count:[route count]];
    [self.map addOverlay:self.line];
    [self calculateDistanseUsingTrack:route];
    
    NSLog(@"update route");
}

- (void)calculateDistanseUsingTrack:(NSMutableArray *)track
{
    double distance;
    for (int i = 0; i < [track count] - 1; i++) {
        CLLocation *here = track[i], *there = track[i + 1];
        CLLocationDistance dis = [here distanceFromLocation:there];
        distance += dis;
        NSLog(@"%f", dis);
    }
    [self.showRoute setText:[NSString stringWithFormat:@"%.1f m", distance]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
