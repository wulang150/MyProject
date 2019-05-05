//
//  DecodedImageViewController.m
//  MyProject
//
//  Created by Anker on 2019/1/8.
//  Copyright © 2019 Tmac. All rights reserved.
//

#import "DecodedImageViewController.h"
#import "YYFPSLabel.h"
#import "SDWebImageDecoder.h"

//#define ProMote
@interface DecodedImageViewController ()
<UITableViewDelegate,UITableViewDataSource,CALayerDelegate>
{
    
}
@property(nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSCache *memCache;
@property (strong, nonatomic) dispatch_queue_t ioQueue;
@end

@implementation DecodedImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupUI];
}

- (void)setupUI{
    [self setNavWithTitle:@"decode" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
//    [self test1];
    [self testByTableView];
}

- (void)test1{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 380)];
    [self.view addSubview:imageView];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Start2" ofType:@"png"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"IMG_0997" ofType:@"JPG"];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"IMG_2247" ofType:@"HEIC"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
//    UIImage *image = [UIImage imageNamed:@"Rectangle"];
    imageView.image = image;
}

- (void)testByTableView{
    [self.view addSubview:self.tableView];
    
    [self initCache];
    
    //加入fps测试工具
    YYFPSLabel *FpsLab = [[YYFPSLabel alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT-60, 0, 0)];
    [self.view addSubview:FpsLab];
}

- (void)initCache
{
    _memCache = [[NSCache alloc] init];
    _memCache.countLimit = 11;
    // Create IO serial queue
    _ioQueue = dispatch_queue_create("com.hackemist.SDWebImageCache", DISPATCH_QUEUE_SERIAL);
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, SCREEN_CTM_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
}

- (void)queryImageCache:(NSString *)filename block:(void(^)(UIImage *image))block
{
    //从内存去取，如果没取到，就直接读取文件，在缓存起来
    UIImage *image = [self.memCache objectForKey:filename];
    if(image)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(block)
                block(image);
        });
    }
    else
    {
        dispatch_async(_ioQueue, ^{
            
            @autoreleasepool{
                NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"png"];
                UIImage *image = [UIImage imageWithContentsOfFile:path];
                //把解压操作放到子线程
//                image = [UIImage decodedImageWithImage:image];
                [self.memCache setObject:image forKey:filename];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(block)
                        block(image);
                });
            }
        });
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 400;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        //使用普通的UIImageView
        UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 80, 100-12)];
        headImageView.tag = 10;
        [cell.contentView addSubview:headImageView];
        
        //使用CATiledLayer，自带异步加载
//        CATiledLayer *tileLayer = [CATiledLayer layer];
//        tileLayer.frame = CGRectMake(10, 6, 80, 100-12);
//        tileLayer.contentsScale = [UIScreen mainScreen].scale;
//        //CATiledLayer的tileSize属性单位是像素，而不是点，所以为了保证瓦片和表格尺寸一致，需要乘以屏幕比例因子
////        tileLayer.tileSize = CGSizeMake(cell.bounds.size.width * [UIScreen mainScreen].scale, 100 * [UIScreen mainScreen].scale);
////        tileLayer.tileSize = CGSizeMake(cell.bounds.size.width, 100);
//        tileLayer.delegate = self;
//        [tileLayer setValue:@(indexPath.row) forKey:@"index"];
//        [cell.contentView.layer addSublayer:tileLayer];
    }
    
    NSString *fileName = [NSString stringWithFormat:@"Start%zi",indexPath.row%11];
    
#ifdef ProMote
    [self queryImageCache:fileName block:^(UIImage *image) {
        UIImageView *imageView = [cell.contentView viewWithTag:10];
        imageView.image = image;
    }];
#else
    
    @autoreleasepool{
        //两种加载方式，一开始都是比较卡，好像imageNamed方式有缓存，后面再滑动tableView不卡了，因为缓存了解码后的图片。
//        UIImage *image = [UIImage imageNamed:fileName];
        //imageWithContentsOfFile这种方式，一直都是卡顿，证明没有缓存，每次显示都进行了一次解码。
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"png"];
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"IMG_0997" ofType:@"JPG"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        UIImageView *imageView = [cell.contentView viewWithTag:10];
        //给imageView.image赋值时候，才会发生图片解码，如果不执行这代码，发现没产生什么卡顿，证明imageNamed等的图片加载方法耗时不多，主要的耗时操作是在解码阶段。
        imageView.image = image;
    }
    
//    CATiledLayer *tileLayer = [cell.contentView.layer.sublayers lastObject];
//    tileLayer.contents = nil;
//    [tileLayer setValue:@(indexPath.row) forKey:@"index"];
//    [tileLayer setNeedsDisplay];
#endif
    
    return cell;
}

- (void)drawLayer:(CATiledLayer *)layer inContext:(CGContextRef)ctx
{
    NSLog(@"current thread=%@",[NSThread currentThread]);
    //get image index
    NSInteger index = [[layer valueForKey:@"index"] integerValue];
    //load tile image
    NSString *fileName = [NSString stringWithFormat:@"Start%zi",index%11];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"png"];
    UIImage *tileImage = [UIImage imageWithContentsOfFile:filePath];
    
    CGRect imageRect = layer.bounds;
    //draw tile
    UIGraphicsPushContext(ctx);
    [tileImage drawInRect:imageRect];
    UIGraphicsPopContext();
}

@end
