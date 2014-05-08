//
//  TTPopViewViewController.m
//  MapKitRoute
//
//  Created by Sergey Reshetnyak on 5/6/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import "TTPopViewViewController.h"
#import "TTStudent.h"

@interface TTPopViewViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak,nonatomic) UITableView *tableView;
@property (strong, nonatomic) CLGeocoder* geoCoder;
@property (strong, nonatomic) MKDirections* directions;
@property (strong, nonatomic) NSString* description;

@end

@implementation TTPopViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = item;
    
    CGRect rect = self.view.bounds;
    rect.origin = CGPointZero;
    UITableView *tabelView = [[UITableView alloc]initWithFrame:rect style:UITableViewStyleGrouped];
    tabelView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    tabelView.dataSource = self;
    tabelView.delegate = self;
    tabelView.separatorInset = UIEdgeInsetsZero;
    tabelView.scrollEnabled = NO;
    
    [self.view addSubview:tabelView];
    self.tableView = tabelView;
    
    self.geoCoder = [[CLGeocoder alloc] init];
    
    
    CLLocationCoordinate2D coordinate = self.student.coordinate;
    
    CLLocation* location = [[CLLocation alloc] initWithLatitude:coordinate.latitude
                                                      longitude:coordinate.longitude];
    
    if ([self.geoCoder isGeocoding]) {
        [self.geoCoder cancelGeocode];
    }
    
    __weak TTPopViewViewController *weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            
            NSString* message = nil;
            
            if (error) {
                message = [error localizedDescription];
            } else {
                
                if ([placemarks count] > 0) {
                    MKPlacemark* placeMark = [placemarks firstObject];
                    message = placeMark.thoroughfare;
                    
                } else {
                    message = @"No Placemarks Found";
                }
                
            }
            
            weakSelf.description = message;
            [weakSelf.tableView reloadData];
            
        }];
    });
 
}

- (void)cancelPressed:(id)sender {
    [self.delegete hidePopover];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.font = [UIFont fontWithDescriptor:nil size:5.f];
    
    if (indexPath.row == 0) {
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ , %@",[self.student firstName],[self.student lastName]];
    } else if (indexPath.row == 1) {
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.student birthDay]];
    } else if (indexPath.row == 2) {
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[self Position:[self.student coordinate]]];
    } else if (indexPath.row == 3) {
        
        cell.textLabel.text = self.description;
    }

    return cell;
    
}


- (NSString *)Position:(CLLocationCoordinate2D)coordinate {
    
    double latitude = coordinate.latitude;
    double longitude = coordinate.longitude;
    
    int latSeconds = (int)round(abs(latitude * 3600));
    int latDegrees = latSeconds / 3600;
    latSeconds = latSeconds % 3600;
    int latMinutes = latSeconds / 60;
    
    latSeconds %= 60;
    
    int longSeconds = (int)round(abs(longitude * 3600));
    
    int longDegrees = longSeconds / 3600;
    
    longSeconds = longSeconds % 3600;
    
    int longMinutes = longSeconds / 60;
    
    longSeconds %= 60;
    
    char latDirection = (latitude >= 0) ? 'N' : 'S';
    char longDirection = (longitude >= 0) ? 'E' : 'W';
    
    return [NSString stringWithFormat:@"%i° %i' %i\" %c, %i° %i' %i\" %c", latDegrees, latMinutes, latSeconds, latDirection, longDegrees, longMinutes, longSeconds, longDirection];
}

@end
