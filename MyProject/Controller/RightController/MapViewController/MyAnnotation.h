//
//  MyAnnotation.h
//  MyProject
//
//  Created by anker on 2018/12/4.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyAnnotation : NSObject<MKAnnotation>
{
    
}

@property (readonly, nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;

- (instancetype)initWithLocation:(CLLocationCoordinate2D)coord;
@end

NS_ASSUME_NONNULL_END
