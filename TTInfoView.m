//
//  TTInfoView.m
//  MapKitRoute
//
//  Created by Sergey Reshetnyak on 5/8/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import "TTInfoView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TTInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.cornerRadius = 10.f;
        self.backgroundColor = [UIColor grayColor];
        self.alpha = 0.5;
        
        UILabel *lb1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 33)];
        UILabel *lb2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 200, 33)];
        UILabel *lb3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 65, 200, 33)];
        
        self.infoLabel1 = lb1;
        self.infoLabel2 = lb2;
        self.infoLabel3 = lb3;
        
        [self addSubview:self.infoLabel1];
        [self addSubview:self.infoLabel2];
        [self addSubview:self.infoLabel3];
        
    }
    return self;
}



@end
