//
//  FDTextField.h
//  MyProject
//
//  Created by Anker on 2019/10/16.
//  Copyright © 2019 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDTextField : UITextField

@property (nonatomic,assign) int maxNum;                //最大限制字符数量
@property (nonatomic,assign) BOOL isAllowEmotion;       //是否支持表情
@property (nonatomic,assign) BOOL isMask;               //是否有蒙版，不用蒙版的话，自己要注意控制键盘的消失

//是否自动遮挡上移 superView：自动上移时候，移动的view，如果设置为空，默认是整个window上移
- (void)isAutoUp:(BOOL)isAutoUp superView:(UIView *_Nullable)superView;
@end

NS_ASSUME_NONNULL_END
