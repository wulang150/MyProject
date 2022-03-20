//
//  TestOneViewController.m
//  MyProject
//
//  Created by Anker on 2019/2/13.
//  Copyright © 2019 Tmac. All rights reserved.
//

#import "TestOneViewController.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
//#import <IJKMediaFramework/IJKMediaFramework.h>

@interface TestOneViewController ()
<UIScrollViewDelegate>
{
    CGRect _imgRect;
}
@property(nonatomic) UIScrollView *scrollView;
@property(nonatomic) UIImageView *imgView;
@property(nonatomic) UILabel *testLab;
//@property(nonatomic) IJKFFMoviePlayerController *ijkPlayer;
@property(nonatomic) NSThread *aliveThread;
@end

@implementation TestOneViewController

- (void)dealloc{
    NSLog(@"TestOneViewController_dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self setNavWithTitle:@"Test" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self testZoom];
    
//    [self testAsynLab];
//    [self testIjkPlayer];
    
//    [self testLiveThread];
    
    [self testFloat];
}

- (void)testUI{
    NSLog(@"fetchData>>>>hello");
}

- (void)testFloat{
//    NSInteger num = -5;
//    CGFloat f = num/100.0;
    CGFloat f = 0.21456555;
    CGFloat f1 = 0.2178777;
    NSLog(@"float>>>%.2f f1=%.2f",f,f1);
}

//测试weak与strong
- (void)testMemWeak{
    NSLog(@"testMemWeak");
    __weak __typeof(self) weakSelf = self;
    [self fetchData:^{
        __strong __typeof(self) strongSelf = weakSelf;
        [strongSelf testUI];
    }];
}

- (void)fetchData:(void(^)(void))callback{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:3];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(callback) callback();
        });
    });
}

//常驻线程
- (void)testLiveThread{
    self.aliveThread = [[NSThread alloc] initWithTarget:self selector:@selector(aliveThreadAction) object:nil];
    [self.aliveThread start];
}

- (void)aliveThreadAction{
    NSLog(@"aliveThreadAction>>>>1");
    
    //子线程带上了NSRunLoop监听，一直监听待处理的事件
    //添加Port 实时监听
//    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];

//    NSTimer *timer = [NSTimer timerWithTimeInterval:3 block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"aliveThreadAction>>>>time");
//    } repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:5
     
                                     target: self
     
                                   selector:@selector(testFun)
     
                                   userInfo: nil
     
                                    repeats: NO];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    //添加runloop
    [[NSRunLoop currentRunLoop]run];
    
    //或者
//    while (1) {
//        //添加runloop
//        [[NSRunLoop currentRunLoop]run];
//    }
    NSLog(@"aliveThreadAction>>>>end");
}

- (void)addToAliveThread{
    NSLog(@"addToAliveThread>>>>2");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self performSelector:@selector(addToAliveThread) onThread:self.aliveThread withObject:nil waitUntilDone:NO];
//    [self toLandscapeLeft];
    [self testMemWeak];
}

- (void)testFun{
    int a[] = {34,56,12,22,78,22,22,22,12,12,23,24};
    int len = sizeof(a)/sizeof(int);
    int tmpS = a[0];
    int max = 1;
    int num = 1;
    for(int i=0;i<len-1;i++){
        if(a[i]==a[i+1]){
            num++;
        }else{
            if(max<num){
                max = num;
                tmpS = a[i];
            }
            num = 1;
        }
    }
    
    printf("result>>>>>>>%d count=%d\n",tmpS,max);
}

- (NSString *)getDocumentWithFile:(NSString *)filename{
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    char ss = [documentsDirectory characterAtIndex:0];
    if(ss=='/')
    {
        documentsDirectory = [documentsDirectory substringFromIndex:1];
    }
    
    return [NSString stringWithFormat:@"%@/%@",documentsDirectory,filename];
}
//测试ijk播放
- (void)testIjkPlayer{
    NSString *videoPath = [self getDocumentWithFile:@"afei.mp4"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:videoPath]){
        NSLog(@"videoFile is not Exist!!!!");
        return;
    }
    
//    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
//    self.ijkPlayer = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:videoPath] withOptions:options];
////    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    self.ijkPlayer.view.frame = CGRectMake(10, 100, self.view.bounds.size.width-20, 280);
////    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
//    self.ijkPlayer.shouldAutoplay = YES;
//    [self.ijkPlayer prepareToPlay];
//    [self.ijkPlayer play];
//
////    self.view.autoresizesSubviews = YES;
//    [self.view addSubview:self.ijkPlayer.view];
}

//测试子线程文本赋值
- (void)testAsynLab{
    self.testLab = [[UILabel alloc] init];
    //-[UILabel setText:] must be used from main thread only
    self.testLab.frame = CGRectMake(20,100,120,32);
    [self.view addSubview:self.testLab];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        self.testLab.text = @"sdfdfdsfsd";
//    });
    
    UILabel *lab1 = [[UILabel alloc] init];
    lab1.text = @"aaaaaaaaa";
    lab1.frame = CGRectMake(20,150,120,32);
    [self.view addSubview:lab1];
}
//测试图片缩放
- (void)testZoom{
//    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.maximumZoomScale=5;
    _scrollView.minimumZoomScale=1;
    _scrollView.delegate=self;
    _scrollView.bounces = NO;
    _scrollView.bouncesZoom = NO;
    [self.view addSubview:_scrollView];
//    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(0);
//    }];
    NSLog(@"init1 %f %f",self.scrollView.contentSize.width,self.scrollView.contentSize.height);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
//    [_scrollView addGestureRecognizer:tap];
    [tap addTarget:self action:@selector(tapAction)];
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-SCREEN_WIDTH*3/4, SCREEN_WIDTH*3/4, SCREEN_WIDTH*3/4)];
    _imgView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    //    [[NSBundle mainBundle] pathForResource:@"test1" ofType:@"jpeg"];
    _imgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test2" ofType:@"jpg"]];
//    _imgView.userInteractionEnabled = NO;
    [_scrollView addSubview:_imgView];
    _imgRect = _imgView.frame;
    
    NSLog(@"init2 %f %f",self.scrollView.contentSize.width,self.scrollView.contentSize.height);
    
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    //设置这个后，初始化的时候，contentSise会跟imgView.frame.size大小一样，缩放时候，imgView.bound的大小不会改变，只会改变frame
    return _imgView;
}

- (void)updateViewCoordinate{
    //图片的像素
    CGFloat imgW = 2560, imgH = 1920;
    CGRect rect = [_imgView convertRect:_imgView.bounds toView:self.view];
    
    NSLog(@"%f %f %f %f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    CGFloat rateW = imgW/rect.size.width;     //每一个单位长度对应多少像素
    CGFloat rateH = imgH/rect.size.height;
    CGFloat leftX = 0, leftY = 0, rightX = 0, rightY = 0;
    //横向一定是大于或等于scrollView.width
    if(rect.origin.y>_scrollView.y){
        
        //竖向还在scrollView内
        leftX = rect.origin.x>=0?0:-rect.origin.x;
        leftY = 0;
        rightX = leftX + _scrollView.width;
        rightY = rect.size.height;
    }else if(rect.origin.y<=_scrollView.y){
        //竖向已经超出了scrollView
        leftX = rect.origin.x>=0?0:-rect.origin.x;
        leftY = _scrollView.y-rect.origin.y;
        rightX = leftX + _scrollView.width;
        rightY = leftY + _scrollView.height;
    }
    //转换为图片的像素位置
    leftX *= rateW;
    leftY *= rateH;
    rightX *= rateW;
    rightY *= rateH;
    
//    NSLog(@"(%f, %f) (%f, %f)",leftX,leftY,rightX,rightY);
}

- (void)scrollViewDidZoom1:(UIScrollView *)scrollView {
    
    CGFloat xcenter = scrollView.width/2 , ycenter = scrollView.height/2;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    //    scrollView.contentOffset = CGPointMake(0, 0);
    //    scrollView.contentInset = UIEdgeInsetsZero;
    self.imgView.center = CGPointMake(xcenter, ycenter);
    NSLog(@"%f  %f  %f  %f  %f  %f",xcenter,ycenter,scrollView.contentSize.width,scrollView.contentSize.height,self.imgView.bounds.size.width,scrollView.contentOffset.y);
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat xcenter = scrollView.width/2 , ycenter = scrollView.height/2;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    self.imgView.center = CGPointMake(xcenter, ycenter);
    
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
//    ShowFunMsg;
//    NSLog(@"%f  %f  %f  %f",scrollView.size.width,scrollView.size.height,scrollView.contentSize.width,scrollView.contentSize.height);
//    NSLog(@"%f  %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    
    
//    [self updateViewCoordinate];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateViewCoordinate) object:nil];
//    [self performSelector:@selector(updateViewCoordinate) withObject:nil afterDelay:0.3];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"%f  %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"eeeeeeeee");
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateViewCoordinate) object:nil];
    [self performSelector:@selector(updateViewCoordinate) withObject:nil afterDelay:0.3];
}


- (void)tapAction{
    static int flag = 1;
    if(flag){
        flag = 0;
        _imgView.size = CGSizeMake(SCREEN_HEIGHT*4/3, SCREEN_HEIGHT);
    }else{
        flag = 1;
        _imgView.size = _imgRect.size;
    }
    
//    _imgView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    _imgView.x = 0;
    _imgView.y = 0;
    self.scrollView.contentSize = _imgView.frame.size;
//    self.scrollView.contentOffset = CGPointMake(_imgView.frame.size.width/2, 0);
    NSLog(@"%f %f",self.scrollView.contentSize.width,self.scrollView.contentSize.height);
}

#pragma mark - ROTATE methods
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self setHoriontal:toInterfaceOrientation==UIDeviceOrientationLandscapeLeft||toInterfaceOrientation==UIDeviceOrientationLandscapeRight];
}

-(void)setHoriontal:(BOOL)hor{
    NSLog(@">>>>>>isHor=%d",hor);
    CGFloat w = [UIScreen mainScreen].bounds.size.width, h = [UIScreen mainScreen].bounds.size.height;
    self.scrollView.zoomScale = 1;
    if(hor){
        //横屏显示
        if(w<h)
        {
            //如果w比h小，表示获取的数据反正，交换数据
            int t = w;
            w = h;
            h = t;
        }
        _imgView.size = CGSizeMake(h*4/3, h);
        
        
    }else{
        if(w>h)
        {
            int t = w;
            w = h;
            h = t;
        }
        _imgView.size = _imgRect.size;
    }
    _imgView.center = CGPointMake(w/2, h/2);
    self.scrollView.contentSize = _imgView.frame.size;
    NSLog(@"%f %f",self.scrollView.contentSize.width,self.scrollView.contentSize.height);
}

#pragma mark - Rotation and Orientation
-(BOOL)shouldAutorotate {
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

-(void)toPortraitScreen{
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
}

-(void)toLandscapeLeft{
//    if([IUtil deviceType] != IDeviceTypeiPad) {
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeLeft) forKey:@"orientation"];
//    }
}

@end
