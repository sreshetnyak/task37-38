//
//  TTMeeting.h
//  MapKitRoute
//
//  Created by Sergey Reshetnyak on 5/7/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TTMeeting : NSObject <MKAnnotation>

@property (strong,nonatomic) NSString *name;

@property (assign,nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;

- (id)initWithNameMeeting:(NSString *)name andLocation:(CLLocationCoordinate2D)location;

@end
