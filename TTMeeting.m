//
//  TTMeeting.m
//  MapKitRoute
//
//  Created by Sergey Reshetnyak on 5/7/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import "TTMeeting.h"

@implementation TTMeeting

- (id)initWithNameMeeting:(NSString *)name andLocation:(CLLocationCoordinate2D)location {
    self = [super init];
    if (self) {
        
        self.coordinate = location;
        
        self.title = name;
        
    }
    return self;
}

@end
