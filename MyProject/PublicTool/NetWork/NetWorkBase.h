//
//  NetWorkBase.h
//  AW600
//
//  Created by DONGWANG on 15/10/21.
//  Copyright © 2015年 DONGWANG. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFImageDownloader.h"

typedef void (^receiveResponseBlock)(id result,BOOL succ);


typedef NS_ENUM(NSInteger,UploadType)
{
    Image_Png,
    Image_jpeg,
    File_Zip,
    File_Other, //空闲状态
    File_Xml
    
};



@interface NetWorkBase : NSObject


+ (NetWorkBase *)netModel;

//@property (nonatomic,copy) void (^receiveResponseBlock) (id result,BOOL succ);

//标识请求是否需要追加请求头
@property (nonatomic,assign)BOOL needAppendRequestHeader;

//需要追加的HTTP请求头,由key和value组成字典
@property (nonatomic,strong)NSDictionary *httpHeaderFields;

/**********************************************AF封装好的直接使用的借口*****************************/
#pragma mark 发起GET请求
/**
 *  发送GET请求
 *
 *  @param url       请求url
 */
- (void)startGet:(NSString *)url parameters:(NSDictionary *)parameters withBlock:(receiveResponseBlock)block;


#pragma mark 发起POST请求
/**
 *  发送POST请求
 *
 *  @param url       请求url
 */
- (void)startPOST:(NSString *)url parameters:(NSDictionary *)parameters withBlock:(receiveResponseBlock)block;


#pragma mark 上传文件到服务器
/**
 *  上传文件到服务器 
 *
 *  @param url        请求url
 *  @param parameters 请求参数
 *  @param files      要上传的文件字典 @{filename:filepath/fileData}
 *  @param uploadType 上传的文件类型
 */
//这个是循环多次调用上传接口
//- (void)uploadFiles:(NSString *)url parameters:(NSDictionary *)parameters fileArray:(NSArray *)files withType:(UploadType)uploadType withBlock:(receiveResponseBlock)block;
//这个是一次上传多个文件
- (void)uploadFiles:(NSString *)url parameters:(NSDictionary *)parameters fileDic:(NSDictionary *)files withType:(UploadType)uploadType withBlock:(receiveResponseBlock)block;

//- (void)uploadFile:(NSString *)url parameters:(NSDictionary *)parameters filePath:(NSString *)filePath withType:(UploadType)uploadType withBlock:(receiveResponseBlock)block;



#pragma mark 下载文件
/**
 *  去服务器下载文件
 *
 *  @param downloadUrl 下载的请求地址
 *  @param block (文件路径，成功与否)
 */
//- (void)downloadFilewithURL:(NSString *)downloadUrl withBlock:(receiveResponseBlock)block;

/*filePath：下载到的文件全路径，包括文件名
 isSuccess：只有succ==true&&data!=nil才算下载成功
 succ==true&&data==nil  下载进度的回调
 succ==false    下载失败
 */
- (void)downloadFilewithURL:(NSString *)downloadUrl filePath:(NSString *)filePath withResult:(void(^)(BOOL succ,NSData *data,CGFloat percent,NSURLResponse * response))isSuccess;


/**********************************************系统封装接口***********************************************/
/**
 *  发送POST请求
 *
 *  @param Path    URL路径
 *  @param ParaDic 传入的参数
 */

-(void)postToPath:(NSString *)Path ParaDic:(NSDictionary *)ParaDic withBlock:(receiveResponseBlock)block;

/**
 *  GET请求
 *
 *  @param Path    URL
 *  @param ParaDic 传入的参数
 */

-(void)getWithPath:(NSString *)Path  ParaDic:(NSDictionary *)ParaDic withBlock:(receiveResponseBlock)block;


//上传图片
//-(void)uploadImageToUrl:(NSString *)urlString ParaDic:(NSDictionary*)ParaDic andImage:(UIImage*)img imageName:(NSString*)imageName;

//- (void)SysUploadFiles1:(NSString *)url parameters:(NSDictionary *)parameters fileDic:(NSDictionary *)files withType:(UploadType)uploadType withBlock:(receiveResponseBlock)block;
//上传文件不大的情况
- (void)SysUploadFiles:(NSString *)url parameters:(NSDictionary *)parameters fileDic:(NSDictionary *)files withType:(UploadType)uploadType withBlock:(receiveResponseBlock)block;

-(void)SysDownloadFilewithURL:(NSString *)downloadUrl filePath:(NSString *)filePath withResult:(void(^)(BOOL succ,NSString *saveFilePath))isSuccess;

+ (BOOL)isReachable;
/**
 *  监测网络状态
 *
 *  @param block 网络状态的回调
 */
+ (void)reachNetWorkWithBlock:(void (^)(BOOL blean))block;

@end
