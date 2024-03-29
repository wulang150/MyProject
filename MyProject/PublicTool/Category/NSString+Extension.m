//
//  NSString+Extension.m
//  ProBand
//
//  Created by star.zxc on 15/11/17.
//  Copyright © 2015年 DONGWANG. All rights reserved.
//

#import "NSString+Extension.h"
#import "NSString+EMOEmoji.h"

//正则表达式
#define STR_EMAIL_REGEX @"^((http://)|(https://))?([A-Za-z0-9]+\\.)*[A-Za-z0-9]+@[A-Za-z0-9]+\\.[A-Za-z]{2,6}$"
#define STR_PHONE_REGEX @"^(13|14|15|17|18)\\d{9}$"
#define STR_CAPCHANUM_REGEX @"\\d{5}"
#define STR_PASSWORD_REGEX @"^[0-9a-zA-Z_]{4,20}$"
#define STR_HOMENUM_REGEX @"^((\\+86(\\s|\\-)\\d{3,4}(\\s|\\-))|(\\d{3,4}(\\s|\\-)))?\\d{5,9}$"
#define STR_WECHAT_REGEX @"^((\\+86(\\s|\\-))?1\\d{10})|([A-Za-z0-9]+)|(((http://)|(https://))?([A-Za-z0-9]+\\.)*[A-Za-z0-9]+@[A-Za-z0-9]+\\.[A-Za-z]{2,6})|(\\d{5,11})$"
#define STR_WEB_REGEX @"^(((http)|(https))://)?([A-Za-z0-9]+\\.)+[A-Za-z0-9]{2,6}$"
#define STR_QQ_REGEX @"^\\d{5,11}$"
#define STR_WEIBO_REGEX @"^([A-Za-z0-9]+)|((\\+86(\\s|\\-))?1\\d{10})|(((http://)|(https://))?([A-Za-z0-9]+\\.)*[A-Za-z0-9]+@[A-Za-z0-9]+\\.[A-Za-z]{2,6})$"

@implementation NSString (Extension)

- (BOOL)containAnotherString:(NSString *)anotherString
{
    if (anotherString == nil) {
        return NO;
    }
    if ([self rangeOfString:anotherString].location != NSNotFound)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//判断是否含有标签符号
- (BOOL)stringContainsEmoji
{
//    __block BOOL returnValue = NO;
//    
//    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
//                               options:NSStringEnumerationByComposedCharacterSequences
//                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
//                                const unichar hs = [substring characterAtIndex:0];
//                                if (0xd800 <= hs && hs <= 0xdbff) {
//                                    if (substring.length > 1) {
//                                        const unichar ls = [substring characterAtIndex:1];
//                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
//                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
//                                            returnValue = YES;
//                                        }
//                                    }
//                                } else if (substring.length > 1) {
//                                    const unichar ls = [substring characterAtIndex:1];
//                                    if (ls == 0x20e3) {
//                                        returnValue = YES;
//                                    }
//                                } else {
//                                    if (0x2100 <= hs && hs <= 0x27ff) {
//                                        returnValue = YES;
//                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
//                                        returnValue = YES;
//                                    } else if (0x2934 <= hs && hs <= 0x2935) {
//                                        returnValue = YES;
//                                    } else if (0x3297 <= hs && hs <= 0x3299) {
//                                        returnValue = YES;
//                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
//                                        returnValue = YES;
//                                    }
//                                }
//                            }];
//    
//    return returnValue;
    
    __block BOOL returnValue = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    if (0x2100 <= high && high <= 0x27BF){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

- (NSString *)substringToLength:(NSUInteger)length
{
    NSInteger existTextNum = self.length;
    
    
    if (existTextNum > length&&length>0)
    {
//        NSString *s = [self substringToIndex:length];
//        
//        NSString *tmp = [self substringWithRange:NSMakeRange(length-1, 2)];
//        if([tmp stringContainsEmoji])  //如果最后一个是表情符号
//        {
//            s = [self substringToIndex:length-1];
//        }
//        
//        return s;
        
        NSRange rangeIndex = [self rangeOfComposedCharacterSequenceAtIndex:length];
        return [self substringToIndex:(rangeIndex.location)];
    }
    
    return self;
}

- (NSString *)newfilterEmoji
{
    NSString *nsTextContent = self;
    NSArray *emojiRangeArr = [nsTextContent emo_emojiRanges];

    //只要一识别到输入的有表情,就把它替换掉

    if (emojiRangeArr.count == 1)
    {
        for (NSValue *rangeValue in emojiRangeArr)
        {
            NSRange range = [rangeValue rangeValue];
            nsTextContent = [nsTextContent stringByReplacingCharactersInRange:range withString:@""];
        }
    }
    else if (emojiRangeArr.count > 1)//粘贴的情况下
    {
        NSInteger length = 0;
        for (NSInteger i = 0; i < emojiRangeArr.count; i ++)
        {
            NSRange range = [emojiRangeArr[i] rangeValue];
            if (i > 0)
            {
                range = NSMakeRange(range.location - length, range.length);
            }
            length += range.length;

            nsTextContent = [nsTextContent stringByReplacingCharactersInRange:range withString:@""];

        }
    }
    
    return nsTextContent;
}

- (NSString *)filterEmoji
{
    NSUInteger len = [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    const char *utf8 = [self UTF8String];
    char *newUTF8 = malloc( sizeof(char) * len );
    int j = 0;
    
    //0xF0(4) 0xE2(3) 0xE3(3) 0xC2(2) 0x30---0x39(4)
    for ( int i = 0; i < len; i++ ) {
        unsigned int c = utf8[i];
        BOOL isControlChar = NO;
        if ( c == 4294967280 ||
            c == 4294967089 ||
            c == 4294967090 ||
            c == 4294967091 ||
            c == 4294967092 ||
            c == 4294967093 ||
            c == 4294967094 ||
            c == 4294967095 ||
            c == 4294967096 ||
            c == 4294967097 ||
            c == 4294967088 ) {
            i = i + 3;
            isControlChar = YES;
        }
        if ( c == 4294967266 || c == 4294967267 ) {
            i = i + 2;
            isControlChar = YES;
        }
        if ( c == 4294967234 ) {
            i = i + 1;
            isControlChar = YES;
        }
        if ( !isControlChar ) {
            newUTF8[j] = utf8[i];
            j++;
        }
    }
    newUTF8[j] = '\0';
    NSString *encrypted = [NSString stringWithCString:(const char*)newUTF8
                                             encoding:NSUTF8StringEncoding];
    free(newUTF8);

    return encrypted;
}

-(NSString *)URLEncodedString
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

- (NSString *)filterNoNum
{
    NSMutableString *mulStr = [[NSMutableString alloc] initWithCapacity:20];
    for(int i=0;i<self.length;i++)
    {
        char a = [self characterAtIndex:i];
        if(a>='0'&&a<='9')
            [mulStr appendFormat:@"%c",a];
    }
    
    return mulStr;
}

- (NSString *)URLDecodedString
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

- (NSString *)trimLeftAndRight
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

-(BOOL) isValidEmail
{
    NSPredicate *rexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", STR_EMAIL_REGEX];
    return [rexTest evaluateWithObject:self];
}
-(BOOL) isValidPhoneNumber
{
    NSPredicate *rexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", STR_PHONE_REGEX];
    return [rexTest evaluateWithObject:self];
}
-(BOOL) isValidHomeNumber
{
    NSPredicate *rexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", STR_HOMENUM_REGEX];
    return [rexTest evaluateWithObject:self];
}
-(BOOL) isValidWeChat
{
    NSPredicate *rexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", STR_WECHAT_REGEX];
    return [rexTest evaluateWithObject:self];
}
-(BOOL) isValidWeiBo
{
    NSPredicate *rexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", STR_WEIBO_REGEX];
    return [rexTest evaluateWithObject:self];
}
-(BOOL) isValidQQ
{
    NSPredicate *rexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", STR_QQ_REGEX];
    return [rexTest evaluateWithObject:self];
}
-(BOOL) isValidWeb
{
    NSPredicate *rexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", STR_WEB_REGEX];
    return [rexTest evaluateWithObject:self];
}

//+ (NSString *)mergeStr:(NSString *)rex,...
//{
//    va_list args;
//    va_start(args, rex);
//
//}

//+ (NSString *)mergeStr:(int)num,...
//{
//    NSMutableString *mulStr = [[NSMutableString alloc] init];
//    for(int i=0;i<num;i++)
//    {
//        [mulStr appendString:@"%@"];
//    }
//    va_list args;
//    va_start(args, num);
//
//    NSString *contentStr = [[NSString alloc] initWithFormat:mulStr arguments:args];
//
//    return contentStr;
//}

//获取字体的计算高度
- (CGFloat)heightWithStringAttributes:(NSDictionary *)attributes fixedWidth:(CGFloat)fixedWidth
{
    if(self.length<=0||fixedWidth<=0)
        return 0;
    
    //计算出rect
    CGRect rect = [self boundingRectWithSize:CGSizeMake(fixedWidth, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes context:nil];
    
    return rect.size.height;
}
- (CGFloat)heightWithFont:(UIFont *)font fixedWidth:(CGFloat)fixedWidth
{
    if(!font)
        return 0;
    
    return [self heightWithStringAttributes:@{NSFontAttributeName:font} fixedWidth:fixedWidth];
}
//获取字体的计算宽度
- (CGFloat)widthWithStringAttributes:(NSDictionary *)attributes
{
    if(self.length<=0)
        return 0;
    
    //计算出rect
    CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes context:nil];
    
    return rect.size.width;
}
- (CGFloat)widthWithFont:(UIFont *)font
{
    if(!font)
        return 0;
    
    return [self widthWithStringAttributes:@{NSFontAttributeName:font}];
}

//把数值字符串转换为数值
- (NSNumber *)strToNum
{
    if (nil == self)
    {
        return nil;
    }
    NSScanner * scanner = [NSScanner scannerWithString:self];
    
    unsigned long long longlongValue;
    [scanner scanHexLongLong:&longlongValue];
    //将整数转换为NSNumber,存储到数组中,并返回.
    
    NSNumber * hexNumber = [NSNumber numberWithLongLong:longlongValue];
    return hexNumber;
}

//汉字转拼音
- (NSString *)stringToPinYin
{
    NSMutableString *pinyin = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return [pinyin uppercaseString];
}
//字符转data : FFDF = <ffdf>
- (NSData *)getDataFromString
{
    NSString *command = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *commandToSend= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [command length]/2; i++) {
        byte_chars[0] = [command characterAtIndex:i*2];
        byte_chars[1] = [command characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [commandToSend appendBytes:&whole_byte length:1];
    }
    NSLog(@"commandToSend=%@", commandToSend);
    return commandToSend;
}

//转换为属性字符串
- (NSAttributedString *)toAttributedStr:(UIFont *)font color:(UIColor *)color
{
    NSMutableDictionary *valDic = [[NSMutableDictionary alloc] initWithCapacity:10];
    if(color)
        [valDic setObject:color forKey:NSForegroundColorAttributeName];
    if(font)
        [valDic setObject:font forKey:NSFontAttributeName];
    
    return [[NSAttributedString alloc] initWithString:self attributes:valDic];
}
/*
 转换并拼接属性字符串
 attriArr 前一个字符的属性，用简单的方法，只支持[UIFont sy...]和[UIColor redColor]
 addAttriStr 拼接的字符串
 attriArr1 拼接的字符串的属性
 gapStr 拼接的中间的字符串
 */
- (NSAttributedString *)toAttributedStr:(NSArray *)attriArr addAttriStr:(NSString *)addAttriStr attriArr1:(NSArray *)attriArr1 gapStr:(NSString *)gapStr
{
    if(gapStr.length>0)
        addAttriStr = [NSString stringWithFormat:@"%@%@",gapStr,addAttriStr];
    
    NSMutableDictionary *valDic = [[NSMutableDictionary alloc] initWithCapacity:10];
    NSMutableDictionary *unitDic = [[NSMutableDictionary alloc] initWithCapacity:10];
    
    for(id valsub in attriArr)
    {
        if([valsub isKindOfClass:[UIColor class]])
            [valDic setObject:valsub forKey:NSForegroundColorAttributeName];
        if([valsub isKindOfClass:[UIFont class]])
            [valDic setObject:valsub forKey:NSFontAttributeName];
    }
    
    for(id valsub in attriArr1)
    {
        if([valsub isKindOfClass:[UIColor class]])
            [unitDic setObject:valsub forKey:NSForegroundColorAttributeName];
        if([valsub isKindOfClass:[UIFont class]])
            [unitDic setObject:valsub forKey:NSFontAttributeName];
    }
    
    return [self gainAttrStr:self valAttr:valDic unit:addAttriStr unitAttr:unitDic];

}

- (NSAttributedString *)gainAttrStr:(NSString *)val valAttr:(NSDictionary *)valAttr unit:(NSString *)unit unitAttr:(NSDictionary *)unitAttr
{
    if(valAttr.count<=0||unitAttr.count<=0)
        return nil;
    NSMutableAttributedString *mulStr = [[NSMutableAttributedString alloc] initWithString:val attributes:valAttr];
    
    NSAttributedString *unitStr = [[NSAttributedString alloc] initWithString:unit attributes:unitAttr];
    
    [mulStr appendAttributedString:unitStr];
    
    return mulStr;
}
@end
