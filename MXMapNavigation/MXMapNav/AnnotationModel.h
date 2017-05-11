//
//  AnnotationModel.h
//  SuperBlueCollar
//
//  Created by cimcssc on 2017/3/28.
//  Copyright © 2017年 cimcssc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AnnotationModel : NSObject

@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, readonly, copy) NSString *title;
@property(nonatomic, readonly, copy) NSString *subtitle;

@end
