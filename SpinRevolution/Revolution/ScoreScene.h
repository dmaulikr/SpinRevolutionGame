//
//  ScoreScene.h
//  Revolution
//
//  Created by Martí Serra Vivancos on 08/02/14.
//  Copyright (c) 2014 Tomorrow. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PowerUPMenu.h"
#import "PointsMenu.h"
#import "PUHeader.h"

@interface ScoreScene : SKScene <PUButtonsDelegate, PUMenuDelegate>

// Labels and Text
@property (nonatomic, retain) UILabel *finalScoreLabel;
@property (nonatomic, retain) UILabel *totalPoints;

// Sprites
@property (nonatomic, retain) PUHeader *PUHeaderView;

// Views
@property (nonatomic, retain) PowerUPMenu *powerMenu;
@property (nonatomic, retain) PointsMenu *pointsMenu;

// Others
@property (nonatomic, retain) UIView *mainUI;


@end
