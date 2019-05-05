//
//  MapViewController.m
//  MyProject
//
//  Created by anker on 2018/12/4.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"
#import "HRLocationConverter.h"

@interface MapViewController ()
<MKMapViewDelegate,CLLocationManagerDelegate>
{
    MKAnnotationView *_userLocationView;
}

@property (nonatomic, strong) MKMapView *mapView;
//用于定位
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *dataRrray;
@property (nonatomic) NSMutableArray *annotionArr;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavWithTitle:@"地图" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
    [self.view addSubview:self.mapView];
    
    [self startLocation];
    
    _dataRrray = [NSMutableArray new];
    _annotionArr = [NSMutableArray new];
    
    // 定位按钮
    UIButton *resetLocationBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - 45, 30, 35)];
    resetLocationBtn.backgroundColor = [UIColor redColor];
    resetLocationBtn.tag = 1;
    [resetLocationBtn addTarget:self action:@selector(resetLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetLocationBtn];
    
    UIButton *lineBtn = [[UIButton alloc] initWithFrame:CGRectMake(resetLocationBtn.right+20, SCREEN_HEIGHT - 45, 30, 35)];
    lineBtn.backgroundColor = [UIColor redColor];
    lineBtn.tag = 2;
    [lineBtn addTarget:self action:@selector(resetLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lineBtn];
    
}

//开始定位
- (void)startLocation {
    
    self.locationManager = [[CLLocationManager alloc]init];
    CLAuthorizationStatus state = [CLLocationManager authorizationStatus];
    if(state == kCLAuthorizationStatusNotDetermined){

        if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    if(state == kCLAuthorizationStatusDenied){
        NSString *message = @"您的手机目前未开启定位服务，如欲开启定位服务，请至设定开启定位服务功能";
        UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"Tip" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ;
        }];
        
        [ac addAction:action1];
        [self presentViewController:ac animated:YES completion:nil];
        return;
    }
    if(state == kCLAuthorizationStatusRestricted){
        NSString *message = @"定位权限被限制";
        UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"Tip" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ;
        }];
        
        [ac addAction:action1];
        [self presentViewController:ac animated:YES completion:nil];
        return;
    }
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager.distanceFilter = 1.0f; //kCLDistanceFilterNone
        self.locationManager.delegate = self;
        //控制定位精度,越高耗电量越
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        [self.locationManager startUpdatingLocation];
        [self.locationManager startUpdatingHeading];
    }
}

- (MKMapView *)mapView
{
    if(!_mapView)
    {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationBar_HEIGHT)];
        _mapView.delegate = self;
        /*
         MKUserTrackingModeNone  不进行用户位置跟踪
         MKUserTrackingModeFollow  跟踪用户的位置变化
         MKUserTrackingModeFollowWithHeading  跟踪用户位置和方向变化
         */
        //设置用户的跟踪模式
        self.mapView.userTrackingMode=MKUserTrackingModeFollow;
        /*
         MKMapTypeStandard  标准地图
         MKMapTypeSatellite    卫星地图
         MKMapTypeHybrid      鸟瞰地图
         MKMapTypeSatelliteFlyover
         MKMapTypeHybridFlyover
         */
        self.mapView.mapType=MKMapTypeStandard;
        //实时显示交通路况
        self.mapView.showsTraffic=NO;
        //设置默认的位置
//        CLLocationCoordinate2D coordinate = {39.54, 116.28};
//        [_mapView setCenterCoordinate:coordinate animated:YES];
        
        // 不显示罗盘
        _mapView.showsCompass = NO;
        // 不显示比例尺
        _mapView.showsScale = NO;
        
        MKCoordinateSpan span=MKCoordinateSpanMake(0.021251, 0.016093);
        //地图显示的范围
        //MKCoordinateSpan span=MKCoordinateSpanMake(0.1, 0.1);

        [self.mapView setRegion:MKCoordinateRegionMake(self.mapView.userLocation.coordinate, span) animated:YES];
         //开启定位
        _mapView.showsUserLocation = YES;
        
    }
    
    return _mapView;
}


- (void)resetLocation:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1:     //定位
        {
            // 定位到我的位置
            //    [_mapView setCenterCoordinate:_mapView.userLocation.coordinate animated:YES];
            MKCoordinateSpan span=MKCoordinateSpanMake(0.1, 0.1);
            //纬度（北纬为正）各总共90度，经度（东经为正）各总共180度
            //北京
            //    CLLocationCoordinate2D coordinate = {39.54, 116.28};
            //广州
            //    CLLocationCoordinate2D coordinate = {23.08, 113.15};
            //美国华盛顿
            CLLocationCoordinate2D coordinate = {38.53, -77.01};
            //    [_mapView setCenterCoordinate:coordinate animated:YES];
            coordinate = _mapView.userLocation.coordinate;
            if(_annotionArr.count>0)
                [_mapView removeAnnotations:_annotionArr];
            //在地图上，加上标识点
            MyAnnotation *annotation = [[MyAnnotation alloc] initWithLocation:coordinate];
            [_mapView addAnnotation:annotation];
            annotation.title = @"我的位置";
            annotation.subtitle = @"美国街道";
            [_annotionArr addObject:annotation];
            [self.mapView setRegion:MKCoordinateRegionMake(coordinate, span) animated:YES];
            
        }
            break;
        case 2:     //画线
        {
            MKCoordinateSpan span=MKCoordinateSpanMake(0.1, 0.1);
            CLLocationCoordinate2D coordinate = _mapView.userLocation.coordinate;
            CLLocationCoordinate2D points[4];
            points[0] = coordinate;
            for(int i=1;i<4;i++)
            {
                CLLocationCoordinate2D tmpCoordinate = CLLocationCoordinate2DMake(coordinate.latitude+i*0.01, coordinate.longitude);
                points[i] = tmpCoordinate;
            }

            //画线
//            MKPolyline *polyline = [MKPolyline polylineWithCoordinates:points count:4];
//            [self.mapView addOverlay:polyline];
            
            //画圆
            MKCircle *circle = [MKCircle circleWithCenterCoordinate:coordinate radius:1000];
            [self.mapView addOverlay:circle];
            
            [self.mapView setRegion:MKCoordinateRegionMake(coordinate, span) animated:YES];
        }
            break;
            
        default:
            break;
    }

}

- (void)btnAction:(UIButton *)sender
{
    NSLog(@">>>>>>>>show detail");
}

- (void)fetchNearbyInfo:(CLLocationDegrees )latitude andT:(CLLocationDegrees )longitude

{
    
    CLLocationCoordinate2D location=CLLocationCoordinate2DMake(latitude, longitude);
    
    MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location, 1 ,1 );
    
    MKLocalSearchRequest *requst = [[MKLocalSearchRequest alloc] init];
    requst.region = region;
    requst.naturalLanguageQuery = @"place"; //想要的信息
    //建立请求
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:requst];
    [self.dataRrray removeAllObjects];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        if (!error)
        {
            
            for (MKMapItem *map in response.mapItems) {
                NSLog(@"%@",map.name);
            }
            [self.dataRrray addObjectsFromArray:response.mapItems];
//            [self.tableView reloadData];
            //
        }
        else
        {
            //
        }
    }];
}

#pragma mark - MKMapViewDelegate
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    // 位置发生变化调用
//    NSLog(@"lan = %f, long = %f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
//}

//画轨迹
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        
        MKPolylineRenderer *polylineRender = [[MKPolylineRenderer alloc] initWithPolyline:(MKPolyline *)overlay];
        [polylineRender setNeedsDisplay];
        polylineRender.fillColor = [UIColor redColor];
        polylineRender.strokeColor = [UIColor redColor];
        polylineRender.lineWidth = 1.0f;
        return polylineRender;
    }
    if ([overlay isKindOfClass:[MKCircle class]]){
        MKCircleRenderer *circleRender = [[MKCircleRenderer alloc] initWithCircle:(MKCircle *)overlay];
        circleRender.strokeColor = [UIColor blueColor];
//        circleRender.fillColor = [UIColor blueColor];
        circleRender.lineWidth = 1.0;
        return circleRender;
    }
    return nil;
}

/**
 *  跟踪到用户位置时会调用该方法
 *  @param mapView   地图
 *  @param userLocation 大头针模型
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    if (userLocation) {
        //创建编码对象
//        CLGeocoder *geocoder=[[CLGeocoder alloc]init];
//        //反地理编码
//        [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//            if (error!=nil || placemarks.count==0) {
//                return ;
//            }
//            //获取地标
//            CLPlacemark *placemark=[placemarks firstObject];
//            //设置标题
//            userLocation.title=placemark.locality;
//            //设置子标题
//            userLocation.subtitle=placemark.name;
////            _dangQiang = placemark;
//            [self fetchNearbyInfo:userLocation.location.coordinate.latitude andT:userLocation.location.coordinate.longitude];
//        }];
        NSLog(@"mapView>>>>>>%f %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
//        _isFirstLocated = YES;
    }
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    // 如果标注的是用户当前位置，则直接返回nil。
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        //加上方向
//        MKAnnotationView * view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"mapAnnotationViewId"];
        MKAnnotationView *headView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"mapAnnotationViewId"];
        if(!headView){
            headView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"mapAnnotationViewId"];
            headView.image = [UIImage imageNamed:@"ic_location"];
        }
       
        _userLocationView = headView;
        return headView;
        
    }
    
    // 处理自定义的annotation。
    if ([annotation isKindOfClass:[MyAnnotation class]])
    {
        // 首先尝试复用已存在的MKPinAnnotationView。
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // 没有可以复用的View，新建一个。
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            
            pinView.pinTintColor = MKPinAnnotationView.purplePinColor;
            pinView.animatesDrop = YES;
            //点击之后上面弹出的标识框
            pinView.canShowCallout = YES;
            
            // 如果有的话，可以通过设置accessoryView定义callout。
            
            // 添加右边的详情按钮。
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            // 因为没有页面跳转，所以Target和action参数设为nil。
            [rightButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            pinView.rightCalloutAccessoryView = rightButton;
//
//            // 在callout左边添加自定义图片。
            UIImageView *myCustomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_i_sel"]];
            pinView.leftCalloutAccessoryView = myCustomImage;
        }
        
        pinView.annotation = annotation;
        return pinView;
    }
    return nil;
}

//点击了Callout
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control __TVOS_PROHIBITED
{
    NSLog(@">>>>>>>calloutAccessoryControlTapped");
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    //移除标识点
//    [mapView removeAnnotations:_dataRrray];
}


#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}
//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations[0];
    
    //旧址
    CLLocation *currentLocation = [locations lastObject];
    //中国坐标
    CLLocationCoordinate2D chinaCoor = [HRLocationConverter transformFromWGSToGCJ:currentLocation.coordinate];
    //打印当前的经度与纬度
    NSLog(@"locationManager>>>%f,%f",chinaCoor.latitude,chinaCoor.longitude);
    // 获取当前所在的城市名
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    //根据经纬度反向地理编译出地址信息
//    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
//        if (array.count > 0){
//            CLPlacemark *placemark = [array objectAtIndex:0];
//
//            //获取城市
//            NSString *city = placemark.locality;
//            if (!city) {
//                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
//                city = placemark.administrativeArea;
//            }
////            NSLog(@"city = %@", city);//石家庄市
////            NSLog(@"--%@",placemark.name);//黄河大道221号
////            NSLog(@"++++%@",placemark.subLocality); //裕华区
////            NSLog(@"country == %@",placemark.country);//中国
////            NSLog(@"administrativeArea == %@",placemark.administrativeArea); //河北省
//        }
//        else if (error == nil && [array count] == 0)
//        {
//            NSLog(@"No results were returned.");
//        }
//        else if (error != nil)
//        {
//            NSLog(@"An error occurred = %@", error);
//        }
//    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
//    [manager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading API_AVAILABLE(ios(3.0)) API_UNAVAILABLE(macos) API_UNAVAILABLE(watchos, tvos)
{
    CLLocationDirection heading = ((newHeading.trueHeading > 0) ?
                                    newHeading.trueHeading : newHeading.magneticHeading);
    
//    NSLog(@"head>>>>>>>>%f",heading);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _userLocationView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, heading * M_PI / 180.f);
    });
}

@end
