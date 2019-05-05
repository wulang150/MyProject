//
//  IBeaconViewController.m
//  MyProject
//
//  Created by anker on 2018/12/21.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "IBeaconViewController.h"
#import <MapKit/MapKit.h>
#import "LocalNotifyManager.h"
#import "YYWeakProxy.h"

#define IBEACON_UUID                          @"B0702880-A295-A8AB-F734-031A98A512DE"

@interface IBeaconViewController ()
<CLLocationManagerDelegate>
{
    UILabel *_textLab;
    UILabel *_errorLab;
    NSTimer *_liveTimer;
}
@property(nonatomic) CLLocationManager *locationManager;
@property(nonatomic) CLBeaconRegion *beaconRegion;
@property(nonatomic, assign) UIBackgroundTaskIdentifier bgTask;
@end

@implementation IBeaconViewController

- (void)dealloc{
    ShowFunMsg;
    if(_liveTimer){
        [_liveTimer invalidate];
        _liveTimer = nil;
    }
    [self.locationManager stopMonitoringForRegion:self.beaconRegion];
    [_locationManager stopRangingBeaconsInRegion:_beaconRegion];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

//- (void)goBack{
//    if(_liveTimer){
//        [_liveTimer invalidate];
//        _liveTimer = nil;
//    }
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)setupData{
    [[LocalNotifyManager sharedInstanced] registerNotify];
}

- (void)setupUI{
    
    [self setupData];
    
    [self setNavWithTitle:@"IBeacon" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
    [self startLocation];
    
    _textLab = [[UILabel alloc] init];
    _textLab.layer.borderWidth = 1;
    _textLab.numberOfLines = 0;
    _textLab.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_textLab];
    
    _errorLab = [[UILabel alloc] init];
    _errorLab.layer.borderWidth = 1;
    _errorLab.numberOfLines = 0;
    _errorLab.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_errorLab];
    
    [_textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view).multipliedBy(0.8);
        make.height.equalTo(@(200));
    }];
    [_errorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(_textLab);
        make.height.equalTo(@(120));
//        make.top.mas_equalTo(_textLab.bottom).offset(-10);
        make.top.equalTo(_textLab.mas_bottom).offset(-10);
    }];
}

- (void)startLocation{
    
    CLAuthorizationStatus state = [CLLocationManager authorizationStatus];
    if(state == kCLAuthorizationStatusNotDetermined){
        
        if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
            [self.locationManager requestAlwaysAuthorization];
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
    
    if( [CLLocationManager isMonitoringAvailableForClass:[self.beaconRegion class]] ) {
        //开始定位
        [self.locationManager startMonitoringForRegion:self.beaconRegion];
    }
    
    if (_beaconRegion && [CLLocationManager isRangingAvailable]) {
        NSLog(@"startRangingBeaconsInRegion");
        [_locationManager startRangingBeaconsInRegion:_beaconRegion];
    }
}

- (void)starBGTask {
    if (_bgTask == UIBackgroundTaskInvalid) {
        UIApplication *app = [UIApplication sharedApplication];
        __block UIBackgroundTaskIdentifier bgTask;
        bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
            NSLog(@"EndBackgroundTask");
            bgTask = UIBackgroundTaskInvalid;
        }];
        _bgTask = bgTask;
    }
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//    ShowFunMsg;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*2), dispatch_get_main_queue(), ^{
//
//        [[LocalNotifyManager sharedInstanced] pushLocalNotification:@"Tip" alertBody:@"进入区域了" flag:@"test" infoDic:nil];
//    });
//}

- (CLLocationManager *)locationManager{
    if(!_locationManager){
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.distanceFilter = 1.0f; //kCLDistanceFilterNone
        _locationManager.delegate = self;
        //控制定位精度,越高耗电量越
//        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    }
    
    return _locationManager;
}

- (CLBeaconRegion *)beaconRegion{
    if(!_beaconRegion){
        
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:IBEACON_UUID];
        _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:2 minor:1000 identifier:[[NSBundle mainBundle] bundleIdentifier]];
        _beaconRegion.notifyOnExit = YES;
        _beaconRegion.notifyOnEntry = YES;
        _beaconRegion.notifyEntryStateOnDisplay = YES;
    
    }
    
    return _beaconRegion;
}


// delegate
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    _errorLab.text = @"didStartMonitoringForRegion";
    WLlog(@"didStartMonitoringForRegion");
}
// 设备进入该区域时的回调
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    //App在后台才会执行
    self.view.backgroundColor = [UIColor redColor];
    _errorLab.text = @"didEnterRegion";
    WLlog(@"didEnterRegion");
}
// 设备退出该区域时的回调
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    //App在后台才会执行
    self.view.backgroundColor = [UIColor blackColor];
    _errorLab.text = @"didExitRegion";
    WLlog(@"didExitRegion");
}
// 有错误产生时的回调
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(nullable CLRegion *)region withError:(NSError *)error{
    _errorLab.text = @"monitoringDidFailForRegion";
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region{
    NSString *proximity = @"unKnow";
    CLBeacon *beacon = [beacons firstObject];
    switch (beacon.proximity) {
        case CLProximityImmediate:
        {
//            NSLog(@"very close");
            proximity = @"very close";
        }
            break;
        case CLProximityNear:
        {
//            NSLog(@"near");
            proximity = @"near";
        }
            break;
        case CLProximityFar:
        {
//            NSLog(@"far");
            proximity = @"far";
        }
            break;
            
        default:
        {
            NSLog(@"unKnow");
        }
            break;
    }
    proximity = [NSString stringWithFormat:@"%@\n%f meter\nrssi:%zi",proximity,beacon.accuracy,beacon.rssi];
    
    _textLab.text = proximity;
    
//    NSLog(@">>>>%f meter  rssi:%zi",beacon.accuracy,beacon.rssi);
}

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region API_AVAILABLE(ios(7.0), macos(10.10)) API_UNAVAILABLE(watchos, tvos){

    //第一次运行的时候，会走这里，之后App在前台的情况下，这里就算状态发送改变了，也没有执行。App在后台才会执行
    NSString *msg = @"didDetermineState";
    
    if(state == CLRegionStateInside){
        msg = @"Inside";
        [[LocalNotifyManager sharedInstanced] pushLocalNotification:@"Tip" alertBody:msg flag:@"test" infoDic:nil];
        [self checkAppLiveTime];
    }
    if(state == CLRegionStateOutside){
        msg = @"Outside";
        [[LocalNotifyManager sharedInstanced] pushLocalNotification:@"Tip" alertBody:msg flag:@"test" infoDic:nil];
        [self checkAppLiveTime];
    }
    
    _errorLab.text = msg;
    WLlog(msg);
}

//检测App被唤醒的时间长度
- (void)checkAppLiveTime{
    //经过测试，每次App可有10秒左右的激活时间，加上starBGTask后，可以存活几分钟
//    [self starBGTask];
    if(_liveTimer){
        [_liveTimer invalidate];
        _liveTimer = nil;
    }
    
    _liveTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:[YYWeakProxy proxyWithTarget:self] selector:@selector(timeAction) userInfo:nil repeats:YES];
}

- (void)timeAction{
    WLlog(@">>>>>>>>>>>time");
}

@end
