//
//  AppDelegate.h
//  learn
//
//  Created by David on 2015/2/2.
//  Copyright (c) 2015年 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIBackgroundTaskIdentifier bgTask;
}

@property (strong, nonatomic) UIWindow *window;

- (void)endBackGroundTask;

@end

