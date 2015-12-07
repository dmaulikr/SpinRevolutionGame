//
//  MyScene.h
//  Revolution
//

//  Copyright (c) 2014 Tomorrow. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SpinnerAction.h"
#import "PUHeader.h"
#import "CircleLives.h"
#import "ViewController.h"
#import "KKProgressTimer.h"

@class ViewController;

@interface Game : SKScene <PUButtonsDelegate, KKProgressTimerDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

// Score and time
@property (nonatomic) float   actualScore;
@property (nonatomic) float generalTime;
@property (nonatomic) float gameTime;  // 'Temps de partida'
@property (nonatomic) float colorTime; // 'Temps en cada funcio'
@property (nonatomic) float shiftTime;
@property (nonatomic) float comboTime;

// PowerUps
@property (nonatomic) float immunityUsed;
@property (nonatomic) float comboUsed;
@property (nonatomic) float lifeUsed;

// Bools
@property (nonatomic) bool isTouching;
@property (nonatomic) bool firstTouch;
@property (nonatomic) bool shouldSpin;
@property (nonatomic) bool shouldDecreaseLife;
@property (nonatomic) bool shouldChangeMode;

// Variables inside update
@property (nonatomic) float currentStatus;
@property (nonatomic) float thetaSpin;
@property (nonatomic) float thetaUser;
@property (nonatomic) float colorAngle;
@property (nonatomic) float lifeRate;
@property (nonatomic, strong) NSString * scoreString;

// Spinner action
@property (nonatomic, strong) SpinnerAction * spinnerAction;

// Labels
@property (nonatomic, strong) UILabel * scoreLabel;
@property (nonatomic, strong) UILabel * comboLabel;
@property (nonatomic, strong) UILabel * countDownLabel;

// Sprites & lives
@property (nonatomic, strong) SKSpriteNode * spinnerSprite;
@property (nonatomic, strong) CircleLives  * lives;
@property (nonatomic, strong) PUHeader     * PUHeaderView;

// Timers
@property (nonatomic, strong) KKProgressTimer * comboTimer;
@property (nonatomic, strong) KKProgressTimer * immunityTimer;


// Others
@property (nonatomic, strong) ViewController * sceneViewController;
@property (nonatomic, strong) SKShapeNode    * accuracyView;

- (void) resetHeaderLabels;


@end
