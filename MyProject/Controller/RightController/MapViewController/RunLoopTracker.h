//
//  RunLoopTracker.h
//  ADemo
//
//  Created by Anker on 2018/11/16.
//  Copyright © 2018 Anker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RunLoopTracker : NSObject

+(void)startTracking:(CFRunLoopRef)runloop;

+(void)startTracking:(CFRunLoopRef)runloop threshold:(double)millisecond;

+(void)stopTracking:(CFRunLoopRef)runloop;

@end

NS_ASSUME_NONNULL_END
