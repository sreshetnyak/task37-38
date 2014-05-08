//
//  TTStudent.h
//  MapKitRoute
//
//  Created by Sergey Reshetnyak on 5/6/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum {
    TTMale,
    TTFamale
}TTGender;

@interface TTStudent : NSObject <MKAnnotation>

@property (strong,nonatomic) NSString *firstName;
@property (strong,nonatomic) NSString *lastName;
@property (strong,nonatomic) NSString *birthDay;
@property (assign,nonatomic) TTGender gender;
@property (assign,nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;

+ (TTStudent *)getRandomStudent;

@end
