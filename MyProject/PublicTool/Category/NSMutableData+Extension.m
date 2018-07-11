//
//  NSMutableData+Extension.m
//  SimpleTest
//
//  Created by  Tmac on 17/3/24.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "NSMutableData+Extension.h"

@implementation NSMutableData (Extension)

- (void)appendStructWithSizes:(NSArray *)sizeArr values:(NSArray *)values
{
    if(sizeArr.count!=values.count)
        return;
    
    for(int i=0;i<sizeArr.count;i++)
    {
        int size = [sizeArr[i] intValue];
        
        [self addNum:size value:values[i]];
    }
    
}

- (void)addNum:(int)size value:(id)value
{
    if([value isKindOfClass:[NSNumber class]])
    {
        NSNumber *num = (NSNumber *)value;
        
        NSLog(@"type = %s",[num objCType]);
        if(strcmp([num objCType], @encode(float)) == 0)
        {
            NSLog(@"real = float");
            float v = [num floatValue];
            [self appendBytes:&v length:size];
        }
        else if(strcmp([num objCType], @encode(double)) == 0)
        {
            NSLog(@"real = double");
            double v = [num doubleValue];
            [self appendBytes:&v length:size];
        }
        else
        {
            long v = [num longValue];
            [self appendBytes:&v length:size];
        }
    }
    
    if([value isKindOfClass:[NSString class]])
    {
        value = (NSString *)value;
        //        unsigned char *avec = (unsigned char *)[value UTF8String];
        //        long len = strlen((char *)avec)+1;
        //        len = MIN(len, size);
        //        [self appendBytes:avec length:len-1];
        //        Byte b = 0x00;
        //        [self appendBytes:&b length:1];
        NSData *description = [value dataUsingEncoding:NSUTF8StringEncoding];
        NSData *descriptionData = [PublicFunction getValidCharsForData:description withLength:size];
        [self appendData:descriptionData];
    }
    
    if([value isKindOfClass:[NSData class]])
    {
        [self appendData:value];
    }
    
    if([value isKindOfClass:[NSArray class]])
    {
        NSArray *arr = (NSArray *)value;
        int a = 0;
        long len = MIN(arr.count,size*8);    //位
        len = MIN(sizeof(a)* 8, len);
        long num = len;
        for(int i = 0;i<num;i++)
        {
            if(i>=arr.count)
                break;
            int v = [[arr objectAtIndex:i] intValue];
            
            a |= v<<--len;
        }
        
        [self appendBytes:&a length:size];
    }
    
}
@end
