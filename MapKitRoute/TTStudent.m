//
//  TTStudent.m
//  MapKitRoute
//
//  Created by Sergey Reshetnyak on 5/6/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import "TTStudent.h"
#import "NSDate+RandomDate.h"

static NSString* firstNames[] = {
    @"Tran", @"Lenore", @"Bud", @"Fredda", @"Katrice",
    @"Clyde", @"Hildegard", @"Vernell", @"Nellie", @"Rupert",
    @"Billie", @"Tamica", @"Crystle", @"Kandi", @"Caridad",
    @"Vanetta", @"Taylor", @"Pinkie", @"Ben", @"Rosanna",
    @"Eufemia", @"Britteny", @"Ramon", @"Jacque", @"Telma",
    @"Colton", @"Monte", @"Pam", @"Tracy", @"Tresa",
    @"Willard", @"Mireille", @"Roma", @"Elise", @"Trang",
    @"Ty", @"Pierre", @"Floyd", @"Savanna", @"Arvilla",
    @"Whitney", @"Denver", @"Norbert", @"Meghan", @"Tandra",
    @"Jenise", @"Brent", @"Elenor", @"Sha", @"Jessie"
};

static NSString* lastNames[] = {
    
    @"Farrah", @"Laviolette", @"Heal", @"Sechrest", @"Roots",
    @"Homan", @"Starns", @"Oldham", @"Yocum", @"Mancia",
    @"Prill", @"Lush", @"Piedra", @"Castenada", @"Warnock",
    @"Vanderlinden", @"Simms", @"Gilroy", @"Brann", @"Bodden",
    @"Lenz", @"Gildersleeve", @"Wimbish", @"Bello", @"Beachy",
    @"Jurado", @"William", @"Beaupre", @"Dyal", @"Doiron",
    @"Plourde", @"Bator", @"Krause", @"Odriscoll", @"Corby",
    @"Waltman", @"Michaud", @"Kobayashi", @"Sherrick", @"Woolfolk",
    @"Holladay", @"Hornback", @"Moler", @"Bowles", @"Libbey",
    @"Spano", @"Folson", @"Arguelles", @"Burke", @"Rook"
};

static int namesCount = 50;

@implementation TTStudent

+ (TTStudent *)getRandomStudent {
    TTStudent *student = [[TTStudent alloc]init];
    
    student.firstName = firstNames[arc4random() % namesCount];
    student.lastName = lastNames[arc4random() % namesCount];
    
    CLLocationCoordinate2D location;
    
    location.latitude = (((float)arc4random()/0x100000000)*(46.974075-46.946091) + 46.946091);
    location.longitude = (((float)arc4random()/0x100000000)*(32.029097-31.965391) + 31.965391);
    
    student.coordinate = location;
    student.gender = arc4random_uniform(2);
    student.title = [NSString stringWithFormat:@"%@, %@",student.firstName,student.lastName];
    
    NSDateFormatter *dateformater = [[NSDateFormatter alloc]init];
    
    [dateformater setDateFormat:@"yyyy MMM dd"];
    
    NSDate *date = [[NSDate alloc]init];
    
    student.subtitle = student.birthDay = [dateformater stringFromDate:[date randomDateInYearOfDate]];
    
    return student;
}

@end
