//
//  ViewController.m
//  MXMapNavigation
//
//  Created by cimcssc on 2017/5/11.
//  Copyright © 2017年 cimcssc. All rights reserved.
//

#import "ViewController.h"
#import "MapViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (IBAction)openMapClick:(id)sender {
    
    /** 只需传入中文地址epAdress 解析地址 纬度，用于导航，对于用户没有安装对应百度和高德，则不显示，都没有安装只显示苹果地图
     */
    MapViewController * mapVc = [[MapViewController alloc] init];
    
    // 公司名地址
    mapVc.epAdress = @"深圳市南山区蛇口网谷科技大厦2期";
    
//    mapVc.epAdress = @"深圳市龙岗区中心城爱联地铁站";
    // 公司名
    mapVc.epName =@"飞利浦";
  
    [self presentViewController:mapVc animated:YES completion:nil];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
