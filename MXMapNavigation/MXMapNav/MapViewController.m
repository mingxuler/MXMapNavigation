//
//  MapViewController.m
//  SuperBlueCollar
//
//  Created by cimcssc on 2017/3/28.
//  Copyright © 2017年 cimcssc. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>

#import "MapViewController.h"
#import "AnnotationModel.h"

@interface MapViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>

@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLGeocoder *myGeocoder;
@property (nonatomic, strong) MKAnnotationView *annotation;
// 用于显示目的地详情，及导航按钮
@property (nonatomic, strong) UIView *viewLabel;
// 导航按钮
@property (nonatomic, strong) UIButton *guidanceBtn;
//@property (nonatomic ,assign) CLLocationCoordinate2D ToCoords;
@property (nonatomic ,assign) CLLocationCoordinate2D FromCoords;

@end

@implementation MapViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    self.title = @"地图导航";
    // Do any additional setup after loading the view.
    _manager = [[CLLocationManager alloc]init];
    _manager.delegate = self;
    [_manager requestAlwaysAuthorization];
    [_manager startUpdatingLocation];
    _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    CGFloat margin = 0;
    CGFloat viewW =  [UIScreen mainScreen].bounds.size.width- margin * 2;
    CGFloat viewH = 55;
    _viewLabel = [[UIView alloc] initWithFrame:CGRectMake(margin, [UIScreen mainScreen].bounds.size.height - viewH, viewW, viewH)];
    _viewLabel.backgroundColor = [UIColor whiteColor];
    
    [_mapView addSubview:_viewLabel];
    
    UILabel * label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
    label.frame = CGRectMake(20, 5, viewW - 85, 20);
    label.textAlignment = NSTextAlignmentCenter;
    label.center = CGPointMake((viewW - 85)/2, 20);
    label.text = self.epAdress;
    [_viewLabel addSubview:label];
    
    UILabel * adLabel = [[UILabel alloc] init];
    adLabel.font = [UIFont systemFontOfSize:16];
    adLabel.textAlignment = NSTextAlignmentCenter;
    adLabel.frame = CGRectMake(20, 30, viewW - 85, 20);
    adLabel.center = CGPointMake((viewW - 85)/2, 40);
    adLabel.text = self.epName;
    [_viewLabel addSubview:adLabel];
    
    
    _guidanceBtn = [[UIButton alloc]initWithFrame:CGRectMake(viewW - 85, 0, 85, viewH)];
    _guidanceBtn.backgroundColor =  [UIColor colorWithRed:37.0/255.0 green:196/255.0 blue:255/255.0 alpha:1.0];
    

    [_guidanceBtn setTitle:@" 导航" forState:UIControlStateNormal];
    [_guidanceBtn  setImage:[UIImage imageNamed:@"map_nav"] forState:UIControlStateNormal];
    [_viewLabel addSubview:_guidanceBtn];
    [_guidanceBtn addTarget:self action:@selector(setUpAlert) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.mapView];
    _mapView.delegate = self;
    // 设置定位精确度
    _manager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //地理编码获取目的地经纬度
    _myGeocoder = [[CLGeocoder alloc]init];
    
    [self.myGeocoder geocodeAddressString:self.epAdress
                        completionHandler:^(NSArray *placemarks,NSError *error){
                            if(nil == error && [placemarks count] > 0){
                                
                                CLPlacemark *pm = [placemarks objectAtIndex:0];
                                CLLocationCoordinate2D coords=
                                CLLocationCoordinate2DMake(pm.location.coordinate.latitude,pm.location.coordinate.longitude);
                                self.ToCoords = coords;
                                // 自定义的大头针
                                AnnotationModel *anno = [[AnnotationModel alloc]init];
                                anno.iconName = @"map_loc";
                                anno.coordinate = CLLocationCoordinate2DMake(pm.location.coordinate.latitude, pm.location.coordinate.longitude);
//                                NSLog(@"%f,%f",anno.coordinate.latitude,anno.coordinate.longitude);
                                // 地图显示精度
                                float zoomLevel = 0.01;
                                MKCoordinateRegion region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(zoomLevel, zoomLevel));
                                [_mapView setRegion:region animated:YES];
                                [_mapView addAnnotation:anno];
                                
                            }else if([placemarks count] == 0 && error == nil){
                                
                               NSLog(@"找不到给定地址的经纬度");
                            }
        }];

    
    /*// 地图显示精度
    float zoomLevel = 0.01;
    MKCoordinateRegion region = MKCoordinateRegionMake(self.ToCoords, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [_mapView setRegion:region animated:YES];
*/
    
}

#pragma mark - CLLocationManager的代理方法
/** 用户拒绝或同意授权后调用*/
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //NSLog(@"--%f",manager.location.coordinate.latitude);
    //NSLog(@"--%f",manager.location.coordinate.longitude);
    self.FromCoords = manager.location.coordinate;
    [self.manager stopUpdatingLocation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:    (id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    _annotation = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"ID"];
    if (_annotation == nil) {
        _annotation = [[MKAnnotationView alloc]initWithAnnotation:annotation   reuseIdentifier:@"ID"];
    }
    _annotation.canShowCallout = YES;
    // 根据模型对象，决定本大头针显示的图片样式。
    NSString *iconName = ((AnnotationModel *)annotation).iconName;
    _annotation.image = [UIImage imageNamed:iconName];
    
    return _annotation;
}

//调用苹果自带地图导航
- (void)btnClick
{
    //当前的位置
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    //起点
    //MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords1 addressDictionary:nil]];
    //目的地的位置
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.ToCoords addressDictionary:nil]];
    toLocation.name = @"目的地";
    
    NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
    
    //打开苹果自身地图应用，并呈现特定的item
    [MKMapItem openMapsWithItems:items launchOptions:options];
}

#pragma mark 弹出底部地图导航控制器
- (void)setUpAlert{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
   // CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(22.84,114.07);
    NSArray * mapsArray =  [self getInstalledMapAppWithEndLocation:self.ToCoords];
    for (int i = 0; i < mapsArray.count; i++) {
        
        NSDictionary *dic = mapsArray[i];
        UIAlertAction *gaodeAlert = [UIAlertAction actionWithTitle:dic[@"title"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            if (i == 2) {
                [self navAppleMap];
            }else{
                NSString *urlString = dic[@"url"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }
        }];
        [alert addAction:gaodeAlert];
        
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{ }];
}
#pragma mark - 导航方法
- (NSArray *)getInstalledMapAppWithEndLocation:(CLLocationCoordinate2D)endLocation
{
    NSMutableArray *maps = [NSMutableArray array];
    
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=%@&mode=driving&coord_type=gcj02",endLocation.latitude,endLocation.longitude,self.epName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        baiduMapDic[@"url"] = urlString;
        [maps addObject:baiduMapDic];
    }
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用名称
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&dlat=%f&dlon=%f&dev=1&t=0",appCurName,endLocation.latitude,endLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        gaodeMapDic[@"url"] = urlString;
        [maps addObject:gaodeMapDic];
        
    }
    //苹果地图
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图";
    [maps addObject:iosMapDic];
    
    return maps;
}
- (void)navAppleMap
{
   
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.ToCoords addressDictionary:nil]];
    NSArray *items = @[currentLoc,toLocation];
    NSDictionary *dic = @{
                          MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeTransit,
                          MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                          MKLaunchOptionsShowsTrafficKey : @(YES)
                          };
    [MKMapItem openMapsWithItems:items launchOptions:dic];
}
@end
