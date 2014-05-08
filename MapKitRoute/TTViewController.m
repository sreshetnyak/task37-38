//
//  TTViewController.m
//  MapKitRoute
//
//  Created by Sergey Reshetnyak on 5/6/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import "TTViewController.h"
#import <MapKit/MapKit.h>
#import "TTStudent.h"
#import "UIView+MKAnnotationView.h"
#import "TTPopViewViewController.h"
#import "TTMeeting.h"
#import "TTInfoView.h"

@interface TTViewController () <MKMapViewDelegate,UIPopoverControllerDelegate,TTPopDelegete>

@property (strong,nonatomic) NSArray *student;
@property (strong,nonatomic) UIPopoverController *pop;
@property (weak,nonatomic) TTInfoView *infoView;
@property (strong,nonatomic) TTMeeting *kebab;
@property (strong, nonatomic) MKDirections* directions;

@end

@implementation TTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    TTInfoView *info = [[TTInfoView alloc]initWithFrame:CGRectMake(30, 90, 200, 100)];
    
    self.infoView = info;
    
    [self.mapView addSubview:self.infoView];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(visibleMapRectPin:)];
    
    self.navigationItem.rightBarButtonItem = item;
    
    self.mapView.delegate = self;
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 20; i++) {
        [tempArray addObject:[TTStudent getRandomStudent]];
    }
    
    self.student = tempArray;
    [self.mapView addAnnotations:self.student];
    
    
    CLLocationCoordinate2D location;
    location.latitude = 46.967597;
    location.longitude = 31.982122;
    self.kebab = [[TTMeeting alloc]initWithNameMeeting:@"Kebab" andLocation:location];
    
    [self.mapView addAnnotation:self.kebab];
    
    [self addOverlayCircleWithCoordinate:location];
    
    [self showVisibleRect];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Action

- (void)showVisibleRect {

    MKMapRect zoomRect = MKMapRectNull;
    
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        
        CLLocationCoordinate2D location = annotation.coordinate;
        MKMapPoint center = MKMapPointForCoordinate(location);
        
        static double delta = 1000;
        
        MKMapRect rect = MKMapRectMake(center.x - delta, center.y - delta, delta * 2, delta * 2);
        zoomRect = MKMapRectUnion(zoomRect, rect);
    }
    
    zoomRect = [self.mapView mapRectThatFits:zoomRect];
    
    [self.mapView setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(50, 50, 50, 50) animated:YES];
}

- (void)pinColloutPress:(UIButton *)sender {
    
    TTStudent *std = (TTStudent <MKAnnotation> *)[[sender superAnnotationView]annotation];
    
    TTPopViewViewController *vc = [[TTPopViewViewController alloc]init];
    vc.student = std;
    vc.delegete = self;
    
    UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:vc];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        UIPopoverController *pop = [[UIPopoverController alloc]initWithContentViewController:nv];
        pop.delegate = self;
        pop.popoverContentSize = CGSizeMake(300, 300);
        self.pop = pop;
        [pop presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        
        [self presentViewController:nv animated:YES completion:nil];
        
    }
}

- (void)pinRoute:(UIButton *)sender {
    
    if ([self.directions isCalculating]) {
        [self.directions cancel];
    }
    
    for (id <MKAnnotation> obj in [self countStudentInCircleCoordinate:self.kebab.coordinate forRadius:1500]) {
        
        [self addRouteForAnotationCoordinate:[obj coordinate] startCoordinate:self.kebab.coordinate];
        
    }
    
}

- (void)visibleMapRectPin:(UIBarButtonItem *)sender {
    
    [self showVisibleRect];
}

#pragma mark - TTPopDelegete

- (void)hidePopover {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        
        [self.pop dismissPopoverAnimated:YES];
        self.pop = nil;
    }

}

#pragma mark - Methods

- (UIColor *)randomRGBColor {
    
    CGFloat r = (CGFloat)(arc4random() % 256) / 255;
    CGFloat g = (CGFloat)(arc4random() % 256) / 255;
    CGFloat b = (CGFloat)(arc4random() % 256) / 255;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

- (void) addRouteForAnotationCoordinate:(CLLocationCoordinate2D)endCoordinate startCoordinate:(CLLocationCoordinate2D)startCoordinate {
    
    MKDirectionsRequest* request = [[MKDirectionsRequest alloc] init];
    
    MKPlacemark* startPlacemark = [[MKPlacemark alloc] initWithCoordinate:startCoordinate
                                                   addressDictionary:nil];
    
    MKMapItem* startDestination = [[MKMapItem alloc] initWithPlacemark:startPlacemark];
    
    request.source = startDestination;
    
    MKPlacemark* endPlacemark = [[MKPlacemark alloc] initWithCoordinate:endCoordinate
                                                   addressDictionary:nil];
    
    MKMapItem* endDestination = [[MKMapItem alloc] initWithPlacemark:endPlacemark];
    
    request.destination = endDestination;
    
    request.transportType = MKDirectionsTransportTypeAutomobile;
    
    request.requestsAlternateRoutes = YES;
    
    self.directions = [[MKDirections alloc] initWithRequest:request];
    
    [self.directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        if (error) {
            
        } else if ([response.routes count] == 0) {
            
        } else {
            
            [self.mapView addOverlay:[[response.routes firstObject] polyline] level:MKOverlayLevelAboveRoads];
        }
        
    }];
    
}

- (NSArray *)countStudentInCircleCoordinate:(CLLocationCoordinate2D)location forRadius:(int)radius {

    CLLocation *startLocation = [[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longitude];
    
    int count = 0;
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        
        if ([annotation isKindOfClass:[TTStudent class]]) {
            
            CLLocation *tempLocation = [[CLLocation alloc]initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
            
            CLLocationDistance dist = [startLocation distanceFromLocation:tempLocation];
            
            if (radius > dist) {
                count++;
                
                [tempArray addObject:annotation];
                
            }
            
        }
        
    }
    
    if (radius == 500) {
        self.infoView.infoLabel1.text = [NSString stringWithFormat:@"radius %d student %d",radius,count];
    } else if (radius == 1000) {
        self.infoView.infoLabel2.text = [NSString stringWithFormat:@"radius %d student %d",radius,count];
    } else if (radius == 1500) {
        self.infoView.infoLabel3.text = [NSString stringWithFormat:@"radius %d student %d",radius,count];
    }
    
    return tempArray;
}

- (void)addOverlayCircleWithCoordinate:(CLLocationCoordinate2D)location {

    CLLocationCoordinate2D circleMiddlePoint = CLLocationCoordinate2DMake(location.latitude, location.longitude);
    MKCircle *circle1 = [MKCircle circleWithCenterCoordinate:circleMiddlePoint radius:500];
    MKCircle *circle2 = [MKCircle circleWithCenterCoordinate:circleMiddlePoint radius:1000];
    MKCircle *circle3 = [MKCircle circleWithCenterCoordinate:circleMiddlePoint radius:1500];
    
    [self countStudentInCircleCoordinate:location forRadius:500];
    [self countStudentInCircleCoordinate:location forRadius:1000];
    [self countStudentInCircleCoordinate:location forRadius:1500];
    
    NSArray *overlayArray = @[circle1,circle2,circle3];
    
    [self.mapView addOverlays:overlayArray];
    
    
    
}



#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"anotation";
    
    MKAnnotationView *pin = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!pin) {
        pin = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
        pin.canShowCallout = YES;
        
        if ([pin.annotation isKindOfClass:[TTStudent class]]) {
            if ([(TTStudent <MKAnnotation> *)annotation gender] == TTMale) {
                pin.image = [UIImage imageNamed:@"male.png"];
            } else {
                pin.image = [UIImage imageNamed:@"female.png"];
            }
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoDark];
            [btn addTarget:self action:@selector(pinColloutPress:) forControlEvents:UIControlEventTouchUpInside];
            pin.rightCalloutAccessoryView = btn;
            

        } else if ([pin.annotation isKindOfClass:[TTMeeting class]]) {
            pin.image = [UIImage imageNamed:@"meeting.png"];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoDark];
            [btn addTarget:self action:@selector(pinRoute:) forControlEvents:UIControlEventTouchUpInside];
            pin.leftCalloutAccessoryView = btn;
            [pin setDraggable:YES];
            
        }

    } else {
        pin.annotation = annotation;
    }
    
    return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
    if ([view.annotation isKindOfClass:[TTMeeting class]]) {
        if (newState == MKAnnotationViewDragStateEnding) {
            view.dragState = MKAnnotationViewDragStateNone;
            
            [self addOverlayCircleWithCoordinate:view.annotation.coordinate];
            
        } else if (newState == MKAnnotationViewDragStateStarting) {
            [self.mapView removeOverlays:[mapView overlays]];
        }
    }
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKCircle class]]) {
        
        MKCircleRenderer *circleRender = [[MKCircleRenderer alloc] initWithCircle:(MKCircle *)overlay];
        circleRender.strokeColor = [UIColor greenColor];
        circleRender.lineWidth = 3.f;
        return circleRender;

    } else if ([overlay isKindOfClass:[MKPolyline class]]) {
        
        MKPolylineRenderer* LineRenderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        LineRenderer.lineWidth = 3.f;
        LineRenderer.strokeColor = [self randomRGBColor];
        return LineRenderer;
    }
    
    
    return nil;
}

@end
