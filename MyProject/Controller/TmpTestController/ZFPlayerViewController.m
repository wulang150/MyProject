//
//  ZFPlayerViewController.m
//  MyProject
//
//  Created by Anker on 2019/7/4.
//  Copyright © 2019 Tmac. All rights reserved.
//

#import "ZFPlayerViewController.h"
#import <ZFPlayer.h>
#import "ZFPlayerControlView.h"
#import "ZFAVPlayerManager.h"

@interface ZFPlayerViewController ()
{
    NSArray *_itemArr;
    NSString *_documentsDirectory;
}
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;


@end

@implementation ZFPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI{
    [self setNavWithTitle:@"ZFPlayer" leftImage:@"arrow" leftTitle:nil leftAction:@selector(backAction) rightImage:nil rightTitle:nil rightAction:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _itemArr = @[@"testMovie.mp4", @"movieH264.mp4", @"movieH265.mp4"];
    
    _documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
    
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 300)];
    _containerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_containerView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, CGRectGetMaxY(_containerView.frame)+20, 120, 40);
    btn.centerX = _containerView.centerX;
    [btn setTitle:@"play" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor lightGrayColor];
    btn.tag = 100;
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
//    self.player.controlView = self.controlView;
    
    NSArray <NSURL *>*assetURLs = @[
                                    [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",_documentsDirectory,_itemArr[0]]],
                                    [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",_documentsDirectory,_itemArr[1]]],
                                    [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",_documentsDirectory,_itemArr[2]]]
                                    ];
    self.player.assetURLs = assetURLs;
}

- (void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.autoHiddenTimeInterval = 5;
        _controlView.autoFadeTimeInterval = 0.5;
        _controlView.prepareShowLoading = YES;
    }
    return _controlView;
}

- (void)btnAction:(UIButton *)sender{
    switch (sender.tag) {
        case 100:
        {
            sender.selected = !sender.selected;
            if(sender.selected){
                //                [self.player play];
                
                [self.player playTheIndex:0];
            }else{
                //                [self.player pause];
                [self.player.currentPlayerManager pause];
            }
        }
            break;
        case 101:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    
}

@end
