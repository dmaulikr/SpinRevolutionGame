//
//  AppDelegate.h
//  Revolution
//
//  Created by Martí Serra Vivancos on 08/02/14.
//  Copyright (c) 2014 Tomorrow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mixpanel.h"
#import <GameKit/GameKit.h>
#import "Appirater.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Mixpanel *mixpanel;

@end
