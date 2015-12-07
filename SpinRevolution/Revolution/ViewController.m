//
//  ViewController.m
//  Revolution
//
//  Created by Martí Serra Vivancos on 08/02/14.
//  Copyright (c) 2014 Tomorrow. All rights reserved.
//

#import "ViewController.h"

#import "ScoreVC.h"

@implementation ViewController

@synthesize sceneView, mixpanel;

- (void)viewDidLoad
{
    mixpanel = [Mixpanel sharedInstance];
    [super viewDidLoad];
    mixpanel.showSurveyOnActive = NO;

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    sceneView = (SKView *)self.view;
    sceneView.backgroundColor = [UIColor whiteColor];
    
    _joc = [[Game alloc] initWithSize:sceneView.bounds.size];
    _joc.scaleMode = SKSceneScaleModeAspectFill;
    
    _joc.sceneViewController = self;
    [sceneView presentScene:_joc];
    
    // Show tutorial
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"firstLoadDone"] boolValue] != YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLoadDone"];
        TutorialVC* tuto = [[TutorialVC alloc]init];
        tuto.delegate = self;
        [self presentViewController:tuto animated:YES completion:nil];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    // Mixpanel
    NSDictionary * mixpanelSet = @{
      @"extraPU"        : [NSString stringWithFormat:@"%li",(long)[[[NSUserDefaults standardUserDefaults] valueForKey:@"extraPU"] integerValue]],
      @"immuPU"         : [NSString stringWithFormat:@"%li",(long)[[[NSUserDefaults standardUserDefaults] valueForKey:@"immuPU"] integerValue]],
      @"comboPU"        : [NSString stringWithFormat:@"%li",(long)[[[NSUserDefaults standardUserDefaults] valueForKey:@"comboPU"] integerValue]],
      @"walletPoints"   : [NSString stringWithFormat:@"%li",(long)[[[NSUserDefaults standardUserDefaults] valueForKey:@"walletPoints"] integerValue]],
      @"everBought"     : [NSString stringWithFormat:@"%li",(long)[[[NSUserDefaults standardUserDefaults] valueForKey:@"everBought"] integerValue]],
      @"bestScore"      : [NSString stringWithFormat:@"%li",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:@"bestScore"] intValue]],
      @"answeredSurvey" : [NSString stringWithFormat:@"%li",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:@"answeredSurvey"] intValue]],
      @"gamesPlayed"    : [NSString stringWithFormat:@"%li",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:@"gamesPlayed"] intValue]],
      @"initialDifficulty"  : [NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults] floatForKey:@"initialDifficulty"]],
      @"difficultyIncrease" : [NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults] floatForKey:@"difficultyIncrease"]],
      @"shiftTime"          : [NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults] floatForKey:@"shiftTime"]],
      @"errorMargin"        : [NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults] floatForKey:@"errorMargin"]],
    };
    
    [mixpanel.people set:mixpanelSet];
    
    
    [_joc resetHeaderLabels];
}

- (void) moveToScore:(int)score :(int)life :(int)speed :(int) combo;
{
    // Add last score to walletPoints
    [[NSUserDefaults standardUserDefaults] setInteger:[[[NSUserDefaults standardUserDefaults] valueForKey:@"walletPoints"] integerValue]+score forKey:@"walletPoints"];
    [[NSUserDefaults standardUserDefaults] setInteger:[[[NSUserDefaults standardUserDefaults] valueForKey:@"gamesPlayed"] integerValue]+1 forKey:@"gamesPlayed"];
    
    // Track info to Mixpanel
    [mixpanel track:@"Game" properties:@{
                @"finalPoints" : [NSString stringWithFormat:@"%i",score],
                @"extraPU"     : [NSString stringWithFormat:@"%i",life],
                @"immuPU"      : [NSString stringWithFormat:@"%i",speed],
                @"comboPU"     : [NSString stringWithFormat:@"%i",combo],
                @"initialDifficulty"  : [NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults] floatForKey:@"initialDifficulty"]],
                @"difficultyIncrease" : [NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults] floatForKey:@"difficultyIncrease"]],
                @"shiftTime"          : [NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults] floatForKey:@"shiftTime"]],
                @"errorMargin"        : [NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults] floatForKey:@"errorMargin"]]
    }];
    
    // Open scroreScene
    ScoreVC* scorevc = [[ScoreVC alloc] init];
    scorevc.finalScore = score;
    [self.navigationController pushViewController:scorevc animated:YES];
    
    [self reportScore:score forLeaderboardID:@"scoredGame"];
    [self reportPointAchievement:score];
    [self reportGamesAchievement];
    
}

// View did disapear
- (void) viewDidDisappear:(BOOL)animated
{
    
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove)
    {
        [v removeFromSuperview];
    }
    
    [sceneView removeFromSuperview];
    
    sceneView = (SKView *)self.view;
    sceneView.backgroundColor = [UIColor whiteColor];
    
    _joc = [[Game alloc] initWithSize:sceneView.bounds.size];
    _joc.scaleMode = SKSceneScaleModeAspectFill;
    
    _joc.sceneViewController = self;
    [sceneView presentScene:_joc];
    
    // Mixpanel
    NSDictionary * mixpanelSet = @{
                                   @"extraPU" : [NSString stringWithFormat:@"%li",(long)[[[NSUserDefaults standardUserDefaults] valueForKey:@"extraPU"] integerValue]],
                                   @"immuPU"  : [NSString stringWithFormat:@"%li",(long)[[[NSUserDefaults standardUserDefaults] valueForKey:@"immuPU"] integerValue]],
                                   @"comboPU" : [NSString stringWithFormat:@"%li",(long)[[[NSUserDefaults standardUserDefaults] valueForKey:@"comboPU"] integerValue]],
                                   };
    [mixpanel.people set:mixpanelSet];
}

// Game center
- (void) reportScore: (int64_t) score forLeaderboardID: (NSString*) identifier
{
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: identifier];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    NSArray *scores = @[scoreReporter];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        
    }];
}
- (void) reportGamesAchievement
{
    int games = [[[NSUserDefaults standardUserDefaults] valueForKey:@"gamesPlayed"] integerValue];
    
    if (games==5) {
        [self reportFinishedAchievement:@"5games"];;
    }
    if (games==10) {
        [self reportFinishedAchievement:@"10games"];;
    }
    if (games==50) {
        [self reportFinishedAchievement:@"50games"];;
    }
    if (games==100) {
        [self reportFinishedAchievement:@"100games"];;
    }
    if (games==500) {
        [self reportFinishedAchievement:@"500games"];;
    }
    if (games==1000) {
        [self reportFinishedAchievement:@"1000games"];;
    }
}


- (void) reportPointAchievement: (int) score
{
    if (score>=100) {
        [self reportFinishedAchievement: @"100points"];
    }
        
    if (score>=300) {
        [self reportFinishedAchievement:@"300points"];
    }
    if (score>=500) {
        [self reportFinishedAchievement:@"500points"];
    }
    if (score>=1000) {
        [self reportFinishedAchievement:@"1000points"];
    }
    if (score>=2000) {
        [self reportFinishedAchievement:@"2000points"];
    }
    if (score>=3000) {
        [self reportFinishedAchievement:@"3000points"];
    }
    if (score>=5000) {
        [self reportFinishedAchievement:@"5000points"];

    }
    if (score>=10000) {
        [self reportFinishedAchievement:@"10000points"];
    }      
}

- (void) reportFinishedAchievement: (NSString*) identifier{
    
    GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier: identifier];
    achievement.showsCompletionBanner = YES;
    if (achievement)
    {
        achievement.percentComplete = 100;
        [achievement reportAchievementWithCompletionHandler:^(NSError *error)
         {
             if (error != nil)
             {
                 NSLog(@"Error in reporting achievements: %@", error);
             }
         }];
    }
}

// Tutorial
- (void) finishedReadingTutorial
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
