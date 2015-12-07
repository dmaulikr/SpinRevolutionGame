//
//  CircleLives.h
//  Revolution
//
//  Created by Ramon Fernández Mir on 20/03/14.
//  Copyright (c) 2014 Tomorrow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface CircleLives : UIView

@property (nonatomic, strong) UIView * life1;
@property (nonatomic, strong) UIView * life2;
@property (nonatomic, strong) UIView * life3;
@property (nonatomic, strong) UIView * life4;
@property (nonatomic, strong) UIView * life5;

@property (nonatomic, retain) NSArray * livesArray;
@property (nonatomic, retain) NSArray * colorsArray;

- (int)nextColor;
- (void)nextLife;
- (void)addLife;

@end
