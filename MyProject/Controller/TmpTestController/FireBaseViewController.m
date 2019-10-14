//
//  FireBaseViewController.m
//  MyProject
//
//  Created by Anker on 2019/3/26.
//  Copyright © 2019 Tmac. All rights reserved.
//

#import "FireBaseViewController.h"
//#import <FirebaseAnalytics/FIRAnalytics.h>
#import "ZXFireBaseManage.h"

@interface FireBaseViewController ()
{
    NSRunLoop *_showRunLoop;
}
@property(nonatomic) CADisplayLink *displayLink;
@property(nonatomic) NSThread *videoThread;
@end

@implementation FireBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI{
    [self setNavWithTitle:@"FireBase" leftImage:@"arrow" leftTitle:nil leftAction:@selector(backAction) rightImage:nil rightTitle:nil rightAction:nil];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 140, 120, 40);
    [btn setTitle:@"test1" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor lightGrayColor];
    btn.tag = 100;
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(100, 220, 120, 40);
    [btn1 setTitle:@"test2" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor lightGrayColor];
    btn1.tag = 101;
    [btn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    //开启FireBase的调试模式，上传更及时
    //在子线程中开启displayLink
    self.videoThread = [[NSThread alloc] initWithTarget:self selector:@selector(startVideoLink) object:nil];
    [self.videoThread start];
    //在主线程开启
//    [self startVideoLink];
}

- (void)startVideoLink{
    @autoreleasepool
    {
        
        //1、添加一个input source
        //        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        //        [[NSRunLoop currentRunLoop] run];
        
        if(_displayLink){
            [_displayLink invalidate];
            _displayLink = nil;
        }
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayVideo)];
        if([_displayLink respondsToSelector:@selector(setPreferredFramesPerSecond:)]){
            _displayLink.preferredFramesPerSecond = 2;
        }
        else{
            _displayLink.frameInterval = 60/15;
        }
        _showRunLoop = [NSRunLoop currentRunLoop];
        [_displayLink addToRunLoop:_showRunLoop forMode:NSDefaultRunLoopMode];
        //        [_showRunLoop run];
        //        [_showRunLoop runMode:NSRunLoopCommonModes beforeDate:[NSDate distantFuture]];
        CFRunLoopRun();
//        [_displayLink invalidate];
//        _displayLink = nil;
        NSLog(@"currentRunLoop>>>>>>>>end");
    }
}

- (void)displayVideo{
    static int count = 0;
//    if(count++<5){
//        return;
//    }
    //会等待前一个执行完，再进来执行
    if(count<2){
        NSLog(@"start>>>>>>>long time");
        [NSThread sleepForTimeInterval:1];
        NSLog(@"end>>>>>>>long time");
    }
    NSLog(@">>>>>>>>%d",count++);
}

- (void)backAction{
    if(_displayLink){
        if(_showRunLoop){
            [_displayLink removeFromRunLoop:_showRunLoop forMode:NSDefaultRunLoopMode];
            CFRunLoopStop(_showRunLoop.getCFRunLoop);
        }
        //        [_videoLink invalidate];
        //        _videoLink = nil;
        NSLog(@"currentRunLoop destroy_videoLink");
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
    
- (void)dealloc{
    NSLog(@">>>>>dealloc");
    if(_displayLink){
        if(_showRunLoop){
            [_displayLink removeFromRunLoop:_showRunLoop forMode:NSDefaultRunLoopMode];
            CFRunLoopStop(_showRunLoop.getCFRunLoop);
        }
        //        [_videoLink invalidate];
        //        _videoLink = nil;
        NSLog(@"currentRunLoop destroy_videoLink");
    }
}

- (void)btnAction:(UIButton *)sender{
//    switch (sender.tag) {
//        case 100:
//        {
//            [FIRAnalytics logEventWithName:kFIREventSelectContent
//                                parameters:@{
//                                             kFIRParameterItemID:[NSString stringWithFormat:@"id-%@", sender.titleLabel.text],
//                                             kFIRParameterItemName:sender.titleLabel.text,
//                                             kFIRParameterContentType:@"image"
//                                             }];
////            [ZXFireBaseManage reportEvent:@"testBtn1" withParameters:@{
////                                                                       @"name":@"helloBtn",
////                                                                       @"id":@"122222"
////                                                                       }];
//        }
//            break;
//        case 101:
//        {
//            [FIRAnalytics logEventWithName:@"testBtn"
//                                parameters:@{
//                                             @"name": @"wulang",
//                                             @"full_text": @"hello"
//                                             }];
//        }
//            break;
//        default:
//            break;
//    }
    
}


@end
