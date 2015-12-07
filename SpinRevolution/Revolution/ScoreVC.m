//
//  ScoreVC.m
//  Revolution
//
//  Created by Martí Serra Vivancos on 09/03/14.
//  Copyright (c) 2014 Tomorrow. All rights reserved.
//

#import "ScoreVC.h"


@implementation ScoreVC

@synthesize PUHeaderView, mainUI, powerMenu, pointsMenu, walletPoints, finalScore, buyPoints, mixpanel;

float SCREEN_WIDHT;
float SCREEN_HEIGHT;

int powerUPprice = 1000;
int buyQuantity;

#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE

- (void)viewDidLoad
{    
    // Background
    self.view.backgroundColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1.0];
    
    mainUI = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDHT, SCREEN_HEIGHT)];
    mainUI.clipsToBounds = NO;
    [self.view addSubview:mainUI];
    
    // Header
    PUHeaderView = [[PUHeader alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDHT, SCREEN_WIDHT/4.3)];
    PUHeaderView.inBuyView = YES;
    PUHeaderView.delegate = self;
    [PUHeaderView load];
    [self.view addSubview:PUHeaderView];
    
    // Score label
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDHT*1.2, 110)];
    redView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    redView.clipsToBounds = NO;
    [mainUI addSubview:redView];
    
    UILabel *scoreTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 0, 0)];
    scoreTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:[self getPT:0.15]];
    
    // Best Score ?
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"bestScore"] == NULL ||
        [[[NSUserDefaults standardUserDefaults] objectForKey:@"bestScore"] intValue] <= finalScore)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:finalScore] forKey:@"bestScore"];
        
        // Label que fiqui "Best Score"
        scoreTitleLabel.text = NSLocalizedString(@"BEST_SCORE", @"Best score");
        
        NSDictionary * mixpanelSet = @{
            @"bestScore"      : [NSString stringWithFormat:@"%li",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:@"bestScore"] intValue]],
        };
        [mixpanel.people set:mixpanelSet];
        
    }
    else
    {
        scoreTitleLabel.text = NSLocalizedString(@"SCORE_SCENE_TITLE", @"Score scene title");
        
        UILabel *bestScore = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        bestScore.font = [UIFont fontWithName:@"HelveticaNeue" size:[self getPT:0.08]];
        bestScore.text = [ NSString stringWithFormat:NSLocalizedString(@"BEST_SCORE_SAVED", @"Best score saved"), [[[NSUserDefaults standardUserDefaults] objectForKey:@"bestScore"] intValue]];
        bestScore.textColor = [UIColor whiteColor];
        [bestScore sizeToFit];
        bestScore.frame = CGRectMake(SCREEN_WIDHT - 0.9*bestScore.frame.size.width, 75, bestScore.frame.size.width, bestScore.frame.size.height);
        [redView addSubview:bestScore];

    }
    
    scoreTitleLabel.textColor = [UIColor whiteColor];
    [scoreTitleLabel sizeToFit];
    [redView addSubview:scoreTitleLabel];
    
    UILabel *finalScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 40, 0, 0)];
    finalScoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:[self getPT:0.18]];
    finalScoreLabel.text = [ NSString stringWithFormat:@"%i", finalScore];
    finalScoreLabel.textColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:1];
    [finalScoreLabel sizeToFit];
    [redView addSubview:finalScoreLabel];
    
    // Need help?
    if (finalScore<250) {
        UIButton *needHelp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [needHelp addTarget:self
                     action:@selector(showTuto)
           forControlEvents:UIControlEventTouchUpInside];
        [needHelp setTitle:NSLocalizedString(@"HELP", @"Need help") forState:UIControlStateNormal];
        [needHelp setTitleColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1] forState: UIControlStateNormal];
        needHelp.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:[self getPT:0.08]];
        [mainUI addSubview:needHelp];
        [needHelp sizeToFit];
        needHelp.frame = CGRectMake(self.view.frame.size.width - needHelp.frame.size.width*1.05, redView.frame.origin.y + 199, needHelp.frame.size.width, needHelp.frame.size.height);
        needHelp.layer.anchorPoint = CGPointMake(0.5, 0.5);
        CGAffineTransform rotationTransform = CGAffineTransformIdentity;
        rotationTransform = CGAffineTransformRotate(rotationTransform, -0.1);
        needHelp.transform = rotationTransform;
        
    }
    
    // Rotation
    redView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    CGAffineTransform rotationTransform = CGAffineTransformIdentity;
    rotationTransform = CGAffineTransformRotate(rotationTransform, -0.1);
    redView.transform = rotationTransform;
    redView.center = CGPointMake(SCREEN_WIDHT/2, 160);
    
    // Share and replay buttons
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"shareButton.png"] forState:UIControlStateNormal];
    [shareButton addTarget:self
                    action:@selector(shareScoreTouched)
          forControlEvents:UIControlEventTouchUpInside];
    shareButton.frame = CGRectMake(0, 0, 70, 70);
    shareButton.center = CGPointMake(SCREEN_WIDHT*0.18, 295);
    [mainUI addSubview:shareButton];
    
    UIButton *replayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [replayButton setImage:[UIImage imageNamed:@"replayButton.png"] forState:UIControlStateNormal];
    [replayButton addTarget:self
                     action:@selector(replayGameTouched)
           forControlEvents:UIControlEventTouchUpInside];
    replayButton.frame = CGRectMake(0, 0, 90, 90);
    replayButton.center = CGPointMake(SCREEN_WIDHT*0.5, 295);
    [mainUI addSubview:replayButton];
    
    UIButton *gamecenterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [gamecenterButton setImage:[UIImage imageNamed:@"gameButton.png"] forState:UIControlStateNormal];
    [gamecenterButton addTarget:self
                     action:@selector(gamecenter)
           forControlEvents:UIControlEventTouchUpInside];
    gamecenterButton.frame = CGRectMake(0, 0, 70, 70);
    gamecenterButton.center = CGPointMake(SCREEN_WIDHT*0.82, 295);
    [mainUI addSubview:gamecenterButton];
    
    // Total points
    walletPoints = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    walletPoints.font = [UIFont fontWithName:@"HelveticaNeue" size:[self getPT:0.1]];
    walletPoints.textColor = [SKColor lightGrayColor];
    [self resetWalletPoints];
    [mainUI addSubview:walletPoints];
    
    buyPoints = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyPoints setImage:[UIImage imageNamed:@"buyPoints.png"] forState:UIControlStateNormal];
    [buyPoints addTarget:self
                  action:@selector(openPointsMenu)
        forControlEvents:UIControlEventTouchUpInside];
    buyPoints.frame = CGRectMake(0, 0, 50, 50);
    buyPoints.center = CGPointMake(walletPoints.center.x + walletPoints.frame.size.width/2 +  buyPoints.frame.size.width*0.75, walletPoints.center.y);
    [mainUI addSubview:buyPoints];
    
    
    GADBannerView* bannerView_ = [[GADBannerView alloc]
                                  initWithFrame:CGRectMake(0,self.view.frame.size.height-50,320,50)];
    
    bannerView_.adUnitID = @"ca-app-pub-3390829016396377/8036136048";
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    [bannerView_ loadRequest:[GADRequest request]];
    
    
    // Create menus
    [self createPowerMenu];
    [self createPointsMenu];
    
    // Mixpanel
    mixpanel = [Mixpanel sharedInstance];
    mixpanel.showSurveyOnActive = NO;
    
    if (isiPhone5) {
        
        shareButton.center = CGPointMake(SCREEN_WIDHT*0.18, 330);
        replayButton.center = CGPointMake(SCREEN_WIDHT*0.5, 330);
        gamecenterButton.center = CGPointMake(SCREEN_WIDHT*0.82, 330);        
    }
}


// Powerups buying menu
- (void) createPowerMenu
{
    powerMenu = [[PowerUPMenu alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDHT*0.9, SCREEN_WIDHT*0.9)];
    powerMenu.center = CGPointMake(SCREEN_WIDHT/2, SCREEN_HEIGHT*0.5);
    powerMenu.delegate = self;
    [self.view addSubview:powerMenu];
}


- (void) PUtouched: (int) type
{
    if (pointsMenu.hidden == YES)
    {
        [powerMenu openPowerMenu: type];
        if (type==1) [self fadeUI:0:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]];
        else if (type==2) [self fadeUI:0:[UIColor colorWithRed:0 green:0 blue:1 alpha:1]];
        else if (type==3) [self fadeUI:0:[UIColor colorWithRed:1 green:0.44 blue:0 alpha:1]];
    }
   
}
- (void) finishedReadingTutorial
{
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (void) closePowerMenu
{
    [powerMenu closePowerMenu];
    [self fadeUI:1:[UIColor whiteColor]];
}

- (void) finishedBuyingPU: (int)type :(int)quantity
{
    [PUHeaderView resetLabelValue];
    [self resetWalletPoints];
    
     // Mixpanel
    [mixpanel track:@"PUbought" properties:@{
            @"type": [NSString stringWithFormat:@"%i",type],
            @"quantity": [NSString stringWithFormat:@"%i",quantity],
    }];
}

// Tutorial
- (void) showTuto
{
    TutorialVC* tuto = [[TutorialVC alloc]init];
    tuto.delegate = self;
    [self presentViewController:tuto animated:YES completion:nil];

}

// IA shop menu
- (void) createPointsMenu
{
    pointsMenu = [[PointsMenu alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDHT*0.9, SCREEN_WIDHT*0.9)];
    pointsMenu.delegate = self;
    pointsMenu.center = CGPointMake(SCREEN_WIDHT/2, SCREEN_HEIGHT*0.5);
    if (isiPhone5) {
        powerMenu.center = CGPointMake(SCREEN_WIDHT/2, SCREEN_HEIGHT*0.5);
        pointsMenu.center = CGPointMake(SCREEN_WIDHT/2, SCREEN_HEIGHT*0.5);
    }
    [self.view addSubview:pointsMenu];
}

- (void) openPointsMenu
{
    if (powerMenu.hidden == YES) [pointsMenu openPointsMenu];
    [self fadeUI:0:[UIColor colorWithRed:1    green:1    blue:0    alpha:1]];
}

- (void) closePointsMenu
{
    [pointsMenu closePointsMenu];
    [self fadeUI:1:[UIColor whiteColor]];

}

- (void) finishedBuyingIA
{
    [self resetWalletPoints];
    [self closePointsMenu];
}

// Main UI animations
- (void) resetWalletPoints
{
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:NSLocalizedString(@"TOTAL_POINTS", @"Total points"),(long)[[[NSUserDefaults standardUserDefaults] valueForKey:@"walletPoints"] integerValue]]];
    [commentString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1 green:0 blue:0 alpha:1.0f] range:NSMakeRange(7, [commentString length]-7)];
    [commentString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:[self getPT:0.12]] range:NSMakeRange(7,[commentString length]-7)];
    [walletPoints setAttributedText:commentString];
    [walletPoints sizeToFit];
    
    walletPoints.center = CGPointMake(SCREEN_WIDHT*0.5-self.self.view.frame.size.width*0.09, 380);
    if (isiPhone5) walletPoints.center = CGPointMake(SCREEN_WIDHT*0.5-self.self.view.frame.size.width*0.09, 430);
    
    buyPoints.center = CGPointMake(walletPoints.center.x + walletPoints.frame.size.width/2 +  buyPoints.frame.size.width*0.75, walletPoints.center.y);
}

- (void) fadeUI:(float)toAlpha :(UIColor *) color
{
    [UIView animateWithDuration:0.3
        animations:^{
            mainUI.alpha = toAlpha;
            self.view.backgroundColor = color;
        
    } completion:nil];
}

// Main buttons
- (void) shareScoreTouched
{
    NSString* sharingText = [NSString stringWithFormat:NSLocalizedString(@"SHARE_MESSAGE", @"Share message"), finalScore];
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/spin-revolution-game/id802170884?ls=1&mt=8"];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:sharingText, url, nil] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[ UIActivityTypeCopyToPasteboard ,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void) replayGameTouched
{
     [self.navigationController popViewControllerAnimated:YES];
}

- (void) gamecenter
{
    [self showLeaderboard:@"scoredGame"];
}

// Touches
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInView:self.view];
        
        float distance = 0.0;
        distance = sqrtf(powf(location.x - powerMenu.center.x, 2)+powf(location.y - powerMenu.center.y, 2));
        
        if (distance > powerMenu.frame.size.width / 2 && powerMenu.hidden == NO)[self closePowerMenu];
        
        if (distance > pointsMenu.frame.size.width / 2 && pointsMenu.hidden == NO)[self closePointsMenu];
        
    }
}

// Game Center
- (void) showLeaderboard: (NSString*) leaderboardID
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gameCenterController.leaderboardIdentifier = leaderboardID;
        [self presentViewController: gameCenterController animated: YES completion:nil];
    }
}
- (void) gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:NULL];
}

// Survey alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex==1) {
        [self openPointsMenu];
    }

}
// Others
- (int) getPT:(float)size
{
    return SCREEN_WIDHT * size;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
