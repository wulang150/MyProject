//
//  ProTableViewController.m
//  MyProject
//
//  Created by Anker on 2019/1/5.
//  Copyright © 2019 Tmac. All rights reserved.
//

#import "ProTableViewController.h"
#import "FriendCircleCell.h"
#import "FriendCircleNewCell.h"
#import "YYFPSLabel.h"

//#define FLAG              //去掉注释，就是开启了优化的代码，注释就是使用非优化代码

@interface ProTableViewController ()
<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataArr;
    NSInteger num;
}
@property(nonatomic) UITableView *tableView;
@end

@implementation ProTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setNavWithTitle:@"性能" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    dataArr = [NSMutableArray new];
    num = 50;
    
    NSArray *commentArr = @[@"今天是我的生日，大家祝福我吧！",@"我境内第三方上午是的是非得失杀死对方我都是佛挡杀佛是水电费色顺丰到付",@"Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫",@"广告的对方答复地方地方地方地方地方地方少时诵诗书",@"✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫"];
    
    for(int i=0;i<num;i++)
    {
        NSString *name = [NSString stringWithFormat:@"好的名字%d",i];
//        NSString *content = [NSString stringWithFormat:@"万科曾向监管部门举报宝能，材料中提及：自2015年11月至2016年7月间，钜盛华九大资管计划累计持有约11.42亿股万科A股股份。九大资管计划买入均价约18.89元/股，累计持有总额约215.7亿元--%d",i];
        
        FriendMode *model = [[FriendMode alloc] init];
        model.name = name;
//        model.content = content;
        model.commentArr = commentArr;
        model.content = [NSString stringWithFormat:@"%d Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫 Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫",i];
#ifdef FLAG
        FriendLayout *layout = [[FriendLayout alloc] initWithModel:model];
        [dataArr addObject:layout];
#else
        [dataArr addObject:model];
#endif
        
    }
    
    [self.view addSubview:self.tableView];
    
    //加入fps测试工具
    YYFPSLabel *FpsLab = [[YYFPSLabel alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT-60, 0, 0)];
    [self.view addSubview:FpsLab];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, SCREEN_CTM_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

#pragma -mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row%num;
#ifdef FLAG
    FriendCircleNewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[FriendCircleNewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    FriendLayout *layout = [dataArr objectAtIndex:row];
    cell.layout = layout;
    return cell;
#else
    
    FriendCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[FriendCircleCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    FriendMode *model = [dataArr objectAtIndex:row];
    
    cell.model = model;
    
    return cell;
#endif
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row%num;
#ifdef FLAG
    FriendLayout *layout = [dataArr objectAtIndex:row];
    return layout.height;
#else
    FriendMode *model = [dataArr objectAtIndex:row];
    return [FriendCircleCell gainHeight:model];
#endif
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count*1000;
}


@end
