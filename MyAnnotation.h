//
//  MyAnnotation.h
//  learn
//
//  Created by David on 2015/2/4.
//  Copyright (c) 2015年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic) UIImage *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (id)initWithLocation:(CLLocationCoordinate2D) coord;

@end
