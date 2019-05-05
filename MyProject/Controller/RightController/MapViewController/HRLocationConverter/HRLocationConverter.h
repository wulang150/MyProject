//
//  HRLocationConverter.h
//  museRing
//
//  Created by Payne on 2018/1/23.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface HRLocationConverter : NSObject

/**
 *  判断是否在中国
 *  用 isLocationOutOfChina 判断之前，你先把GCJ-02(火星坐标)转成 WGS-84(地球坐标)
 */
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;

/**
 *  将WGS-84(地球坐标)转为GCJ-02(火星坐标)
 */
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)coordinate;

/**
 *  将GCJ-02(火星坐标)转为BD-09(百度坐标)
 */
+(CLLocationCoordinate2D)transformFromGCJToBaidu:(CLLocationCoordinate2D)coordinate;

/**
 *  将BD-09(百度坐标)转为GCJ-02(火星坐标)
 */
+(CLLocationCoordinate2D)transformFromBaiduToGCJ:(CLLocationCoordinate2D)coordinate;

/**
 *  将GCJ-02(火星坐标)转为WGS-84(地球坐标)
 */
+(CLLocationCoordinate2D)transformFromGCJToWGS:(CLLocationCoordinate2D)coordinate;



@end
