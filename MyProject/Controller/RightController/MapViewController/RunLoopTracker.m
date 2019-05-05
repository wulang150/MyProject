//
//  RunLoopTracker.m
//  ADemo
//
//  Created by Anker on 2018/11/16.
//  Copyright © 2018 Anker. All rights reserved.
//

#import "RunLoopTracker.h"

#define RTDKeyObserver @"o"
#define RTDKeyTimestamp @"t"
#define RTDKeyThreshold @"l"

#define kMainRunLoopThresholdMillisecond 300
#define kBackgroundRunLoopThresholdMillisecond 1000


static RunLoopTracker* gTheTracker;

@interface RunLoopTracker() {
}
@property (nonatomic,strong) NSMutableDictionary* runloopMaps;
@end

@implementation RunLoopTracker

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gTheTracker = [[RunLoopTracker alloc] init];
    });
}

-(instancetype)init {
    self = [super init];
    if (self != nil) {
        self.runloopMaps = [NSMutableDictionary dictionary];
    }
    return self;
}

+(void)startTracking:(CFRunLoopRef)runloop {
    double defaultThreshold = runloop==CFRunLoopGetMain() ? kMainRunLoopThresholdMillisecond : kBackgroundRunLoopThresholdMillisecond;
    [self startTracking:runloop threshold:defaultThreshold];
}

+(void)startTracking:(CFRunLoopRef)runloop threshold:(double)millisecond {
    void* pr = (void *)runloop;
    NSNumber* key = [NSNumber numberWithLongLong:(long long)pr];
    if ([gTheTracker.runloopMaps objectForKey:key] != nil) {
        return ;
    }
    NSMutableDictionary* info = [NSMutableDictionary dictionary];
    [gTheTracker.runloopMaps setObject:info forKey:key];
    [info setObject:@(CFAbsoluteTimeGetCurrent()) forKey:RTDKeyTimestamp];
    [info setObject:@(millisecond) forKey:RTDKeyThreshold];
    
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry: {
                NSLog(@"kCFRunLoopEntry");
                CFTimeInterval now = CFAbsoluteTimeGetCurrent();
                NSMutableDictionary* info = [gTheTracker.runloopMaps objectForKey:key];
                [info setObject:@(now) forKey:RTDKeyTimestamp];
            }   break;
            case kCFRunLoopBeforeTimers:
                //                NSLog(@"即将处理timer");
                break;
            case kCFRunLoopBeforeSources:
                //                NSLog(@"即将处理source");
                break;
            case kCFRunLoopBeforeWaiting: {     //一次runloop的结束
                CFTimeInterval now = CFAbsoluteTimeGetCurrent();
                NSDictionary* info = [gTheTracker.runloopMaps objectForKey:key];
                CFTimeInterval last = [[info objectForKey:RTDKeyTimestamp] doubleValue];
                double threshold = [[info objectForKey:RTDKeyThreshold] doubleValue];
                BOOL isMainRunloop = (ptrdiff_t)CFRunLoopGetMain() == [key longLongValue];
                NSString* runloopName = isMainRunloop ? @"main runloop" : @"background runloop";
//                NSLog(@"%@ cost %.3lf ms to finish this run", runloopName, (now-last)*1000);
                double diff = (now-last)*1000;
                if (diff > threshold) {
                    NSLog(@"⚠️⚠️ %@[0x%llx] cost %.3lfms to finish ⚠️⚠️",runloopName,[key longLongValue], diff);
                }
            }   break;
            case kCFRunLoopAfterWaiting: {  //一次runLoop的开始
                CFTimeInterval now = CFAbsoluteTimeGetCurrent();
                NSMutableDictionary* info = [gTheTracker.runloopMaps objectForKey:key];
                [info setObject:@(now) forKey:RTDKeyTimestamp];
                break;
            }
            case kCFRunLoopExit:
                NSLog(@"kCFRunLoopExit");
                break;
            default:
                break;
        }
    });
    CFRunLoopAddObserver(runloop, observer, kCFRunLoopDefaultMode);
    [info setObject:@((long long)observer) forKey:RTDKeyObserver];
}

+(void)stopTracking:(CFRunLoopRef)runloop {
    void* pr = (void*)runloop;
    NSNumber* key = [NSNumber numberWithLongLong:(long long)pr];
    NSMutableDictionary* info = [gTheTracker.runloopMaps objectForKey:key];
    if (info == nil) {
        return ;
    }
    CFRunLoopObserverRef rlo = (CFRunLoopObserverRef)[[info objectForKey:RTDKeyObserver] longLongValue];
    CFRunLoopRemoveObserver(runloop, rlo, kCFRunLoopDefaultMode);
    [gTheTracker.runloopMaps removeObjectForKey:key];
}
@end
