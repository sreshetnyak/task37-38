//
//  TTPopViewViewController.h
//  MapKitRoute
//
//  Created by Sergey Reshetnyak on 5/6/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTStudent;

@protocol TTPopDelegete;

@interface TTPopViewViewController : UIViewController

@property (weak,nonatomic) id <TTPopDelegete> delegete;
@property (strong,nonatomic) TTStudent *student;

@end

@protocol TTPopDelegete <NSObject>

- (void) hidePopover;

@end
