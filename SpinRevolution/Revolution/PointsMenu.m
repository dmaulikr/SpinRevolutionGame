//
//  self.m
//  Revolution
//
//  Created by Martí Serra Vivancos on 04/03/14.
//  Copyright (c) 2014 Tomorrow. All rights reserved.
//

#import "PointsMenu.h"

@implementation PointsMenu

@synthesize inapp, mixpanel, delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        mixpanel = [Mixpanel sharedInstance];
        mixpanel.showSurveyOnActive = NO;
        mixpanel.delegate = self;
        
        self.hidden = YES;
        
        // Create UI
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = frame.size.width/2;
        self.layer.masksToBounds = YES;
        
        // Text
        UITextView *pointsTitle = [[UITextView alloc]initWithFrame:CGRectMake(0,0, self.frame.size.width*0.5, self.frame.size.width*0.25)];
        pointsTitle.textAlignment = NSTextAlignmentCenter;
        pointsTitle.text = NSLocalizedString(@"POINTS_TITLE", @"Points title");
        pointsTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:[self getPT:0.09]];
        pointsTitle.center = CGPointMake(self.frame.size.width*0.5,self.frame.size.width*0.17);
        pointsTitle.backgroundColor = [UIColor clearColor];
        pointsTitle.editable = NO;
        pointsTitle.selectable = NO;
        [self addSubview:pointsTitle];
        
        UITextView *pointsInfo = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width*0.8, self.frame.size.width*0.27)];
        pointsInfo.textAlignment = NSTextAlignmentCenter;
        pointsInfo.text = NSLocalizedString(@"POINTS_INFO", @"Points info");
        pointsInfo.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:[self getPT:0.07]];
        pointsInfo.center = CGPointMake(self.frame.size.width*0.5,self.frame.size.width*0.3);
        pointsInfo.backgroundColor = [UIColor clearColor];
        pointsInfo.editable = NO;
        pointsInfo.selectable = NO;
        [self addSubview:pointsInfo];
        
        // Buttons
        UIButton *firstpack = [UIButton buttonWithType:UIButtonTypeCustom];
        [firstpack setImage:[UIImage imageNamed:@"25.png"] forState:UIControlStateNormal];
        [firstpack addTarget:self
                      action:@selector(buyFirstpack)
            forControlEvents:UIControlEventTouchUpInside];
        firstpack.frame = CGRectMake(0, 0,  self.frame.size.width*0.25, self.frame.size.width*0.25);
        firstpack.center = CGPointMake(104, 150);
        [self addSubview:firstpack];
        
        UIButton *secondpack = [UIButton buttonWithType:UIButtonTypeCustom];
        [secondpack setImage:[UIImage imageNamed:@"75.png"] forState:UIControlStateNormal];
        [secondpack addTarget:self
                       action:@selector(buySecondpack)
             forControlEvents:UIControlEventTouchUpInside];
        secondpack.frame = CGRectMake(0, 0, self.frame.size.width*0.25,  self.frame.size.width*0.25);
        secondpack.center = CGPointMake(184, 150);
        [self addSubview:secondpack];
        
        UIButton *thirdpack = [UIButton buttonWithType:UIButtonTypeCustom];
        [thirdpack setImage:[UIImage imageNamed:@"150.png"] forState:UIControlStateNormal];
        [thirdpack addTarget:self
                      action:@selector(buyThirdpack)
            forControlEvents:UIControlEventTouchUpInside];
        thirdpack.frame = CGRectMake(0, 0,  self.frame.size.width*0.25,  self.frame.size.width*0.25);
        thirdpack.center = CGPointMake(144, 230);
        [self addSubview:thirdpack];
    
              
        // Inapp
        inapp = [Innapp new];
    
    }
    return self;
}

// Open close
- (void) openPointsMenu{
    self.hidden = NO;
    self.alpha = 0;
    
    self.center = CGPointMake(-300, self.center.y);
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn
        animations:^{
            self.center = CGPointMake(190, self.center.y);
            self.alpha = 1;
    } completion:^(BOOL finished){
                         
            [UIView animateWithDuration:0.2
                animations:^{
                                              
                    self.center = CGPointMake(160, self.center.y);
                }completion:NULL];
            }];
}

- (void) closePointsMenu{

    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut
        animations:^{
            self.center = CGPointMake(self.center.x-20, self.center.y);
                         
    } completion:^(BOOL finished){
                         
            [UIView animateWithDuration:0.2
                animations:^{
                    self.center = CGPointMake(self.center.x+350, self.center.y);
                    self.alpha = 0;
            }completion:^(BOOL finised){
                self.hidden = YES;
            }];
    }];
    
}


// Buy points
- (void) buyFirstpack{
    [inapp proceedPurchaseWithType:@"25points" withCallback:^(BOOL success){
        if (success) {
            [mixpanel track:@"IAbought" properties:@{
                @"type": [NSString stringWithFormat:@"1"]
            }];
            
            [mixpanel.people trackCharge:@1];
            
            [[NSUserDefaults standardUserDefaults] setInteger:[[[NSUserDefaults standardUserDefaults] valueForKey:@"everBought"] integerValue]+1 forKey:@"everBought"];
            
             [self completedTans];
            
        }
    }];
}

- (void) buySecondpack{
    [inapp proceedPurchaseWithType:@"75points" withCallback:^(BOOL success){        
        if (success) {
            [mixpanel track:@"IAbought" properties:@{
                @"type": [NSString stringWithFormat:@"2"]
            }];
            
            [mixpanel.people trackCharge:@2];
            
            [[NSUserDefaults standardUserDefaults] setInteger:[[[NSUserDefaults standardUserDefaults] valueForKey:@"everBought"] integerValue]+1 forKey:@"everBought"];
            
             [self completedTans];
        }
    }];
 }

- (void) buyThirdpack{
    [inapp proceedPurchaseWithType:@"150points" withCallback:^(BOOL success){
        if (success) {
            [mixpanel track:@"IAbought" properties:@{
                    @"type": [NSString stringWithFormat:@"3"]
            }];
            
            [mixpanel.people trackCharge:@3];
            
            [[NSUserDefaults standardUserDefaults] setInteger:[[[NSUserDefaults standardUserDefaults] valueForKey:@"everBought"] integerValue]+1 forKey:@"everBought"];
            
            [self completedTans];

        }
    }];

}

- (void) completedTans
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AFTER_PURCHASE_TITLE", @"After purchase title")
                                                    message:NSLocalizedString(@"AFTER_PURCHASE_MESSAGE", @"After purchase message")
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [delegate finishedBuyingIA];
}

- (int) getPT:(float)size
{
    return self.frame.size.width * size;
}

@end
