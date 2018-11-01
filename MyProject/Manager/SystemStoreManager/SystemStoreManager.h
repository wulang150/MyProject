//
//  SystemStoreManager.h
//  museRing
//
//  Created by  Tmac on 2017/11/13.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemStoreManager : NSObject

/*插入或更新 
 model 可以是NSObject或NSDictionary
 mainKeys 考虑多主键问题，这里使用数组
 */
+ (void)insertOrUpdate:(id)model mainKeys:(NSArray *)mainKeys StoreName:(NSString *)StoreName;

//查找
+ (NSArray *)getAllFromStoreName:(NSString *)StoreName;

+ (id)getModel:(NSString *)StoreName keys:(NSArray *)keys vals:(NSArray *)vals;

//删除特定的行
+ (void)deleteByKey:(NSArray *)keys vals:(NSArray *)vals StoreName:(NSString *)StoreName;
//删除所有
+ (void)deleteAll:(NSString *)StoreName;
@end
