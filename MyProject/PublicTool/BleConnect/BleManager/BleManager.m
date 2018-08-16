//
//  BleManager.m
//  BleSDK
//
//  Created by  Tmac on 2017/8/31.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "BleManager.h"



#import "BleCommonFun.h"



@interface BleManager()
<BleDataAdaptDelegate>
{
    NSTimer *timer;     //处理发送超时
}

@end

@implementation BleManager

+ (BleManager *)sharedInstance
{
    static id shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
    
}

- (id)init
{
    if(self = [super init])
    {
        __weak BleManager *safeSelf = self;
        _bleOpt = [BleOperatorManager sharedInstance];
       
        _bleOpt.delegate = self;
        _bleOpt.realTimeUpdateDeviceListBlock = ^(NSArray *listArray, NSDictionary *rssiDic, NSDictionary *macDic) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if([safeSelf.delegate respondsToSelector:@selector(didRecvSearchList:rssiDic:macDic:)])
                {
                    [safeSelf.delegate didRecvSearchList:listArray rssiDic:rssiDic macDic:macDic];
                }
            });
        };
        
    }
    
    return self;
}




- (BOOL)sendDataToBandWithType:(int)type data:(NSData *)data
{
    return [self sendDataToBandWithType:type data:data timeout:3];
}

- (BOOL)sendDataToBandWithType:(int)type data:(NSData *)data timeout:(int)timeout
{
    if(data.length<=0)
        return NO;
    
    NSDictionary *dic = [self gainCharacteristic:type];
    //分包
    NSArray *packDataArray = [BleCommonFun packageCurrentSendData:data];
    for(NSData *packData in packDataArray)
    {
//        [_bleOpt sendDataToBand:packData WithServiceUUID:BLE_CHARARCTERISTIC_SERVICE_BT_UUID WithCharacteristicUUID:dic[@"cha"] withWriteType:[dic[@"style"] integerValue]  WithResult:nil];
    }
    
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(timeOutOpt) userInfo:nil repeats:NO];
    
    return YES;
}

- (NSDictionary *)gainCharacteristic:(int)type
{
    switch (type) {
        case 0:
            return @{@"cha":BLE_ATT_UUID_AMDTP_RX0,
                     @"style":@(CBCharacteristicWriteWithoutResponse)};
            break;
        case 1:
            return @{@"cha":BLE_ATT_UUID_AMDTP_RX1,
                     @"style":@(CBCharacteristicWriteWithoutResponse)};
            break;
        case 2:
            return @{@"cha":BLE_ATT_UUID_AMDTP_RX2,
                     @"style":@(CBCharacteristicWriteWithoutResponse)};
            break;
        case 3:
            return @{@"cha":BLE_ATT_UUID_AMDTP_RX3,
                     @"style":@(CBCharacteristicWriteWithoutResponse)};
            break;
        case 4:
            return @{@"cha":BLE_ATT_UUID_AMDTP_RX4,
                     @"style":@(CBCharacteristicWriteWithoutResponse)};
            break;
        case 5:
            return @{@"cha":BLE_ATT_UUID_AMDTP_RX5,
                     @"style":@(CBCharacteristicWriteWithoutResponse)};
            break;
        case 6:
            return @{@"cha":BLE_ATT_UUID_AMDTP_RX6,
                     @"style":@(CBCharacteristicWriteWithoutResponse)};
            break;
            
        default:
            break;
    }
    
    return @{@"cha":BLE_ATT_UUID_AMDTP_RX0,
             @"style":@(CBCharacteristicWriteWithoutResponse)};
}

//发送超时的处理
- (void)timeOutOpt
{
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
    
    if([self.delegate respondsToSelector:@selector(didRecvResultData:type:dataDic:)])
    {
        [self.delegate didRecvResultData:NO type:0 dataDic:nil];
    }
}



//write的回调
-(void)didWriteDataFromBand:(NSData *)data WithServiceUUID:(NSString *)serviceUUID
{
}

/*
 接收数据的代理方法
 
 @param data 已经接收到的数据
 @param serviceUUID 接受到的数据对应的UUID
 */
-(void)didReceiveDataFromBand:(NSData *)data WithServiceUUID:(NSString *)serviceUUID
{
    NSLog(@"+>>didReceiveDataFromBand>>>>>%@",data);
    
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
    if (data == nil || data.length<=0)
    {
        return;
    }
    
    
    
}



@end
