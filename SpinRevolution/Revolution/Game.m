//
//  MyScene.m
//  Revolution
//
//  Created by Martí Serra Vivancos on 08/02/14.
//  Copyright (c) 2014 Tomorrow. All rights reserved.
//

#import "Game.h"
#import "Innapp.h"
#import "Reachability.h"

@implementation Game

@synthesize actualScore, generalTime, gameTime, colorTime, shiftTime, comboTime;
@synthesize immunityUsed, comboUsed, lifeUsed;
@synthesize isTouching, firstTouch, shouldSpin, shouldDecreaseLife, shouldChangeMode;
@synthesize currentStatus, thetaSpin, thetaUser, colorAngle, scoreString;
@synthesize spinnerAction;

@synthesize spinnerSprite, PUHeaderView, lives, countDownLabel, scoreLabel, comboLabel, sceneViewController, accuracyView;
@synthesize comboTimer, immunityTimer;

float SCREEN_WIDHT;
float SCREEN_HEIGHT;
float FPS;

float currentSpinnerAngle;

float red   = 0;
float green = 0;

int countDown;

int combo = 1;
int comboMultipier;

int color;
int currentLives;

float shiftTimeMax;
float colorMargin;

bool comboPUused = false;

#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE

// Init
- (id) initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        SCREEN_HEIGHT = self.frame.size.height;
        SCREEN_WIDHT  = self.frame.size.width;
        FPS           = 30;
        
        actualScore    = 0;
        comboMultipier = 1;
        
        immunityUsed = 0;
        comboUsed    = 0;
        lifeUsed     = 0;
        
        color        = 0;
        currentLives = 5;
        
        generalTime  = 0;
        gameTime     = 0;
        colorTime    = 0;
        shiftTime    = 0;
        shiftTimeMax = [[NSUserDefaults standardUserDefaults] floatForKey:@"shiftTime"];
        colorMargin  = [[NSUserDefaults standardUserDefaults] floatForKey:@"errorMargin"];
        
        isTouching         = false;
        firstTouch         = false;
        shouldSpin         = false;
        shouldDecreaseLife = false;
        shouldChangeMode   = true;
        
        spinnerAction = [[SpinnerAction alloc]  init];
        
        // Spinner
        spinnerSprite = [[SKSpriteNode alloc] initWithImageNamed:@"spinner.png"];
        spinnerSprite.size      = CGSizeMake(SCREEN_WIDHT * 0.8, SCREEN_WIDHT * 0.8);
        spinnerSprite.position  = CGPointMake(SCREEN_WIDHT * 0.5, SCREEN_HEIGHT - 340);
        spinnerSprite.zRotation = 0;
        [self addChild:spinnerSprite];
  
    }
    return self;
}

- (void) didMoveToView:(SKView *)view
{
    
    // Background
    self.backgroundColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1.0];
    
    // Header
    PUHeaderView = [[PUHeader alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDHT, SCREEN_WIDHT/5)];
    PUHeaderView.delegate = self;
    [PUHeaderView load];
    [self.view addSubview:PUHeaderView];
       
    // Score label
    scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDHT * 0.5, 200, 0, 0)];
    scoreLabel.text          = @"0";
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.textColor     = [SKColor grayColor];
    scoreLabel.font          = [UIFont fontWithName:@"HelveticaNeue-Light" size:[self getPT:0.2]];
    [scoreLabel sizeToFit];
    scoreLabel.center = CGPointMake(SCREEN_WIDHT * 0.5, 100);
    [self.view addSubview:scoreLabel];
    
    // Combo label
    comboLabel = [[UILabel alloc] initWithFrame:CGRectMake(450, 47, 100, 100)];
    comboLabel.text      = @"x2";
    comboLabel.textColor = [SKColor blueColor];
    comboLabel.font      = [UIFont fontWithName:@"HelveticaNEue-Light" size:[self getPT:0.12]];
    comboLabel.alpha     = 0;
    [self.view addSubview:comboLabel];

    // Lives
    lives = [[CircleLives alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDHT * 0.85, SCREEN_WIDHT / 6)];
    lives.center = CGPointMake(SCREEN_WIDHT * 0.5, 170);
    [self.view addSubview:lives];
    
    // Countdown
    countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDHT * 0.5, SCREEN_HEIGHT * 0.4, SCREEN_WIDHT, 120)];
    countDownLabel.text          = NSLocalizedString(@"TOUCH", @"Touch");
    countDownLabel.textAlignment = NSTextAlignmentCenter;
    countDownLabel.textColor     = [SKColor whiteColor];
    countDownLabel.font   = [UIFont fontWithName:@"HelveticaNeue-Light" size:[self getPT:0.2]];
    [countDownLabel sizeToFit];
    countDownLabel.center = CGPointMake(SCREEN_WIDHT * 0.5, 340);
   
    [self.view addSubview:countDownLabel];
    
    if (isiPhone5)
    {
        spinnerSprite.position  = CGPointMake(SCREEN_WIDHT * 0.5, SCREEN_HEIGHT-380);
        countDownLabel.center = CGPointMake(SCREEN_WIDHT * 0.5, 380);
    }
    
    // Timers
    comboTimer    = [[KKProgressTimer alloc] initWithFrame:CGRectMake(0, 0, 0.14 * SCREEN_WIDHT, 0.14 * SCREEN_WIDHT)];
    immunityTimer = [[KKProgressTimer alloc] initWithFrame:CGRectMake(0, 0, 0.14 * SCREEN_WIDHT, 0.14 * SCREEN_WIDHT)];
    comboTimer.center    = CGPointMake(0.22 * SCREEN_WIDHT, 0.1 * SCREEN_WIDHT);
    immunityTimer.center = CGPointMake(0.89 * SCREEN_WIDHT, 0.1 * SCREEN_WIDHT);
    
    [PUHeaderView addSubview:comboTimer];
    [PUHeaderView addSubview:immunityTimer];
    [PUHeaderView sendSubviewToBack:comboTimer];
    [PUHeaderView sendSubviewToBack:immunityTimer];
    
    self.comboTimer.delegate    = self;
    self.immunityTimer.delegate = self;

}

// Powerup buttons
- (void) PUtouched:(int)type
{
    if (type == 1 && [self powerUpRecordWithName:@"extraPU"] != 0 &&
        currentLives < 5)
    {
        [self usedPowerUpWithName:@"extraPU"];
            
        lifeUsed++;
        currentLives++;
        [lives addLife];
    }
    else if (type == 2 && [self powerUpRecordWithName:@"immuPU"] != 0 &&
             shouldDecreaseLife == true)
    {
        [PUHeaderView bringSubviewToFront:immunityTimer];
        __block CGFloat immunityTimerFloat;
        [immunityTimer startWithBlock:^CGFloat
        {
            return immunityTimerFloat++ / (5 * FPS);
        }];
        
        [self usedPowerUpWithName:@"immuPU"];
        
        shouldDecreaseLife = false;
        
        SKAction * immunity = [SKAction waitForDuration:5];
        [self runAction:immunity completion:^
        {
            [PUHeaderView sendSubviewToBack:immunityTimer];
            shouldDecreaseLife = true;
        }];
        
        immunityUsed++;
    }
    else if (type == 3 && [self powerUpRecordWithName:@"comboPU"] != 0 &&
             comboMultipier == 1 && shouldDecreaseLife == true)
    {
        [PUHeaderView bringSubviewToFront:comboTimer];
        __block CGFloat comboTimerFloat;
        [comboTimer startWithBlock:^CGFloat
        {
            return comboTimerFloat++ / (5 * FPS);
        }];
        
        [self usedPowerUpWithName:@"comboPU"];
        
        comboMultipier = 5;
        comboPUused = false;
        
        SKAction * comboWait = [SKAction waitForDuration:5];
        [self runAction:comboWait completion:^
        {
            [PUHeaderView sendSubviewToBack:comboTimer];
            comboMultipier = 1;
        }];
    }
}

- (void) usedPowerUpWithName:(NSString *)PUName
{
    int currentPUAmount = [self powerUpRecordWithName:PUName];
    currentPUAmount--;
    
    [[NSUserDefaults standardUserDefaults] setInteger:currentPUAmount forKey:PUName];
    
    [PUHeaderView resetLabelValue];
}

- (int) powerUpRecordWithName:(NSString *)PUName
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:PUName] intValue];
}

// Update
-(void) update:(CFTimeInterval)currentTime
{
    if (shouldSpin)
    {
        FPS = FPS == 60 ? 1 / (currentTime - generalTime) : FPS;
        float dt = (currentTime - generalTime) > 1 ? 0 : (currentTime - generalTime);
        
        if (shouldChangeMode)
        {
            if (color == 0)
            {
                color      = [lives nextColor];
                colorAngle = [self colorAngleFromColor:color];
            }
            
           [spinnerSprite runAction:[spinnerAction actionWithNode:spinnerSprite]];
            shouldChangeMode = false;
        }
        else if (colorTime >= [spinnerAction functionChangeTime])
        {
            shouldChangeMode = true;
            colorTime = 0;
        }
        
        thetaSpin = spinnerSprite.zRotation;
        thetaSpin = fmodf(thetaSpin, 2 * M_PI);
        thetaSpin = thetaSpin < 0 ? 2 * M_PI + thetaSpin : thetaSpin;
        
        if (isTouching)
        {
            if (colorMargin > (fabs(thetaUser - fmodf(thetaSpin + colorAngle, 2 * M_PI))) ||
                colorMargin > (fabs(thetaUser + fmodf(thetaSpin + colorAngle, 2 * M_PI) - 2 * M_PI)))
            {
                // Combo
                comboTime += (currentTime - generalTime) > 1 ? 0 : (currentTime - generalTime);
                
                if (comboTime > 12 && combo == 6)
                {
                    [self playAudioCombo:@"4"];
                    NSLog(@"COMBO 8");
                    combo = 8;
                    comboLabel.text      = @"x8";
                    comboLabel.textColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:1];
                }
                else if (comboTime > 8 && combo == 4)
                {
                    [self playAudioCombo:@"3"];
                    NSLog(@"COMBO 6");
                    combo = 6;
                    comboLabel.text      = @"x6";
                    comboLabel.textColor = [UIColor colorWithRed:0.12 green:0.88 blue:0.12 alpha:1];
                }
                else if (comboTime > 5 && combo == 2)
                {
                    [self playAudioCombo:@"2"];
                    NSLog(@"COMBO 4");
                    combo = 4;
                    comboLabel.text      = @"x4";
                    comboLabel.textColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
                }
                else if (comboTime > 2 && combo == 1)
                {
                    [self playAudioCombo:@"1"];
                    NSLog(@"COMBO 2");
                    combo = 2;
                    comboLabel.text      = @"x2";
                    comboLabel.textColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
            
                    // Combo label appear animation
                    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn
                                     animations:^
                                     {
                                         comboLabel.frame = CGRectMake(260, comboLabel.frame.origin.y, comboLabel.frame.size.width, comboLabel.frame.size.height);
                                         comboLabel.alpha = 1;
                                     }
                                     completion:nil];
                   
                }
                else if (combo == 0)
                {
                    combo = 1;
                }
                
                // Multiply combo
                if (comboMultipier == 5 && !comboPUused)
                {
                    combo *= comboMultipier;
                    comboPUused = true;
                }
            }
            else
            {
                [self notFollowingSpinner:dt];
            }
        }
        else
        {
            [self notFollowingSpinner:dt];
        }
        
        actualScore += combo*0.5;
            
        [scoreLabel setText:[NSString stringWithFormat:@"%.f", actualScore]];
        [scoreLabel sizeToFit];
        scoreLabel.center = CGPointMake(SCREEN_WIDHT * 0.5, 100);
        
        colorTime   += dt;
        gameTime    += dt;
        generalTime += (currentTime - generalTime);
    }
}

// Play audio
- (void) playAudioCombo: (NSString *)number
{
    NSString *path  = [[NSBundle mainBundle] pathForResource:number ofType:@"wav"];
    NSURL *pathURL = [NSURL fileURLWithPath : path];
    SystemSoundID audioEffect;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
    AudioServicesPlaySystemSound(audioEffect);
}
    
- (void) notFollowingSpinner:(float)dt
{
    if (shouldDecreaseLife) shiftTime += (dt > 1 ? 0 : dt);
    // Combo label disappear animation
    if (combo != 0)
    {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^
                                    {
                                        comboLabel.frame = CGRectMake(320, comboLabel.frame.origin.y, comboLabel.frame.size.width, comboLabel.frame.size.height);
                                        comboLabel.alpha = 0;
                                    }
                                    completion:nil];
    }
    
    // Stop combo
    comboTime = 0;
    combo     = 0;
    
    if (shiftTime >= shiftTimeMax)
    {
        currentLives--;
        
        shiftTime = 0;
        
        [lives nextLife];
        
        color      = [lives nextColor];
        colorAngle = [self colorAngleFromColor:color];
        
        if (currentLives == 0)
        {
            // Die
            shouldSpin = false;
            [spinnerSprite removeAllActions];

            [sceneViewController moveToScore:actualScore:lifeUsed:immunityUsed:comboUsed];
            return;
        }
    }
}

- (float) colorAngleFromColor:(int)colorInt
{
    float radians = 0;
    switch (colorInt)
    {
        case 2: radians = 0; break;
        case 4: radians = M_PI * 0.3333 * 1; break;
        case 6: radians = M_PI * 0.3333 * 2; break;
        case 3: radians = M_PI * 0.3333 * 3; break;
        case 1: radians = M_PI * 0.3333 * 4; break;
        case 5: radians = M_PI * 0.3333 * 5; break;
        default: break;
    }
    
    return radians /*- M_PI * 0.1667*/;
}

// Countdow text
- (void) startCountdown
{
    countDown = 1;
    
    SKAction * wait = [SKAction waitForDuration:0.7];
    [self runAction:[self changeCountDownText]];
    [self runAction:wait completion:^
     {
         [self runAction:[self changeCountDownText]];
         [self runAction:wait completion:^
          {
              [self runAction:[self changeCountDownText]];
              [self runAction:wait completion:^
               {
                   [self runAction:[self changeCountDownText]];
                   [self runAction:wait completion:^
                    {
                        [self runAction:[self changeCountDownText]];
                    }];
               }];
          }];
     }];
    
    firstTouch = true;

}
- (SKAction *) changeCountDownText
{
    countDownLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:[self getPT:0.3]];
    
    if (countDown < 4)
    {
        countDownLabel.text = [NSString stringWithFormat:@"%i", 4 - countDown];
        countDown++;
    }
    else if (countDown == 4)
    {
        countDownLabel.text = [NSString stringWithFormat:NSLocalizedString(@"GO", @"Go")];
        countDown++;
    }
    else if (countDown == 5)
    {
        shouldSpin = true;
        shouldDecreaseLife =  true;
        
        [countDownLabel removeFromSuperview];
    }
    [countDownLabel sizeToFit];
    countDownLabel.center = CGPointMake(SCREEN_WIDHT * 0.5, 340);
    if (isiPhone5) countDownLabel.center = CGPointMake(SCREEN_WIDHT * 0.5, 380);
    SKAction * voidAction = [SKAction waitForDuration:0];
    return voidAction;
}

- (void) tutorialFinished
{
    countDownLabel.alpha = 1;
    [self startCountdown];
}


// Others
- (int) getPT:(float)size
{
    return SCREEN_WIDHT * size;
}

- (float) angleFromTouch:(UITouch *)touch
{
    CGPoint location = [touch locationInNode:self];
    
    float directorX = location.x - spinnerSprite.position.x;
    float directorY = location.y - spinnerSprite.position.y;
    
    float angle = acosf(directorX / sqrtf(powf(directorX, 2) + powf(directorY, 2)));
    angle = directorY < 0 ? 2 * M_PI - angle : angle;
    
    return angle;
}

- (void) resetHeaderLabels
{
    [PUHeaderView resetLabelValue];
}


// Touches
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (firstTouch)
    {
        isTouching = true;
    
        for (UITouch *touch in touches)
        {
            thetaUser = [self angleFromTouch:touch];
        }
    }
    else
    {
        [self startCountdown];
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    firstTouch = true;
    isTouching = true;
    
    for (UITouch *touch in touches)
    {
        thetaUser = [self angleFromTouch:touch];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    isTouching = false;
}


@end
