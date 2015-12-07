//
//  main.m
//  Revolution
//
//  Created by Martí Serra Vivancos on 08/02/14.
//  Copyright (c) 2014 Tomorrow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QTouchposeApplication.h"
#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool
    {
        return UIApplicationMain(argc, argv,
                                 NSStringFromClass([QTouchposeApplication class]),
                                 NSStringFromClass([AppDelegate class]));
    }
}