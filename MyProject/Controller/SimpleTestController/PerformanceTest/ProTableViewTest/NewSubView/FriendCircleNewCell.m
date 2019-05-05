//
//  FriendCircleNewCell.m
//  ProTableViewTest
//
//  Created by  Tmac on 2018/4/4.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "FriendCircleNewCell.h"
#import "ProTableViewHead.h"

@interface FriendCircleNewCell()
<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic) UIImageView *headImageView;
@property(nonatomic) YYLabel *nameLab;
@property(nonatomic) YYLabel *contentLab;
@property(nonatomic) UITableView *commentTableView;
@end

@implementation FriendCircleNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        [self createView];
    }
    
    return self;
}

- (void)createView
{
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MarginHorizontalPadding, MarginVerticalPadding, HeadImageWidth, HeadImageWidth)];
    _headImageView.backgroundColor = [UIColor redColor];
    _headImageView.layer.cornerRadius = 8;
    [self.contentView addSubview:_headImageView];
    
    _nameLab = [[YYLabel alloc] initWithFrame:CGRectMake(_headImageView.right+MarginHorizontalPadding,MarginVerticalPadding, MaxContentWidth, 30)];
    _nameLab.font = [UIFont systemFontOfSize:TitleFontSize];
    _nameLab.textColor = [UIColor blueColor];
    [self.contentView addSubview:_nameLab];
    
    _contentLab = [[YYLabel alloc] initWithFrame:CGRectMake(_nameLab.x, CGRectGetMaxY(_nameLab.frame)+MarginVerticalPadding, MaxContentWidth, MarginVerticalPadding)];
    _contentLab.font = [UIFont systemFontOfSize:ContentFontSize];
    _contentLab.textColor = [UIColor blackColor];
    _contentLab.numberOfLines = 0;
    _contentLab.displaysAsynchronously = YES;   //比较耗时的渲染操作在后台运行
    _contentLab.clearContentsBeforeAsynchronouslyDisplay = NO;  //在进行后台渲染前是否清除掉之前的内容，如果YES就会先清除之前的内容，可能会出现空白
    [self.contentView addSubview:_contentLab];
    
    _commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(_nameLab.x, _contentLab.bottom+MarginVerticalPadding, MaxContentWidth, 0)];
    _commentTableView.backgroundColor = ColorRGB(230, 230, 230);
    _commentTableView.delegate = self;
    _commentTableView.dataSource = self;
    _commentTableView.scrollEnabled = NO;
    [self.contentView addSubview:_commentTableView];
}

- (void)setLayout:(FriendLayout *)layout
{
    _layout = layout;
    
    _nameLab.text = layout.model.name;
    
    _contentLab.height = _layout.contentLayout.textBoundingSize.height;
    _contentLab.textLayout = _layout.contentLayout;
    
    _commentTableView.height = _layout.commentHeight;
    _commentTableView.top = _contentLab.bottom+MarginVerticalPadding;
    [_commentTableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comment"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"comment"];
        
        YYLabel *textLab = [[YYLabel alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
        textLab.numberOfLines = 0;
        textLab.font = [UIFont systemFontOfSize:CommentFontSize];
        textLab.backgroundColor = ColorRGB(241, 241, 241);
        textLab.tag = 10;
        textLab.displaysAsynchronously = YES;
        [cell.contentView addSubview:textLab];
    }
    
    YYTextLayout *tmpLay = [_layout.commentLayoutArr objectAtIndex:indexPath.row];
    YYLabel *textLab = [cell.contentView viewWithTag:10];
    textLab.height = tmpLay.textBoundingSize.height;
    textLab.textLayout = tmpLay;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYTextLayout *tmpLay = [_layout.commentLayoutArr objectAtIndex:indexPath.row];
    return tmpLay.textBoundingSize.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _layout.commentLayoutArr.count;
}
@end
