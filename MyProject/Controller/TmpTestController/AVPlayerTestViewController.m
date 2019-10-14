//
//  AVPlayerTestViewController.m
//  MyProject
//
//  Created by Anker on 2019/7/2.
//  Copyright © 2019 Tmac. All rights reserved.
//

#import "AVPlayerTestViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZFPlayer.h"

@interface AVPlayerTestViewController ()
{
    NSString *_documentsDirectory;
    NSArray *_itemArr;
    NSInteger _tapNum;
}
@property(nonatomic) AVPlayer *player;
@property(nonatomic) AVQueuePlayer *queuePlayer;
@property(nonatomic) AVPlayerItem *playerItem;
@property(nonatomic) UIView *movieView;
@end

@implementation AVPlayerTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI{
    [self setNavWithTitle:@"player" leftImage:@"arrow" leftTitle:nil leftAction:@selector(backAction) rightImage:nil rightTitle:nil rightAction:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _itemArr = @[@"testMovie.mp4", @"movieH264.mp4", @"movieH265.mp4"];
    
    _movieView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 300)];
    [self.view addSubview:_movieView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, CGRectGetMaxY(_movieView.frame)+20, 120, 40);
    btn.centerX = _movieView.centerX;
    [btn setTitle:@"play" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor lightGrayColor];
    btn.tag = 100;
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(100, CGRectGetMaxY(btn.frame)+10, 120, 40);
    nextBtn.centerX = _movieView.centerX;
    [nextBtn setTitle:@"next" forState:UIControlStateNormal];
    nextBtn.backgroundColor = [UIColor lightGrayColor];
    nextBtn.tag = 101;
    [nextBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    _documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
    
//    NSURL *videoURL = [NSURL URLWithString:documentsDirectory];
    NSLog(@"path=%@",_documentsDirectory);
    
//    [self createByAVplayer];
    [self createByQueuePlayer];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"%@ %@",keyPath,change);
}

- (void)createByZFPlayer{
    
}

- (void)createByQueuePlayer{
    NSMutableArray *mulArr = [NSMutableArray new];
    for(NSString *filename in _itemArr){
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",_documentsDirectory,filename];
        NSURL *videoURL = [NSURL fileURLWithPath:filePath];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:videoURL];
        [mulArr addObject:playerItem];
    }
    
    self.queuePlayer = [AVQueuePlayer queuePlayerWithItems:mulArr];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.queuePlayer];
    playerLayer.frame = CGRectMake(0, 0, _movieView.width, _movieView.height);
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [_movieView.layer insertSublayer:playerLayer atIndex:0];
}

- (void)createByAVplayer{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",_documentsDirectory,_itemArr[0]];
    NSURL *videoURL = [NSURL fileURLWithPath:filePath];
    //    AVURLAsset *urlAsset = [AVURLAsset assetWithURL:videoURL];
    // 初始化playerItem
    //    self.playerItem = [AVPlayerItem playerItemWithAsset:urlAsset];
    // 也可以使用来初始化playerItem
    self.playerItem = [AVPlayerItem playerItemWithURL:videoURL];
    
    // 初始化Player
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
//    self.player = [AVPlayer playerWithURL:videoURL];
    // 初始化playerLayer
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = CGRectMake(0, 0, _movieView.width, _movieView.height);
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [_movieView.layer insertSublayer:playerLayer atIndex:0];
    
//    if(self.playerItem){
//        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//    }
    
}

- (void)backAction{
//    if(self.playerItem){
//        [self.playerItem removeObserver:self forKeyPath:@"status"];
//    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnAction:(UIButton *)sender{
    switch (sender.tag) {
        case 100:
        {
            sender.selected = !sender.selected;
            if(sender.selected){
//                [self.player play];
                [self.queuePlayer play];
                
            }else{
//                [self.player pause];
                [self.queuePlayer pause];
            }
        }
            break;
        case 101:
        {
            //使用avplayer
//            _tapNum++;
//            NSInteger index = _tapNum%3;
//            NSString *filePath = [NSString stringWithFormat:@"%@/%@",_documentsDirectory,_itemArr[index]];
//            NSURL *videoURL = [NSURL fileURLWithPath:filePath];
//            self.playerItem = [AVPlayerItem playerItemWithURL:videoURL];
//            [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
            
            //使用queuePlayer
            [self.queuePlayer advanceToNextItem];
        }
            break;
            
        default:
            break;
    }
    
    
}
@end
