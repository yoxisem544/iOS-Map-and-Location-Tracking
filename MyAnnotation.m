//
//  MyAnnotation.m
//  learn
//
//  Created by David on 2015/2/4.
//  Copyright (c) 2015年 David. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation
@synthesize coordinate, image, title, subtitle;

- (id)initWithLocation:(CLLocationCoordinate2D)coord
{
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    
    return  self;
}

@end
