//
//  NSString+Extension.h
//  ProBand
//
//  Created by star.zxc on 15/11/17.
//  Copyright © 2015年 DONGWANG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (BOOL)containAnotherString:(NSString *)anotherString;

- (BOOL)stringContainsEmoji;
//字符串截取，包括表情字符的判断
- (NSString *)substringToLength:(NSUInteger)length;
//过滤掉表情，如果出现疯狂输入，就会应处理不过来，蹦掉
//- (NSString *)filterEmoji;
//新的可以解决上面的问题
- (NSString *)newfilterEmoji;

- (NSString *)URLEncodedString;

- (NSString *)URLDecodedString;

//去掉首位空格
- (NSString *)trimLeftAndRight;
//过滤掉非数字
- (NSString *)filterNoNum;

-(BOOL) isValidEmail;
-(BOOL) isValidPhoneNumber;
-(BOOL) isValidHomeNumber;
-(BOOL) isValidWeChat;
-(BOOL) isValidWeiBo;
-(BOOL) isValidQQ;
-(BOOL) isValidWeb;

//+ (NSString *)mergeStr:(NSString *)rex,...;

//获取字体的计算高度 @{NSFontAttributeName:[UIFont boldSystemFontOfSize:23]}
- (CGFloat)heightWithStringAttributes:(NSDictionary *)attributes fixedWidth:(CGFloat)fixedWidth;
- (CGFloat)heightWithFont:(UIFont *)font fixedWidth:(CGFloat)fixedWidth;
//获取字体的计算宽度
- (CGFloat)widthWithStringAttributes:(NSDictionary *)attributes;
- (CGFloat)widthWithFont:(UIFont *)font;
@end
