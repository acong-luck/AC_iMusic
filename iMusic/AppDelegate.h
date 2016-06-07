//
//  AppDelegate.h
//  iMusic
//
//  Created by FM-13 on 16/6/6.
//  Copyright © 2016年 cong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^playerRemoteEventBlock)(UIEvent *event);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, copy) playerRemoteEventBlock myRemoteEventBlock;

@end

