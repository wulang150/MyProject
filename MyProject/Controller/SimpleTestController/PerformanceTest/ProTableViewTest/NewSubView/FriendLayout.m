//
//  FriendLayout.m
//  ProTableViewTest
//
//  Created by  Tmac on 2018/4/4.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "FriendLayout.h"
#import "ProTableViewHead.h"

@implementation FriendLayout

- (id)initWithModel:(FriendMode *)model
{
    if(self = [super init])
    {
        _model = model;
        _commentLayoutArr = [NSMutableArray new];
        [self resetLayout];
    }
    
    return self;
}

- (void)resetLayout
{
    _height = 0;
    [_commentLayoutArr removeAllObjects];
    
    //内容的处理
    NSMutableAttributedString * content = [[NSMutableAttributedString alloc] initWithString:_model.content];
    content.font = [UIFont systemFontOfSize:ContentFontSize];
    //可自动帮你匹配高度
    YYTextContainer * container = [YYTextContainer containerWithSize:CGSizeMake(MaxContentWidth, CGFLOAT_MAX)];
    container.truncationType = YYTextTruncationTypeEnd;
    _contentLayout = [YYTextLayout layoutWithContainer:container text:content];
    
    _commentHeight = 0;
    //处理评论
    for(NSString *str in _model.commentArr)
    {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
        YYTextContainer * container = [YYTextContainer containerWithSize:CGSizeMake(MaxContentWidth, CGFLOAT_MAX)];

        YYTextLayout * layout = [YYTextLayout layoutWithContainer:container text:text];
        [_commentLayoutArr addObject:layout];
        _commentHeight += layout.textBoundingSize.height;
    }
    
    _height = MarginVerticalPadding*4+30+_contentLayout.textBoundingSize.height+_commentHeight;
}

@end
