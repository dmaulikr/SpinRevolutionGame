//
//  PUHeader.m
//  Revolution
//
//  Created by Martí Serra Vivancos on 05/03/14.
//  Copyright (c) 2014 Tomorrow. All rights reserved.
//

#import "PUHeader.h"

@implementation PUHeader

@synthesize lifePULabel, immuPULabel, comboPULabel, delegate;

float PUButtonsY;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0.12 green:0.88 blue:0.12 alpha:1];

    }
    return self;
}

- (void) load
{    
    // Powerups buttons
    PUButtonsY = self.frame.size.height*0.5;
    
    // If score view --> place label
    if (_inBuyView) {
        
        PUButtonsY = self.frame.size.height*0.38;
        
        UILabel *buy = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        buy.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:[self getPT:0.06]];
        buy.text =  NSLocalizedString(@"HEADER_MORE", @"Get more");
        buy.textColor = [UIColor whiteColor];
        [buy sizeToFit];
        buy.center = CGPointMake(self.frame.size.width/2, self.frame.size.height-buy.frame.size.height*0.6);
        [self addSubview:buy];
        
        [self setNeedsDisplay];
    }
    
    UIButton* extraPUButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [extraPUButton setImage:[UIImage imageNamed:@"extraPU.png"] forState:UIControlStateNormal];
    [extraPUButton addTarget:self
                      action:@selector(lifePUTouched)
            forControlEvents:UIControlEventTouchDown];
    extraPUButton.frame = CGRectMake(0, 0, self.frame.size.width*0.15, self.frame.size.width*0.15);
    extraPUButton.center = CGPointMake(self.frame.size.width*0.55, PUButtonsY);
    [self addSubview:extraPUButton];
    
    UIButton* immuPUButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [immuPUButton setImage:[UIImage imageNamed:@"immuPU.png"] forState:UIControlStateNormal];
    [immuPUButton addTarget:self
                     action:@selector(speedPUTouched)
           forControlEvents:UIControlEventTouchDown];
    immuPUButton.frame = CGRectMake(0, 0, self.frame.size.width*0.15, self.frame.size.width*0.15);
    immuPUButton.center = CGPointMake(self.frame.size.width*0.89, PUButtonsY);
    [self addSubview:immuPUButton];
    
    UIButton* comboPUButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [comboPUButton setImage:[UIImage imageNamed:@"comboPU.png"] forState:UIControlStateNormal];
    [comboPUButton addTarget:self
                      action:@selector(comboPUTouched)
            forControlEvents:UIControlEventTouchDown];
    comboPUButton.frame = CGRectMake(0, 0, self.frame.size.width*0.15, self.frame.size.width*0.15);
    comboPUButton.center = CGPointMake(self.frame.size.width*0.22, PUButtonsY);
    [self addSubview:comboPUButton];
    
    // Powerups labels
    lifePULabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    lifePULabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:[self getPT:0.1]];
    lifePULabel.text = @"0";
    lifePULabel.textColor = [UIColor whiteColor];
    [lifePULabel sizeToFit];
    [self addSubview:lifePULabel];
    
    immuPULabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    immuPULabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:[self getPT:0.1]];
    immuPULabel.text = @"0";
    immuPULabel.textColor = [UIColor whiteColor];
    [immuPULabel sizeToFit];
    [self addSubview:immuPULabel];
    
    comboPULabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    comboPULabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:[self getPT:0.1]];
    comboPULabel.text = @"0";
    comboPULabel.textColor = [UIColor whiteColor];
    [comboPULabel sizeToFit];
    [self addSubview:comboPULabel];
    
    float length = 0.85;
    float start = 0.15;
    if (_inBuyView)
    {
        length = 0.7;
        start = 0.07;
    }

    
    [self drawLineWithStartPoint:CGPointMake(self.frame.size.width*0.33, self.frame.size.height*start) endPoint:CGPointMake(self.frame.size.width*0.33, self.frame.size.height*length) WithColor:[UIColor blackColor]];
    [self drawLineWithStartPoint:CGPointMake(self.frame.size.width*0.66, self.frame.size.height*start) endPoint:CGPointMake(self.frame.size.width*0.66, self.frame.size.height*length) WithColor:[UIColor blackColor]];
                                  
    
    [self resetLabelValue];
}

// Draw lines fun
-(void)drawLineWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint WithColor:(UIColor *)color
{
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    // Set the starting point of the shape.
    [aPath moveToPoint:startPoint];
     
    // Draw the lines.
    [aPath addLineToPoint:endPoint];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [aPath CGPath];
    shapeLayer.strokeColor = [[UIColor whiteColor] CGColor];
    shapeLayer.lineWidth = 2.0;
    shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
    
    [self.layer addSublayer:shapeLayer];
}

// Reset labels
- (void) resetLabelValue
{
    lifePULabel.text  = [NSString stringWithFormat:@"%li",(long)[[[NSUserDefaults standardUserDefaults] valueForKey:@"extraPU"] integerValue]];
    immuPULabel.text  = [NSString stringWithFormat:@"%li",(long)[[[NSUserDefaults standardUserDefaults] valueForKey:@"immuPU"]  integerValue]];
    comboPULabel.text = [NSString stringWithFormat:@"%li",(long)[[[NSUserDefaults standardUserDefaults] valueForKey:@"comboPU"] integerValue]];
    
    [lifePULabel  sizeToFit];
    [immuPULabel  sizeToFit];
    [comboPULabel sizeToFit];
    
    lifePULabel.center  = CGPointMake(self.frame.size.width * 0.40, PUButtonsY);
    immuPULabel.center  = CGPointMake(self.frame.size.width * 0.73, PUButtonsY);
    comboPULabel.center = CGPointMake(self.frame.size.width * 0.07, PUButtonsY);
}

// Delegate calls
- (void) lifePUTouched
{
    [delegate PUtouched:1];
}

- (void) speedPUTouched
{
    [delegate PUtouched:2];
}

- (void) comboPUTouched
{
    [delegate PUtouched:3];
}

// More stuff
- (int) getPT:(float)size
{
    return self.frame.size.width * size;
}

@end
