//
//  FriendCircleCell.m
//  ProTableViewTest
//
//  Created by  Tmac on 2018/4/4.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "FriendCircleCell.h"
#import "ProTableViewHead.h"

@interface FriendCircleCell()
<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic) UIImageView *headImageView;
@property(nonatomic) UILabel *nameLab;
@property(nonatomic) UILabel *contentLab;
@property(nonatomic) UITableView *commentTableView;
@end

@implementation FriendCircleCell

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
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(_headImageView.right+MarginHorizontalPadding,MarginVerticalPadding, MaxContentWidth, 30)];
    _nameLab.font = [UIFont systemFontOfSize:TitleFontSize];
    _nameLab.textColor = [UIColor blueColor];
    [self.contentView addSubview:_nameLab];
    
    _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(_nameLab.x, CGRectGetMaxY(_nameLab.frame)+MarginVerticalPadding, MaxContentWidth, MarginVerticalPadding)];
    _contentLab.font = [UIFont systemFontOfSize:ContentFontSize];
    _contentLab.textColor = [UIColor blackColor];
    _contentLab.numberOfLines = 0;
//    _contentLab.layer.drawsAsynchronously = YES;
    [self.contentView addSubview:_contentLab];
    
    _commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(_nameLab.x, _contentLab.bottom+MarginVerticalPadding, MaxContentWidth, 0)];
    _commentTableView.backgroundColor = ColorRGB(230, 230, 230);
    _commentTableView.delegate = self;
    _commentTableView.dataSource = self;
    _commentTableView.scrollEnabled = NO;
    [self.contentView addSubview:_commentTableView];
}

+ (CGSize)getTextFixRect:(NSString *)text maxWidth:(CGFloat)maxWidth fontSize:(int)fontSize
{
    NSString *tmpStr = text;
    
    CGRect rect = [tmpStr boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    float h = ceilf(rect.size.height);
    if(text==nil||text.length==0)
        h = 0;
    
    return CGSizeMake(ceilf(rect.size.width), h);
}

- (void)setModel:(FriendMode *)model
{
    _model = model;
    _nameLab.text = model.name;
    
    CGSize contentSize = [[self class] getTextFixRect:model.content maxWidth:MaxContentWidth fontSize:ContentFontSize];
    _contentLab.height = contentSize.height;
    _contentLab.text = model.content;
    
    CGFloat commentH = [[self class] gainCommentHeight:model.commentArr];
    
    _commentTableView.top = _contentLab.bottom+MarginVerticalPadding;
    _commentTableView.height = commentH;
    [_commentTableView reloadData];
}

+ (CGFloat)gainHeight:(FriendMode *)model
{
    CGFloat height = MarginVerticalPadding*2+30;
    CGSize contentSize = [self getTextFixRect:model.content maxWidth:MaxContentWidth fontSize:ContentFontSize];
    height += contentSize.height;
    
    height = height>HeadImageWidth?height:HeadImageWidth;
    
    height += MarginVerticalPadding;
    
    CGFloat commentH = [self gainCommentHeight:model.commentArr];
    if([self gainCommentHeight:model.commentArr]>0)
    {
        height += commentH+MarginVerticalPadding;
    }
    
    return height;
}

+ (CGFloat)gainCommentHeight:(NSArray *)commentArr
{
    CGFloat height = 0;
    for(NSString *str in commentArr)
    {
        CGSize size = [self getTextFixRect:str maxWidth:MaxContentWidth fontSize:CommentFontSize];
        height += size.height;
    }
    
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comment"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"comment"];

        UILabel *textLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
        textLab.numberOfLines = 0;
        textLab.font = [UIFont systemFontOfSize:CommentFontSize];
        textLab.backgroundColor = ColorRGB(241, 241, 241);
        textLab.tag = 10;
        [cell.contentView addSubview:textLab];
    }
    
    NSString *str = [_model.commentArr objectAtIndex:indexPath.row];
    
    UILabel *textLab = [cell.contentView viewWithTag:10];
    CGSize size = [[self class] getTextFixRect:str maxWidth:MaxContentWidth fontSize:CommentFontSize];
    textLab.height = size.height;
    textLab.text = str;
//    textLab.layer.drawsAsynchronously = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [_model.commentArr objectAtIndex:indexPath.row];
    CGSize size = [[self class] getTextFixRect:str maxWidth:MaxContentWidth fontSize:CommentFontSize];
    return size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _model.commentArr.count;
}
@end
