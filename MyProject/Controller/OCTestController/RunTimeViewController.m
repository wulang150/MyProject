//
//		File Name:		RunTimeViewController.m
//		Product Name:	MyProject
//		Author:			anker@Tmac
//		Created Date:	2021/5/19 10:08 AM
//		
// * Copyright © 2021 Anker Innovations Technology Limited All Rights Reserved.
// * The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
//		All rights reserved.
//'--------------------------------------------------------------------'
	

#import "RunTimeViewController.h"
#import <objc/runtime.h>

@implementation BCTestMode

- (int)showTT:(int)val{
    NSLog(@"%s-->%d",__func__,val);
    return 1;
}
- (void)test2{
    NSLog(@"%s",__func__);
}

void test3(){
    NSLog(@"%s",__func__);
}

//+ (BOOL)resolveInstanceMethod:(SEL)sel{
//    if(sel == @selector(test)){
////        Method met = class_getInstanceMethod(self, @selector(test2));
////
////        class_addMethod(self, sel, method_getImplementation(met), method_getTypeEncoding(met));
//
//        class_addMethod(self, sel, (IMP)test3, "v@:");
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
//    if(aSelector == @selector(test)){
////        return [[self class] instanceMethodSignatureForSelector:@selector(test2)];
//        return [NSMethodSignature signatureWithObjCTypes:"i@:"];
//    }
//    return [super methodSignatureForSelector:aSelector];
    
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
//    [anInvocation invoke];
    if(anInvocation.selector == @selector(test)){
        anInvocation.selector = @selector(test2);
        [anInvocation invoke];
    }
    if(anInvocation.selector == @selector(showMsg:)){
        //如果上面签名不对，[anInvocation getArgument:&i atIndex:2];这种可能会崩溃
//        int i = 0;
//        [anInvocation getArgument:&i atIndex:2];
//        NSLog(@"anInvocation>>%d",i);
        anInvocation.selector = @selector(showTT:);
        [anInvocation invoke];
    }
    NSLog(@"invocation>>>>%a %s",anInvocation.target,anInvocation.selector);
}
@end

@interface RunTimeViewController ()

@end

@implementation RunTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavWithTitle:@"Test" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
    BCTestMode *testMode = [[BCTestMode alloc] init];
    [testMode test];
    
    [testMode showMsg:10];
}

@end
