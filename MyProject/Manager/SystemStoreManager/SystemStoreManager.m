//
//  SystemStoreManager.m
//  museRing
//
//  Created by  Tmac on 2017/11/13.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "SystemStoreManager.h"

@implementation SystemStoreManager

//从model或字典获取mainkey对应的值
+ (NSArray *)getMulKey:(id)model mainKeys:(NSArray *)mainKeys
{
    NSMutableArray *prvValArr = [NSMutableArray new];
    for(NSString *tkey in mainKeys)
    {
        NSString * val = @"";
        if([model isKindOfClass:[NSObject class]])
        {
            NSString *str = [NSString stringWithFormat:@"_%@",tkey];
            Ivar ivar = class_getInstanceVariable([model class], [str UTF8String]);
            val = object_getIvar(model, ivar);
        }
        if([model isKindOfClass:[NSDictionary class]])
        {
           val = model[tkey];
        }
        if(![val isKindOfClass:[NSString class]])
            continue;
        
        if(val.length<=0)
        {
            WLlog(@"没有主键内容！");
            return nil;
        }
        [prvValArr addObject:val];
    }
    
    return [prvValArr copy];
}

+ (BOOL)isTheSame:(NSArray *)srcArr decArr:(NSArray *)decArr
{
    if(srcArr.count!=decArr.count)
        return NO;
    for(int i=0;i<decArr.count;i++)
    {
        if(![srcArr[i] isEqualToString:decArr[i]])
            return NO;
    }
    
    return YES;
}

+ (void)insertOrUpdate:(id)model mainKeys:(NSArray *)mainKeys StoreName:(NSString *)StoreName
{
    NSArray *srcArr = [self getMulKey:model mainKeys:mainKeys];

    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:StoreName];
    NSMutableArray *mulArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if(mulArr==nil)
    {
        mulArr = [NSMutableArray new];
    }
    if(![mulArr isKindOfClass:[NSMutableArray class]])
    {
        WLlog(@"提取内容错误！");
        return;
    }
    
    int index = -1,i = 0;
    if(srcArr.count>0)
    {
        for(id tmpModel in mulArr)
        {
            NSArray *decArr = [self getMulKey:tmpModel mainKeys:mainKeys];
            if([self isTheSame:srcArr decArr:decArr])
            {
                index = i;      //找出是否存在记录
                break;
            }
            i++;
        }
    }
    
    if(index==-1)     //插入操作
    {
        [mulArr addObject:model];
    }
    else
    {
        [mulArr replaceObjectAtIndex:index withObject:model];
    }
    
    data = [NSKeyedArchiver archivedDataWithRootObject:mulArr];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:StoreName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (NSArray *)getAllFromStoreName:(NSString *)StoreName
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:StoreName];
    if(data==nil)
        return nil;
    NSMutableArray *mulArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return [mulArr copy];
}

+ (id)getModel:(NSString *)StoreName keys:(NSArray *)keys vals:(NSArray *)vals
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:StoreName];
    if(data==nil)
        return nil;
    NSMutableArray *mulArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    for(id tmpModel in mulArr)
    {
        NSArray *decArr = [self getMulKey:tmpModel mainKeys:keys];
        if([self isTheSame:vals decArr:decArr])
        {
            return tmpModel;
        }
    }
    
    return nil;
}

//删除特定的行
+ (void)deleteByKey:(NSArray *)keys vals:(NSArray *)vals StoreName:(NSString *)StoreName
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:StoreName];
    if(data==nil)
        return;
    NSMutableArray *mulArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    int index = 0;
    for(id tmpModel in mulArr)
    {
        NSArray *decArr = [self getMulKey:tmpModel mainKeys:keys];
        if([self isTheSame:vals decArr:decArr])
        {
            [mulArr removeObjectAtIndex:index];
            
            data = [NSKeyedArchiver archivedDataWithRootObject:mulArr];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:StoreName];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return;
        }
        index++;
    }
}
//删除所有
+ (void)deleteAll:(NSString *)StoreName
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:StoreName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
