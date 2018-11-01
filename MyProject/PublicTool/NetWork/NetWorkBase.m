//
//  NetWorkBase.m
//  AW600
//
//  Created by DONGWANG on 15/10/21.
//  Copyright © 2015年 DONGWANG. All rights reserved.
//

#import "NetWorkBase.h"
#include <ifaddrs.h>
#include <sys/socket.h>
#include <net/if.h>

@interface NetWorkBase()
<NSURLSessionDownloadDelegate>
@end

@implementation NetWorkBase

+ (NetWorkBase *)netModel
{
    NetWorkBase *obj = [NetWorkBase new];
    
    return obj;
}
/**********************************************AF封装好的直接使用的借口*******************************************************/
#pragma mark 发起GET请求
/**
 *  发送GET请求
 *
 *  @param url       请求url
 *  @param parameters    请求参数
 */
- (void)startGet:(NSString *)url parameters:(NSDictionary *)parameters withBlock:(receiveResponseBlock)block
{
    
    [self startRequest:url parameters:parameters httpMethod:@"GET" withBlock:^(id result, BOOL succ) {
        block(result,succ);
    }];
    
}

#pragma mark 发起POST请求
/**
 *  发送POST请求
 *
 *  @param url       请求url
 *  @param parameters    请求参数
 */
- (void)startPOST:(NSString *)url parameters:(NSDictionary *)parameters withBlock:(receiveResponseBlock)block
{
    [self startRequest:url parameters:parameters httpMethod:@"POST" withBlock:^(id result, BOOL succ) {
        block(result,succ);
    }];
}

#pragma mark 上传文件到服务器
/**
 *  上传文件到服务器
 *
 *  @param url        请求url
 *  @param parameters 请求参数
 *  @param files      要上传的文件数组
 *  @param uploadType 上传的文件类型
 */
//- (void)uploadFiles:(NSString *)url parameters:(NSDictionary *)parameters fileArray:(NSArray *)files withType:(UploadType)uploadType withBlock:(receiveResponseBlock)block
//{
//    //初始化 AF
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//    [self setGeneralPropertyForManager:manager];
//
//    __block NSInteger count = 0;
//    NSMutableDictionary *resultDic = [NSMutableDictionary new];
//    __block BOOL ret = NO;
//
//    for(NSString *filename in files)
//    {
//        NSURL *filePath = [NSURL fileURLWithPath:filename];
//        [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//            WLlog(@"%@",filePath.path);
//            NSError *error;
//
//            BOOL formDataBool = YES;
//
//            switch (uploadType)
//            {
//                case Image_Png:
//                {
//                    formDataBool = [formData appendPartWithFileURL:filePath name:@"file" fileName:[filePath lastPathComponent] mimeType:@"image/png" error:&error];
//                }
//
//                    break;
//                case Image_jpeg:
//                {
//                    formDataBool = [formData appendPartWithFileURL:filePath name:@"file" fileName:[filePath lastPathComponent] mimeType:@"image/jpeg" error:&error];
//                }
//
//                    break;
//                case File_Zip:
//                {
//                    formDataBool = [formData appendPartWithFileURL:filePath name:@"file" fileName:[filePath lastPathComponent] mimeType:@"application/octet-stream" error:&error];
//                }
//
//                    break;
//                case File_Other:
//                {
//                }
//
//                    break;
//                case File_Xml:
//                {
//                    formDataBool = [formData appendPartWithFileURL:filePath name:@"file" fileName:[filePath lastPathComponent] mimeType:@"text/xml" error:&error];
//                    break;
//                }
//
//                default:
//                    break;
//            }
//
//            if (formData == NO)
//            {
//                WLlog(@"Append part failed with error: %@", error);
//            }
//
//        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//            ret = YES;
//            NSString *str = [self dealSuccResult:responseObject];
//            NSString *value = [NSString stringWithFormat:@"%@:%d",str,1];
//            NSString *filestr = files[count];
//            [resultDic setObject:value forKey:filestr];
//            if((++count)>=files.count)
//            {
//                block(resultDic,ret);
//            }
//
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//            //有一个文件上传成功都算是成功
//            NSString *value = [NSString stringWithFormat:@"%@:%d",error.description,0];
//            NSString *filestr = files[count];
//            [resultDic setObject:value forKey:filestr];
//            if((++count)>=files.count)
//            {
//                block(resultDic,ret);
//            }
//            WLlog(@"Error: %@", error);
//
//        }];
//    }
//}

- (void)uploadFiles:(NSString *)url parameters:(NSDictionary *)parameters fileDic:(NSDictionary *)files withType:(UploadType)uploadType withBlock:(receiveResponseBlock)block
{
    //初始化 AF
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [self setGeneralPropertyForManager:manager];
    
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSError *error;
        
//        BOOL formDataBool = YES;
        
        for(NSString *filename in files.allKeys)
        {
            NSString *fileData = [files objectForKey:filename];
            NSArray *fileArr = [self gainTypeAndName:fileData filename:filename uploadType:uploadType];
            
            if([fileData isKindOfClass:[NSData class]])
            {
                NSData *mydata = (NSData *)fileData;
                [formData appendPartWithFileData:mydata name:filename fileName:fileArr[0] mimeType:fileArr[1]];
            }
            else if([fileData isKindOfClass:[NSString class]])
            {
                NSURL *filePath = [NSURL fileURLWithPath:fileData];
                [formData appendPartWithFileURL:filePath name:filename fileName:fileArr[0] mimeType:fileArr[1] error:&error];
            }
            
            if (formData == NO)
            {
                WLlog(@"Append part failed with error: %@", error);
            }
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        

        NSString *value = [self dealSuccResult:responseObject];
        if(block)
            block(value,YES);
        
        WLlog(@"result：%@",value);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //有一个文件上传成功都算是成功
        NSString *value = [NSString stringWithFormat:@"%@",error.description];
        if(block)
            block(value,NO);
        
        WLlog(@"Error: %@", value);
        
    }];
}

//- (void)uploadFile:(NSString *)url parameters:(NSDictionary *)parameters filePath:(NSString *)filePath withType:(UploadType)uploadType withBlock:(receiveResponseBlock)block
//{
//    
//    [self uploadFiles:url parameters:parameters fileArray:@{@"file":filePath} withType:uploadType withBlock:^(id result, BOOL succ) {
//
//        if(block)
//            block(result,succ);
//
//    }];
//}

#pragma mark 下载文件

- (void)downloadFilewithURL:(NSString *)downloadUrl filePath:(NSString *)_filePath withResult:(void(^)(BOOL succ,NSData *data,CGFloat percent,NSURLResponse * response))isSuccess
{
    
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    
    //请求时间为5秒，超过5秒为超时
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:50.0f];
    
    NSURLSessionDownloadTask *_task=[session downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //下载进度
        WLlog(@"%f",downloadProgress.fractionCompleted);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(isSuccess)
                isSuccess(YES,nil,downloadProgress.fractionCompleted,nil);
        });
        
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //下载到哪个文件夹
        NSString *cachePath=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        
        NSString *fileName=[cachePath stringByAppendingPathComponent:response.suggestedFilename];
        if(_filePath!=nil)
            fileName = _filePath;
        return [NSURL fileURLWithPath:fileName];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if(!error)
        {
            //下载完成了
            WLlog(@"下载完成 %@",filePath);
            NSData *data = [NSData dataWithContentsOfURL:filePath];
            if(isSuccess)
                isSuccess(YES,data,1.0,response);
        }
        else
            if(isSuccess)
                isSuccess(NO,nil,1.0,response);
        
    }];
    
    [_task resume];
}




#pragma mark POST与GET请求通用
/**
 *  核心请求 POST与GET请求通用
 *
 *  @param url        请求url
 *  @param parameters 请求参数
 *  @param method     GET @“GET” POST @“POST”
 */
- (void)startRequest:(NSString *)url parameters:(NSDictionary *)parameters httpMethod:(NSString *)method withBlock:(receiveResponseBlock)block
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self setGeneralPropertyForManager:manager];
    
    if ([method isEqualToString:@"GET"])
    {
        [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(block)
                block([self dealSuccResult:responseObject],YES);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if(block)
                block(error.description,NO);
        }];
    }
    else if ([method isEqualToString:@"POST"])
    {
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            if(block)
                block([self dealSuccResult:responseObject],YES);

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(block)
                block(error.description,NO);

        }];
        
//        [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
//            NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>%d/%d %f",downloadProgress.completedUnitCount,downloadProgress.totalUnitCount,downloadProgress.fractionCompleted);
//            
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            block([self dealSuccResult:responseObject],YES);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            block(error.description,NO);
//        }];
        

        
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:50.0f];
//        NSError *serializationError = nil;
//        NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:url relativeToURL:manager.baseURL] absoluteString] parameters:parameters error:&serializationError];
//
//        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
//
//
//        } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
//
//            NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>%d/%d %f",downloadProgress.completedUnitCount,downloadProgress.totalUnitCount,downloadProgress.fractionCompleted);
//
//        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//            if (error) {
//                if (block) {
//                    block(error.description,NO);
//                }
//            } else {
////                if (success) {
////                    success(dataTask, responseObject);
////                }
//
//                if(block)
//                    block([self dealSuccResult:responseObject],YES);
//            }
//        }];
//
//        [dataTask resume];
    }
    
}
#pragma mark AFN请求成功做的处理
- (id)dealSuccResult:(id)responseObject
{
    id jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    
    if (jsonObject)
    {
        return jsonObject;
    }
    else
    {
        if ([responseObject isKindOfClass:[NSData class]])
        {
            NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            return str;
        }
        
        return responseObject;
    }
}

#pragma mark 设置AFHTTPSessionManager一些通用的属性
- (void)setGeneralPropertyForManager:(AFHTTPSessionManager *)manager
{
    AFNetworkReachabilityManager *netStateManager = [AFNetworkReachabilityManager sharedManager];
    [netStateManager startMonitoring];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20;
    
    if (self.needAppendRequestHeader && self.httpHeaderFields)
    {
        //该属性设置会把你传的字典转化成JSON字符串，这个有待查看是否得设置
        //        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        
        for (NSString *key in [self.httpHeaderFields allKeys])
        {
            [manager.requestSerializer setValue:[self.httpHeaderFields objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    AFSecurityPolicy* policy = [AFSecurityPolicy defaultPolicy];  //使用默认的设置
    
    [policy setAllowInvalidCertificates:YES];
    [policy setValidatesDomainName:NO];
    manager.securityPolicy = policy;
    
    
}



/**********************************************系统封装接口***********************************************/

/**
 *  设置get Request的特性
 *
 *  @param urlString URL
 *  @param paras Request 的参数
 *
 *  @return 返回设置好的Request
 */
-(NSMutableURLRequest *)getPostRequest:(NSString *)urlString paras:(NSString *)paras
{
    NSString *post =[paras stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [request setURL:url];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    return request;
}

/**
 *  设置get request的特性
 *
 *  @param url URL
 *
 *  @return 返回设置好的Request
 */
-(NSMutableURLRequest *)getRequest:(NSString *)url
{
    url=[NSString stringWithFormat:@"%@",url];
    url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    WLlog(@"get url=%@",url);
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15];
    [request setHTTPMethod:@"GET"];
    
    return request;
}

- (NSArray *)gainTypeAndName:(NSString *)fileData filename:(NSString *)filename uploadType:(UploadType)uploadType
{
    NSString *fileType = @"application/octet-stream";
    if(filename.length<=0)
        filename = @"file";
    switch (uploadType)
    {
        case Image_Png:
        {
            fileType = @"image/png";
            filename = [NSString stringWithFormat:@"%@.png",filename];
        }
            
            break;
        case Image_jpeg:
        {
            fileType = @"image/jpeg";
            filename = [NSString stringWithFormat:@"%@.jpg",filename];
        }
            
            break;
        case File_Zip:
        {
            fileType = @"application/x-zip-compressed";
            filename = [NSString stringWithFormat:@"%@.zip",filename];
        }
            
            break;
        case File_Other:
        {
            fileType = @"application/octet-stream";
        }
            
            break;
        case File_Xml:
        {
            fileType = @"text/xml";
            filename = [NSString stringWithFormat:@"%@.xml",filename];
            break;
        }
            
        default:
            break;
    }
    if([fileData isKindOfClass:[NSString class]])
    {
        NSURL *filePath = [NSURL URLWithString:fileData];
        filename = [filePath lastPathComponent];
    }
    
    return @[filename,fileType];
}
/**
 *  设置REquest的特性
 *
 *  @param urlString URL
 *  @param ParaDic   参数字典
 *
 *  @return 返回设置好的Request
 */
-(NSMutableURLRequest *)getRequestPostImageToUrl:(NSString *)urlString ParaDic:(NSDictionary*)ParaDic fileDic:(NSDictionary *)files withType:(UploadType)uploadType
{
//    WLlog(@"postToUrl:%@ Form:%@ imageKey:%@",urlString,ParaDic,imageName);
    NSString *boundary = @"iOS_fenda_zhuzhuxian_STRING";        //随意的
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];

    unsigned long long lenght = 0;
    NSMutableData *body = [NSMutableData data];
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //加入参数
    for (NSString*key in [ParaDic allKeys])
    {
        NSString *value = [ParaDic objectForKey:key];
        //每个参数的分割线
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@",key, value] dataUsingEncoding:NSUTF8StringEncoding]];
        lenght += value.length;
    }
    //加入上传的文件的data
    for(NSString *filename in files.allKeys)
    {
        NSString *fileData = [files objectForKey:filename];
        NSArray *fileArr = [self gainTypeAndName:fileData filename:filename uploadType:uploadType];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", filename,fileArr[0]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",fileArr[1]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        if([fileData isKindOfClass:[NSData class]])
        {
            NSData *myData = (NSData *)fileData;
            [body appendData:myData];
            lenght += myData.length;
        }
        else if([fileData isKindOfClass:[NSString class]])
        {
            //如果传入的是路径
            [body appendData:[NSData dataWithContentsOfFile:fileData]];
//            [body appendData:[fileData dataUsingEncoding:NSUTF8StringEncoding]];
            NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileData error:nil];
//            unsigned long long tt = [fileAttributes[NSFileSize] unsignedLongLongValue];
            lenght += [fileAttributes[NSFileSize] unsignedLongLongValue];
        }
        
    }
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    //头部加入长度
    [request setValue:[NSString stringWithFormat:@"%llu", lenght] forHTTPHeaderField:@"Content-Length"];

    return request;
}

- (NSString *)URLEncodeStringFromString:(NSString *)string
{
    
    static CFStringRef charset = CFSTR("!@#$%&*()+'\";:=,/?[] ");
    CFStringRef str = (__bridge CFStringRef)string;
    CFStringEncoding encoding = kCFStringEncodingUTF8;
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, str, NULL, charset, encoding));
}

/**
 *  发送POST请求
 *
 *  @param Path    URL路径
 *  @param ParaDic 传入的参数
 */

-(void)postToPath:(NSString *)Path ParaDic:(NSDictionary *)ParaDic withBlock:(receiveResponseBlock)block;
{
    
    NSString *ParaString = nil;
    
    for (int i = 0; i <[ParaDic allKeys].count; i++)
    {
        NSString *key = [ParaDic allKeys][i];
        if (i == 0)
        {
            ParaString = [NSString stringWithFormat:@"%@=%@",key,ParaDic[key]];
        }
        else
        {
            ParaString= [NSString stringWithFormat:@"%@&%@=%@",ParaString,key,ParaDic[key]];
        }
    }
    
    NSMutableURLRequest *request=[self getPostRequest:Path paras:ParaString];
    // 创建会话
    //这个要创建NSURLSessionConfiguration对象
    NSURLSessionConfiguration *scf = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //创建session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:scf delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        WLlog(@"responseCode=%ld",(long)responseCode);
        if (!error && responseCode == 200)
        {
            
            NSString *value = [self dealSuccResult:data];
            if (block)
            {
                block(value,YES);
            }
            WLlog(@"%@",value);
        }
        else
        {
            WLlog(@"error=%@",error.description);
            
            if (block)
            {
                block([@"" dataUsingEncoding:NSUTF8StringEncoding],NO);
            }
        }
    }] resume];
    
    
//    WLlog(@"url=%@",Path);
//    WLlog(@"paras=%@",ParaString);
//
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
//        WLlog(@"responseCode=%ld",(long)responseCode);
//        if (!error && responseCode == 200)
//        {
//
//            NSString *responseString=[NSString stringWithUTF8String:[data bytes]];
//
//            WLlog(@"responseData: %@",responseString);
//
//            if (self.receiveResponseBlock)
//            {
//                self.receiveResponseBlock(data,YES);
//            }
//        }
//        else
//        {
//            WLlog(@"error=%@",error.description);
//
//            if (self.receiveResponseBlock)
//            {
//                self.receiveResponseBlock([@"" dataUsingEncoding:NSUTF8StringEncoding],NO);
//            }
//        }
//
//    }];
}

/**
 *  GET请求
 *
 *  @param Path    URL
 *  @param ParaDic 传入的参数
 */

-(void)getWithPath:(NSString *)Path ParaDic:(NSDictionary *)ParaDic withBlock:(receiveResponseBlock)block
{
    
    NSString *ParaString = nil;
    
    for (int i = 0; i <[ParaDic allKeys].count; i++)
    {
        NSString *key = [ParaDic allKeys][i];
        if (i == 0)
        {
            ParaString = [NSString stringWithFormat:@"%@=%@",key,ParaDic[key]];
        }
        else
        {
            ParaString= [NSString stringWithFormat:@"%@&%@=%@",ParaString,key,ParaDic[key]];
        }
    }
    
    NSMutableURLRequest *request=[self getRequest:[NSString stringWithFormat:@"%@?%@",Path,ParaString]];
    
    // 创建会话
    //这个要创建NSURLSessionConfiguration对象
    NSURLSessionConfiguration *scf = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //创建session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:scf delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        WLlog(@"responseCode=%ld",(long)responseCode);
        if (!error && responseCode == 200)
        {
            NSString *value = [self dealSuccResult:data];
            if (block)
            {
                block(value,YES);
            }
            WLlog(@"%@",value);
        }
        else
        {
            WLlog(@"error=%@",error.description);
            
            if (block)
            {
                block([@"" dataUsingEncoding:NSUTF8StringEncoding],NO);
            }
        }
    }] resume];
    
    
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
//        if (!error && responseCode == 200) //根据返回值来确定返回结果
//        {
//
//            //NSString *responseString=[NSString stringWithUTF8String:[data bytes]];
//            //WLlog(@"responseData: %@",responseString);
//            if (self.receiveResponseBlock)
//            {
//                self.receiveResponseBlock(data,YES);
//            }
//        }
//        else
//        {
//            if (self.receiveResponseBlock)
//            {
//                self.receiveResponseBlock([@"" dataUsingEncoding:NSUTF8StringEncoding],NO);
//            }
//        }
//    }];
    
}

/**
 *  更新IMG图片
 *
 *  @param urlString URL
 *  @param ParaDic   URL参数
 *  @param img       Image图片
 *  @param imageName Image名称
 */

-(void)uploadImageToUrl:(NSString *)urlString ParaDic:(NSDictionary*)ParaDic andImage:(UIImage*)img imageName:(NSString*)imageName
{
    
//    NSMutableURLRequest *request=[self getRequestPostImageToUrl:urlString ParaDic:ParaDic andImage:img imageName:imageName];
//
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
//        WLlog(@"responseCode = %ld",(long)responseCode);
//        if (!error && responseCode == 200)
//        {
//            WLlog(@"responseData: %@",[NSString stringWithUTF8String:[data bytes]]);
//
//            if (self.receiveResponseBlock)
//            {
//                self.receiveResponseBlock(data,YES);
//            }
//        }
//        else
//        {
//            WLlog(@"error=%@",error.description);
//
//            if (self.receiveResponseBlock)
//            {
//                self.receiveResponseBlock([@"" dataUsingEncoding:NSUTF8StringEncoding],NO);
//            }
//        }
//
//    }];
}


- (NSString*)dicToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (BOOL)isReachable {
    return  [[AFNetworkReachabilityManager sharedManager] isReachable];
}


#pragma mark - 使用AFN检测网络连接
+ (void)reachNetWorkWithBlock:(void (^)(BOOL blean))block;
{
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         BOOL isconnect = NO;
         if ( status > 0 )
         {
             isconnect = YES;
         }
         if(block)
             block(isconnect);
     }];
}

- (void)SysUploadFiles1:(NSString *)url parameters:(NSDictionary *)parameters fileDic:(NSDictionary *)files withType:(UploadType)uploadType withBlock:(receiveResponseBlock)block
{
    NSMutableURLRequest *request = [self getRequestPostImageToUrl:url ParaDic:parameters fileDic:files withType:uploadType];
    request.timeoutInterval = 60;
    // 创建会话
    //这个要创建NSURLSessionConfiguration对象
    NSURLSessionConfiguration *scf = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //创建session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:scf delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        WLlog(@"responseCode=%ld",(long)responseCode);
        if (!error && responseCode == 200)
        {
            NSString *value = [self dealSuccResult:data];
            if (block)
            {
                block(value,YES);
            }
            WLlog(@"%@",value);
        }
        else
        {
            WLlog(@"error=%@",error.description);
            
            if (block)
            {
                block([@"" dataUsingEncoding:NSUTF8StringEncoding],NO);
            }
        }
    }] resume];
    
//    [[session uploadTaskWithRequest:request fromFile:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
//        WLlog(@"responseCode=%ld",(long)responseCode);
//        if (!error && responseCode == 200)
//        {
//            NSString *value = [self dealSuccResult:data];
//            if (block)
//            {
//                block(value,YES);
//            }
//            WLlog(@"%@",value);
//        }
//        else
//        {
//            WLlog(@"error=%@",error.description);
//
//            if (block)
//            {
//                block([@"" dataUsingEncoding:NSUTF8StringEncoding],NO);
//            }
//        }
//    }] resume];
}

- (void)SysUploadFiles:(NSString *)url parameters:(NSDictionary *)parameters fileDic:(NSDictionary *)files withType:(UploadType)uploadType withBlock:(receiveResponseBlock)block
{
    NSMutableURLRequest *request = [self getRequestPostImageToUrl:url ParaDic:parameters fileDic:files withType:uploadType];
    request.timeoutInterval = 60;
    // 创建会话
    //这个要创建NSURLSessionConfiguration对象
    NSURLSessionConfiguration *scf = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //创建session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:scf delegate:self delegateQueue:[NSOperationQueue mainQueue]];

    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        WLlog(@"responseCode=%ld",(long)responseCode);
        if (!error && responseCode == 200)
        {
            NSString *value = [self dealSuccResult:data];
            if (block)
            {
                block(value,YES);
            }
            WLlog(@"%@",value);
        }
        else
        {
            WLlog(@"error=%@",error.description);

            if (block)
            {
                block([@"" dataUsingEncoding:NSUTF8StringEncoding],NO);
            }
        }
    }] resume];
}

- (void)SysDownloadFilewithURL:(NSString *)downloadUrl filePath:(NSString *)filePath withResult:(void(^)(BOOL succ,NSString *saveFilePath))isSuccess
{
    // 1. 创建url
    NSURL *Url = [NSURL URLWithString:downloadUrl];
    
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    request.timeoutInterval = 60;
    
    // 创建会话
    //这个要创建NSURLSessionConfiguration对象
    NSURLSessionConfiguration *scf = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //创建session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:scf delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    //4.发起并且继续任务，想要下载进度，使用下面的方法，使用downloadTaskWithRequest会导致delegate无法调用
    //    [[session downloadTaskWithURL:Url] resume];
    
    NSURLSessionDownloadTask *downLoadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        BOOL isSucc = NO;
        NSString *tmpfile;
        if (!error)
        {
            // 下载成功
            // 注意 location是下载后的临时保存路径, 需要将它移动到需要保存的位置
            NSError *saveError;
            // 创建一个自定义存储路径
            NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *savePath = [cachePath stringByAppendingPathComponent:response.suggestedFilename];
            if(filePath.length>0)
            {
                savePath = filePath;
                
            }
            NSURL *saveURL = [NSURL fileURLWithPath:savePath];
            [[NSFileManager defaultManager] removeItemAtURL:saveURL error:nil];
            // 文件复制到cache路径中
            [[NSFileManager defaultManager] copyItemAtURL:location toURL:saveURL error:&saveError];
            
            if (!saveError) {
                NSLog(@"保存成功>>>%@",savePath);
                tmpfile = savePath;
                //删除保存的临时文件
                [[NSFileManager defaultManager] removeItemAtURL:location error:nil];
            } else {
                tmpfile = [location absoluteString];
                NSLog(@"error is %@", saveError.localizedDescription);
            }
            
            isSucc = YES;
        }
        else
        {
            NSLog(@"error is : %@", error.localizedDescription);
        }
        
        if(tmpfile.length<=0)
            isSucc = NO;
        
        if(isSuccess)
            isSuccess(isSucc,tmpfile);
    }];
    // 恢复线程, 启动任务
    [downLoadTask resume];
}


#pragma -mark NSURLSessionDelegate
// 下载过程中 会多次调用, 记录下载进度
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    // 记录下载进度
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>%0.1f",(float)totalBytesWritten / totalBytesExpectedToWrite);
}

// 下载完成
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>下载文件成功");
//    NSError *error;
//    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *savePath = [cachePath stringByAppendingPathComponent:@"savename"];
//
//    NSURL *saveUrl = [NSURL fileURLWithPath:savePath];
//    // 通过文件管理 复制文件
//    [[NSFileManager defaultManager] copyItemAtURL:location toURL:saveUrl error:&error];
//    if (error) {
//        NSLog(@"Error is %@", error.localizedDescription);
//    }
}
@end
