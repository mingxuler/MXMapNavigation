# MXMapNavigation
#####快速接入地图定位，百度导航和高德导航

```objc

 
 //只需传入中文地址epAdress 解析地址 纬度，用于导航，对于用户没有安装对应百度和高德，则不显示，都没有安装只显示苹果地图
   
    MapViewController * mapVc = [[MapViewController alloc] init];
    
    // 公司名地址
    mapVc.epAdress = @"深圳市南山区蛇口网谷科技大厦2期";
    
//    mapVc.epAdress = @"深圳市龙岗区中心城爱联地铁站";
    // 公司名
    mapVc.epName =@"飞利浦";
  
    [self presentViewController:mapVc animated:YES completion:nil];
    
```
