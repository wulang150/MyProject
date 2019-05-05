//
//  YYKitTestViewController.m
//  MyProject
//
//  Created by anker on 2018/12/28.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "YYKitTestViewController.h"

@interface YYKitTestViewController ()

@end

@implementation YYKitTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI{
    
    [self setNavWithTitle:@"YYKit" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
//    [self testTapStr];
    [self test1];
}

- (void)testTapStr{
//    NSMutableAttributedString *attriStr = [[@"hello world what is your name" toAttributedStr:[UIFont systemFontOfSize:14] color:[UIColor blackColor]] mutableCopy];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:@"hello world what is your name"];
    attriStr.font = [UIFont systemFontOfSize:14];
    //加上阴影
    YYTextShadow *shadow = [YYTextShadow new];
    shadow.color = [UIColor lightGrayColor];
    shadow.offset = CGSizeMake(0, 4);
    attriStr.textShadow = shadow;
    //文字点击事件
    [attriStr setTextHighlightRange:NSMakeRange(6, 6)
                              color:[UIColor greenColor]
                    backgroundColor:[UIColor blueColor]
                          tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
      
        NSLog(@">>>%@ %d-%d",text.string,range.location,range.location+range.length);
    }];
    
    YYLabel *lab = [[YYLabel alloc] init];
    lab.attributedText = attriStr;
    [self.view addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(100));
        make.centerX.equalTo(@(0));
    }];
}

- (void)test1{
    NSMutableAttributedString *allStr = [NSMutableAttributedString new];
    
    NSArray *textArr = @[@"red",@"blue",@"green",@"yellow",@"gray",@"orange",@"right",@"false"];
    for(NSString *color in textArr){
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:color];
        one.font = [UIFont systemFontOfSize:20];
        one.color = [UIColor whiteColor];
        [one insertString:@"   " atIndex:0];
        [one appendString:@"   "];
        [one setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:one.rangeOfAll];
        
        YYTextBorder *border = [YYTextBorder new];
        border.strokeWidth = 1;
        border.cornerRadius = 100;
        border.fillColor = [UIColor redColor];
        //负数，往外扩
        border.insets = UIEdgeInsetsMake(-2, -5, -2, -5);
//        one.textBackgroundBorder = border;
        [one setTextBackgroundBorder:border range:[one.string rangeOfString:color]];
        
        [allStr appendAttributedString:one];
    }
    allStr.lineSpacing = 10;
    allStr.lineBreakMode = NSLineBreakByWordWrapping;
    
    YYTextView *textView = [YYTextView new];
    textView.frame = CGRectMake(0, NavigationBar_HEIGHT + 30, SCREEN_WIDTH, 220);
    textView.attributedText = allStr;
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.view addSubview:textView];
    textView.scrollIndicatorInsets = textView.contentInset;
}

@end
