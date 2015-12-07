//
//  SpinnerAction.h
//  Revolution
//
//  Created by Ramon Fernández Mir on 12/03/14.
//  Copyright (c) 2014 Tomorrow. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKEase.h"

@interface SpinnerAction : SKAction

@property (nonatomic) float destination;
@property (nonatomic) bool  speedPUWorking;

- (SKAction *)actionWithNode:(SKNode *)node;
- (float)functionChangeTime;

@end
