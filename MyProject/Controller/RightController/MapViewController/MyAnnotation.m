//
//  MyAnnotation.m
//  MyProject
//
//  Created by anker on 2018/12/4.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

@synthesize coordinate;
//@synthesize title;
//@synthesize subtitle;

- (instancetype)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self != nil) {
        coordinate = coord;
    }
    return self;
}
@end
