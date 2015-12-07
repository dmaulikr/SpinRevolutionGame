//
//  CircleLives.m
//  Revolution
//
//  Created by Ramon Fernández Mir on 20/03/14.
//  Copyright (c) 2014 Tomorrow. All rights reserved.
//

#import "CircleLives.h"
#import <AudioToolbox/AudioToolbox.h>

#define REL_WIDTH 1

@implementation CircleLives

@synthesize life1, life2, life3, life4, life5;
@synthesize livesArray, colorsArray;

int currentLife;
int livesAdded;
int totalLives;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        currentLife = 1;
        livesAdded  = 0;
        totalLives  = 5;
        
        // Lives views
        CGPoint life1Position = CGPointMake(frame.size.width * 0.1, frame.size.height * 0.5);
        CGPoint life2Position = CGPointMake(frame.size.width * 0.3, frame.size.height * 0.5);
        CGPoint life3Position = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
        CGPoint life4Position = CGPointMake(frame.size.width * 0.7, frame.size.height * 0.5);
        CGPoint life5Position = CGPointMake(frame.size.width * 0.9, frame.size.height * 0.5);
        
        life1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height * REL_WIDTH, frame.size.height * REL_WIDTH)];
        life2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height * REL_WIDTH, frame.size.height * REL_WIDTH)];
        life3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height * REL_WIDTH, frame.size.height * REL_WIDTH)];
        life4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height * REL_WIDTH, frame.size.height * REL_WIDTH)];
        life5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height * REL_WIDTH, frame.size.height * REL_WIDTH)];
        
        life1.center = life1Position;
        life2.center = life2Position;
        life3.center = life3Position;
        life4.center = life4Position;
        life5.center = life5Position;
        
        life1.layer.cornerRadius = life1.frame.size.width / 2;
        life2.layer.cornerRadius = life2.frame.size.width / 2;
        life3.layer.cornerRadius = life3.frame.size.width / 2;
        life4.layer.cornerRadius = life4.frame.size.width / 2;
        life5.layer.cornerRadius = life5.frame.size.width / 2;
        
        // Colors
        colorsArray = [self randomColors];
        
        life1.backgroundColor = [[colorsArray objectAtIndex:0] objectAtIndex:1];
        life2.backgroundColor = [[colorsArray objectAtIndex:1] objectAtIndex:1];
        life3.backgroundColor = [[colorsArray objectAtIndex:2] objectAtIndex:1];
        life4.backgroundColor = [[colorsArray objectAtIndex:3] objectAtIndex:1];
        life5.backgroundColor = [[colorsArray objectAtIndex:4] objectAtIndex:1];
        
        life1.transform = CGAffineTransformMakeScale(1.0, 1.0);
        life2.transform = CGAffineTransformMakeScale(0.5, 0.5);
        life3.transform = CGAffineTransformMakeScale(0.5, 0.5);
        life4.transform = CGAffineTransformMakeScale(0.5, 0.5);
        life5.transform = CGAffineTransformMakeScale(0.5, 0.5);
        
        // Lives array
        livesArray = @[life1, life2, life3, life4, life5];
        
        [self addSubview:life1];
        [self addSubview:life2];
        [self addSubview:life3];
        [self addSubview:life4];
        [self addSubview:life5];
    }
    return self;
}

// Return array of colors
- (NSMutableArray *)randomColors
{
    NSArray * blue   = @[@0, [UIColor colorWithRed:0    green:0    blue:1    alpha:1]];
    NSArray * red    = @[@1, [UIColor colorWithRed:1    green:0    blue:0    alpha:1]];
    NSArray * green  = @[@2, [UIColor colorWithRed:0.12 green:0.88 blue:0.12 alpha:1]];
    NSArray * orange = @[@3, [UIColor colorWithRed:1    green:0.44 blue:0    alpha:1]];
    NSArray * purple = @[@4, [UIColor colorWithRed:1    green:0    blue:1    alpha:1]];
    NSArray * yellow = @[@5, [UIColor colorWithRed:1    green:1    blue:0    alpha:1]];
    
    NSMutableArray * colorsMutable = [[NSMutableArray alloc] initWithArray:@[blue, red, green, orange, purple, yellow]];
    
    for (int i = 0; i < 6; i++)
    {
        int remaining = 6 - i;
        int n = arc4random_uniform(remaining) + i;
        
        [colorsMutable exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    [colorsMutable removeLastObject];
    
    return colorsMutable;
}

- (int)nextColor
{
    // Call this function before than 'nextLife'
    return [[[colorsArray objectAtIndex:(currentLife - 1) % 5] objectAtIndex:0] intValue] + 1;
}

- (void)nextLife
{
    // Play audio
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"fail" ofType:@"wav"];
    NSURL *pathURL = [NSURL fileURLWithPath : path];
    SystemSoundID audioEffect;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
    AudioServicesPlaySystemSound(audioEffect);
    
    // call the following function when the sound is no longer used
    // (must be done AFTER the sound is done playing)
    //
    
    UIView * lostLife = [livesArray objectAtIndex:(currentLife - 1) % 5];
    if (currentLife != totalLives)
    {
        UIView * newLife  = [livesArray objectAtIndex:currentLife % 5];
        currentLife++;
        
        [UIView animateWithDuration:0.25 animations:^(void)
        {
            lostLife.transform = CGAffineTransformMakeScale(0.5, 0.5);
            lostLife.alpha = 0.3;
            
            newLife.transform = CGAffineTransformIdentity;
        }];
    }
    else
    {
        // You're goddamn dead wiggar
        [UIView animateWithDuration:0.25 animations:^(void)
        {
            lostLife.transform = CGAffineTransformMakeScale(0.5, 0.5);
            lostLife.alpha = 0.5;
        }];
    }
    
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)addLife
{
    totalLives++;
    
    UIView * ressurrectedLife = [livesArray objectAtIndex:livesAdded];
    livesAdded = (livesAdded + 1) % 5;
    
    [UIView animateWithDuration:0.25 animations:^(void)
    {
        ressurrectedLife.alpha = 1;
    }];
}


- (void) dealloc
{

}

@end
