//
//  PowerUPMenu.m
//  Revolution
//
//  Created by Martí Serra Vivancos on 01/03/14.
//  Copyright (c) 2014 Tomorrow. All rights reserved.
//

#import "PowerUPMenu.h"

int buyQuantity;
int UPprice = 1000;
int PUtype;

@implementation PowerUPMenu
@synthesize menuInfo, menuTitle, quantityLabel, priceLabel, oneLess, oneMore, buyButton, delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Create UI
        self.layer.cornerRadius = frame.size.width/2;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        // Orange view
        UIView *green = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.width*0.8, self.frame.size.width, self.frame.size.width*0.2)];
        green.backgroundColor = [UIColor colorWithRed:0.12 green:0.88 blue:0.12 alpha:1];
        [self addSubview:green];
        
        // Labels
        menuTitle = [[UITextView alloc]initWithFrame:CGRectMake(0,0, self.frame.size.width*0.5, self.frame.size.width*0.25)];
        menuTitle.backgroundColor = [UIColor clearColor];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setLineSpacing:0];
        [paragraphStyle setMaximumLineHeight:20.0f];
        
        NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:@"Test \nstring"];
        [commentString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [commentString length])];
        [commentString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1 green:0 blue:0 alpha:1.0f] range:NSMakeRange(0, [commentString length])];
        [menuTitle setAttributedText:commentString];
        
        menuTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:[self getPT:0.09]];
        menuTitle.textAlignment = NSTextAlignmentCenter;
        menuTitle.center = CGPointMake(self.frame.size.width*0.5,self.frame.size.width*0.14);
        menuTitle.editable = NO;
        menuTitle.selectable = NO;
        [self addSubview:menuTitle];
        
        menuInfo = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width*0.8, self.frame.size.width*0.3)];
        menuInfo.text = @"";
        menuInfo.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:[self getPT:0.07]];
        menuInfo.center = CGPointMake(self.frame.size.width*0.5,self.frame.size.width*0.32);
        menuInfo.textAlignment = NSTextAlignmentCenter;
        menuInfo.backgroundColor = [UIColor clearColor];
        menuInfo.editable = NO;
        menuInfo.selectable = NO;
        [self addSubview:menuInfo];
        
        buyQuantity = 1;
        
        quantityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        quantityLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:[self getPT:0.15]];
        [self addSubview:quantityLabel];
        
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        priceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:[self getPT:0.09]];
        [priceLabel sizeToFit];
        priceLabel.center = CGPointMake(self.frame.size.width*0.5,self.frame.size.width*0.67);
        [self addSubview:priceLabel];
        
        // Buttons
        
        oneMore = [UIButton buttonWithType:UIButtonTypeCustom];
        [oneMore setImage:[UIImage imageNamed:@"addPU.png"] forState:UIControlStateNormal];
        [oneMore addTarget:self
                    action:@selector(addQuantity)
          forControlEvents:UIControlEventTouchUpInside];
        oneMore.frame = CGRectMake(0, 0, self.frame.size.width*0.15, self.frame.size.width*0.15);
        //oneMore.alpha = 0.5;
        [self addSubview:oneMore];
        
        oneLess = [UIButton buttonWithType:UIButtonTypeCustom];
        [oneLess setImage:[UIImage imageNamed:@"deductPU.png"] forState:UIControlStateNormal];
        [oneLess addTarget:self
                    action:@selector(deductQuantity)
          forControlEvents:UIControlEventTouchUpInside];
        oneLess.frame = CGRectMake(0, 0, self.frame.size.width*0.15, self.frame.size.width*0.15);
        //oneLess.alpha = 0.5;
        [self addSubview:oneLess];
        
        buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [buyButton setTitle:NSLocalizedString(@"BUY", @"Buy") forState:UIControlStateNormal];
        buyButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:[self getPT:0.1]];
        [buyButton addTarget:self
                      action:@selector(buyPowerUps)
            forControlEvents:UIControlEventTouchUpInside];
        [buyButton sizeToFit];
        buyButton.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.width*0.89);
        buyButton.showsTouchWhenHighlighted = YES;
        [self addSubview:buyButton];     
        
        [self adjustLabels];
        
        self.hidden = YES;

    }
    return self;
}

- (void) openPowerMenu:(int)type
{
    self.hidden = NO;
    self.alpha = 0;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut
            animations:^{
                self.alpha = 0;
            self.center = CGPointMake(self.center.x+300, self.center.y);
    }
    completion:NULL];
  
    
    if (type==1)
    {
        PUtype = 1;
        menuTitle.textColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
        menuTitle.text = NSLocalizedString(@"EXTRA_LIFE", @"Extra life");
        menuInfo.text = NSLocalizedString(@"EXTRA_LIFE_INFO", @"Extra life info");
        

    }
        
   if (type==2)
    {
        PUtype = 2;
        menuTitle.textColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1.0f];
        menuTitle.text = NSLocalizedString(@"LIFE_IMMUNITY", @"Life immunity");
        menuInfo.text =  NSLocalizedString(@"LIFE_IMMUNITY_INFO", @"Life immunity info");
        
        
    }
        
    if (type==3)
    {
        PUtype = 3;
        menuTitle.textColor =  [UIColor colorWithRed:1 green:0.44 blue:0 alpha:1];
        menuTitle.text = NSLocalizedString(@"POINTS_COMBO", @"Points combo");
        menuInfo.text = NSLocalizedString(@"POINTS_COMBO_INFO", @"Points combo info");
    }
    
    self.center = CGPointMake(-300, self.center.y);
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn
        animations:^{
            self.center = CGPointMake(190, self.center.y);
            self.alpha = 1;
    } completion:^(BOOL finished){
        
        [UIView animateWithDuration:0.2
            animations:^{
            
                self.center = CGPointMake(160, self.center.y);
        }
        completion:NULL];
    }];
}

- (void) closePowerMenu
{
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

- (void) addQuantity{
    
    buyQuantity = buyQuantity + 1;
    [self adjustLabels];
}

- (void) deductQuantity{
    
    if (buyQuantity > 1) {
        buyQuantity = buyQuantity - 1;
        [self adjustLabels];
    }
}

- (void) buyPowerUps{
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"walletPoints"] integerValue]>=buyQuantity*UPprice) {
        
        if (PUtype==1)
        {
            [[NSUserDefaults standardUserDefaults] setInteger:[[[NSUserDefaults standardUserDefaults] valueForKey:@"extraPU"] integerValue]+buyQuantity forKey:@"extraPU"];
      
        }
        
        if (PUtype==2)
        {
             [[NSUserDefaults standardUserDefaults] setInteger:[[[NSUserDefaults standardUserDefaults] valueForKey:@"immuPU"] integerValue]+buyQuantity forKey:@"immuPU"];
        }
        
        if (PUtype==3)
        {
            
            [[NSUserDefaults standardUserDefaults] setInteger:[[[NSUserDefaults standardUserDefaults] valueForKey:@"comboPU"] integerValue]+buyQuantity forKey:@"comboPU"];
        }
        
        [[NSUserDefaults standardUserDefaults] setInteger:[[[NSUserDefaults standardUserDefaults] valueForKey:@"walletPoints"] integerValue]-buyQuantity*UPprice forKey:@"walletPoints"];
        
        // Call delegate with finished shopping
        [delegate finishedBuyingPU:PUtype:buyQuantity];
        
        buyQuantity = 1;
        [self adjustLabels];
       
    }
    else
    {
        CAKeyframeAnimation * anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"] ;
        anim.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f)], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f)]];
        anim.autoreverses = YES;
        anim.repeatCount = 2.0f;
        anim.duration = 0.07f;
        [priceLabel.layer addAnimation:anim forKey:nil ];
        
        [UIView transitionWithView:priceLabel duration:0.15 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [priceLabel setTextColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]];
        } completion:^(BOOL finished){
            
            [UIView transitionWithView:priceLabel duration:0.15 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [priceLabel setTextColor:[UIColor blackColor]];
            } completion:NULL];
        }];

    }
}


- (void) adjustLabels
{
    quantityLabel.text = [NSString stringWithFormat:@"%i", buyQuantity];
    priceLabel.text = [NSString stringWithFormat:NSLocalizedString(@"POWERUP_PRICE", @"Powerup price"), buyQuantity*UPprice];
    
    [quantityLabel sizeToFit];
    quantityLabel.center = CGPointMake(self.frame.size.width*0.5,self.frame.size.width*0.5);
    [priceLabel sizeToFit];
    priceLabel.center = CGPointMake(self.frame.size.width*0.5,self.frame.size.width*0.67);
    
    oneLess.center = CGPointMake(quantityLabel.center.x - self.frame.size.width*0.2, quantityLabel.center.y);
    oneMore.center = CGPointMake(quantityLabel.center.x + self.frame.size.width*0.2, quantityLabel.center.y);
}

- (int) getPT:(float)size
{
    return self.frame.size.width * size;

}




@end
