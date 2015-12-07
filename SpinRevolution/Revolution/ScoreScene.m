//
//  ScoreScene.m
//  Revolution
//
//  Created by Martí Serra Vivancos on 08/02/14.
//  Copyright (c) 2014 Tomorrow. All rights reserved.
//

#import "ScoreScene.h"
#import "MyScene.h"


@implementation ScoreScene

@synthesize PUHeaderView, mainUI, powerMenu, pointsMenu, totalPoints;

float SCREEN_WIDHT;
float SCREEN_HEIGHT;

int powerUPprice = 1000;
int buyQuantity;


////INIT///

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        SCREEN_HEIGHT = self.frame.size.height;
        SCREEN_WIDHT = self.frame.size.width;
        
    }
    return self;
}

- (void) didMoveToView:(SKView *)view
{
    // Background
    self.backgroundColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1.0];
    
    mainUI = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDHT, SCREEN_HEIGHT)];
    mainUI.clipsToBounds = NO;
    [self.view addSubview:mainUI];
    
    PUHeaderView = [[PUHeader alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDHT, SCREEN_HEIGHT*0.2)];
    PUHeaderView.delegate = self;
    [self.view addSubview:PUHeaderView];    
    
    // Score label
    
    UILabel *scoreTitleLabel = [[UILabel alloc]init];
    scoreTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:[self getPT:0.12]];
    scoreTitleLabel.text = @"Your score";
    scoreTitleLabel.textColor = [SKColor lightGrayColor];
    [scoreTitleLabel sizeToFit];
    scoreTitleLabel.center = CGPointMake(SCREEN_WIDHT*0.5, SCREEN_HEIGHT*0.27);
    [mainUI addSubview:scoreTitleLabel];
    
    UILabel *finalScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    finalScoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:[self getPT:0.15]];
    finalScoreLabel.text = @"340";
    finalScoreLabel.textColor = [SKColor redColor];
    [finalScoreLabel sizeToFit];
    finalScoreLabel.center = CGPointMake(SCREEN_WIDHT*0.5, SCREEN_HEIGHT*0.37);
    mainUI.alpha = 0;
    [mainUI addSubview:finalScoreLabel];
    
    // Share and replay buttons
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"shareButton.png"] forState:UIControlStateNormal];
    [shareButton addTarget:self
                     action:@selector(shareScoreTouched)
           forControlEvents:UIControlEventTouchDown];
    shareButton.frame = CGRectMake(0, 0, SCREEN_WIDHT*0.2, SCREEN_WIDHT*0.2);
    shareButton.center = CGPointMake(SCREEN_WIDHT*0.3, SCREEN_HEIGHT*0.5);
    [mainUI addSubview:shareButton];
    
    UIButton *replayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [replayButton setImage:[UIImage imageNamed:@"replayButton.png"] forState:UIControlStateNormal];
    [replayButton addTarget:self
                    action:@selector(replayGameTouched)
          forControlEvents:UIControlEventTouchDown];
    replayButton.frame = CGRectMake(0, 0, SCREEN_WIDHT*0.2, SCREEN_WIDHT*0.2);
    replayButton.center = CGPointMake(SCREEN_WIDHT*0.7, SCREEN_HEIGHT*0.5);
    [mainUI addSubview:replayButton];
    
    totalPoints = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    totalPoints.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:[self getPT:0.07]];
    totalPoints.text = [ NSString stringWithFormat:@"Total points: %li",(long)[[[NSUserDefaults standardUserDefaults] valueForKey:@"totalPoints"] integerValue]];
    totalPoints.textColor = [SKColor blackColor];
    [totalPoints sizeToFit];
    totalPoints.center = CGPointMake(SCREEN_WIDHT*0.45, SCREEN_HEIGHT*0.7);
    [mainUI addSubview:totalPoints];
    
    UIButton *buyPoints = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyPoints setImage:[UIImage imageNamed:@"addPU.png"] forState:UIControlStateNormal];
    [buyPoints addTarget:self
                action:@selector(openPointsMenu)
      forControlEvents:UIControlEventTouchUpInside];
    buyPoints.frame = CGRectMake(0, 0, self.frame.size.width*0.12, self.frame.size.width*0.12);
    buyPoints.center = CGPointMake(totalPoints.center.x + totalPoints.frame.size.width/1.5, totalPoints.center.y);
    [mainUI addSubview:buyPoints];
    
    [UIView animateWithDuration:0.7
                     animations:^{
                         
                         mainUI.alpha = 1;
                         
                     }
                     completion:Nil
                     ];
    
    // Create menus
    [self createPowerMenu];
    [self createPointsMenu];
    
}

// Powerups buying menu
- (void) createPowerMenu
{
    powerMenu = [[PowerUPMenu alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDHT*0.9, SCREEN_WIDHT*0.9)];
    powerMenu.center = CGPointMake(SCREEN_WIDHT/2, SCREEN_HEIGHT*0.5);
    powerMenu.delegate = self;
    [mainUI addSubview:powerMenu];
}

- (void) closePowerMenu
{
    [powerMenu closePowerMenu];
}

- (void) lifePUTouched
{
    if (pointsMenu.hidden == YES)  [powerMenu openPowerMenu: 1];
}

- (void) speedPUTouched
{
     if (pointsMenu.hidden == YES) [powerMenu openPowerMenu:2];

}

- (void) comboPUTouched
{
    if (pointsMenu.hidden == YES) [powerMenu openPowerMenu:3];
}

- (void) finishedBuyingPU
{
    [PUHeaderView resetLabelValue];
    totalPoints.text = [ NSString stringWithFormat:@"Total points: %li",(long)[[[NSUserDefaults standardUserDefaults] valueForKey:@"totalPoints"] integerValue]];
    [totalPoints sizeToFit];
    totalPoints.center = CGPointMake(SCREEN_WIDHT*0.5, SCREEN_HEIGHT*0.7);

}

// Points shop menu
- (void) createPointsMenu
{
    pointsMenu = [[PointsMenu alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDHT*0.9, SCREEN_WIDHT*0.9)];
    pointsMenu.center = CGPointMake(SCREEN_WIDHT/2, SCREEN_HEIGHT*0.5);
    [mainUI addSubview:pointsMenu];
}

- (void) openPointsMenu
{
     if (powerMenu.hidden == YES) [pointsMenu openPointsMenu];
}

- (void) closePointsMenu
{
    [pointsMenu closePointsMenu];
}


// Main buttons
- (void) shareScoreTouched{
    [self openPointsMenu];
}

- (void) replayGameTouched{
    SKScene * scene = [MyScene sceneWithSize:self.view.bounds.size];
    SKTransition *reveal = [SKTransition fadeWithColor:[UIColor whiteColor] duration:1.0f];

    [self.view presentScene:scene transition: reveal];

    [UIView animateWithDuration:0.7
        animations:^{
                        
            mainUI.alpha = 0;

    }
        completion:^(BOOL finished){
                    
            [mainUI removeFromSuperview];
                         
    }];
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


// Others

- (int) getPT:(float)size
{
    return SCREEN_WIDHT * size;
}


// Unload
- (void) willMoveFromView:(SKView *)view
{

  
}


@end
