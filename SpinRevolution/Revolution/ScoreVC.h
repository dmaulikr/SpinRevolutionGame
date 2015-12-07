//
//  ScoreVC.h
//  Revolution
//
//  Created by Martí Serra Vivancos on 09/03/14.
//  Copyright (c) 2014 Tomorrow. All rights reserved.
//

#import "ViewController.h"
#import "PowerUPMenu.h"
#import "PointsMenu.h"
#import "PUHeader.h"
#import "GADBannerView.h"
#import "TutorialVC.h"


@interface ScoreVC : UIViewController <PUButtonsDelegate, PUMenuDelegate, GKGameCenterControllerDelegate, UIAlertViewDelegate, GADBannerViewDelegate, IAMenuDelegate, TutorialDelegate>

// Labels and Text
@property (nonatomic, strong) UILabel *finalScoreLabel;
@property (nonatomic, strong) UILabel *walletPoints;

// Views
@property (nonatomic, strong) PowerUPMenu *powerMenu;
@property (nonatomic, strong) PointsMenu  *pointsMenu;
@property (nonatomic, strong) UIView      *mainUI;
@property (nonatomic, strong) PUHeader    *PUHeaderView;

@property (nonatomic, strong) UIButton *buyPoints;
@property (nonatomic, strong) Mixpanel *mixpanel;

@property (nonatomic) int finalScore;

@end
