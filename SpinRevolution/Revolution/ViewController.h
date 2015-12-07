//
//  ViewController.h
//  Revolution
//

//  Copyright (c) 2014 Tomorrow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "Mixpanel.h"
#import "Game.h"
#import <GameKit/GameKit.h>
#import "TutorialVC.h"

@class Game;

@interface ViewController : UIViewController <MixpanelDelegate, TutorialDelegate>;

@property (nonatomic, retain)  SKView  * sceneView;
@property (nonatomic, retain) Mixpanel * mixpanel;
@property (nonatomic, strong) Game *joc;

- (void) moveToScore:(int)score :(int)life :(int)speed :(int) combo;

@end
