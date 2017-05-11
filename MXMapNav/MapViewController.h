//
//  MapViewController.h
//  SuperBlueCollar
//
//  Created by cimcssc on 2017/3/28.
//  Copyright © 2017年 cimcssc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController
@property (nonatomic ,assign) CLLocationCoordinate2D ToCoords;
@property (nonatomic,strong) NSString * epName;
@property (nonatomic,strong) NSString * epAdress;

@end
