//
//  TTViewController.h
//  MapKitRoute
//
//  Created by Sergey Reshetnyak on 5/6/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKMapView;

@interface TTViewController : UIViewController

@property (weak,nonatomic) IBOutlet MKMapView *mapView;

@end
