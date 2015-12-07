//
//  TutorialVC.m
//  Revolution
//
//  Created by Martí Serra Vivancos on 19/05/14.
//  Copyright (c) 2014 Tomorrow. All rights reserved.
//

#import "TutorialVC.h"

@interface TutorialVC ()

@end

@implementation TutorialVC

#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE

int letterSize = 24;
float textY;
float ycorrection;

- (void) viewDidLoad
{
    textY = 50;
    if (!isiPhone5)
    {
        letterSize = 20;
        textY = 32;
        ycorrection = 45;
    }
 
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    self.navigationController.navigationBarHidden = YES;
    
    // Common images
    UIImageView* iphone = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iphone.png"]];
    iphone.frame = CGRectMake(40, 150-ycorrection, 240, 504);
    [self.view addSubview:iphone];
    
    _screen = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homegame.png"]];
    _screen.frame = CGRectMake(61, 225-ycorrection, 200, 357);
    [self.view addSubview:_screen];
    
    _spinner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"spinner.png"]];
    _spinner.frame = CGRectMake(0, 0, 150, 150);
    _spinner.center = CGPointMake(160, 450-ycorrection*1.25);
    [self.view addSubview:_spinner];
    
    _finger = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hand.png"]];
    _finger.frame = CGRectMake(0, 0, 80, 80);
    _finger.center = CGPointMake(189, 523 - ycorrection*1.25);
    [self.view addSubview:_finger];
    
    // Buttons
    _next = [UIButton buttonWithType:UIButtonTypeCustom];
    [_next setTitle:NSLocalizedString(@"TUTORIAL_NEXT", @"Tutorial next") forState:UIControlStateNormal];
    _next.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:25];
    [_next addTarget:self
                      action:@selector(nextpage)
    forControlEvents:UIControlEventTouchUpInside];
    [_next setTitleColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:1] forState:UIControlStateNormal];
    [_next sizeToFit];
    _next.center = CGPointMake(self.view.frame.size.width - 0.5 * _next.frame.size.width -10, 23);
    _next.showsTouchWhenHighlighted = YES;
    [self.view addSubview:_next];
    
    _back = [UIButton buttonWithType:UIButtonTypeCustom];
    [_back setTitle:NSLocalizedString(@"TUTORIAL_BACK", @"Tutorial back") forState:UIControlStateNormal];
    _back.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:25];
    [_back addTarget:self
              action:@selector(backpage)
    forControlEvents:UIControlEventTouchUpInside];
    [_back sizeToFit];
    _back.center = CGPointMake(0.5 * _back.frame.size.width + 10, 23);
    _back.showsTouchWhenHighlighted = YES;
    _back.hidden = YES;
    [_back setTitleColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:_back];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-40)];
    _scrollView.scrollEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(320*4, self.view.frame.size.height-40);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
}

- (void) viewDidAppear:(BOOL)animated
{    
    
    // First view
    UIView *first = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    first.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:first];
    
    UITextView* text1 = [[UITextView alloc]initWithFrame:CGRectMake(0,0, 0, 0)];
    text1.backgroundColor = [UIColor clearColor];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setLineSpacing:0];
    [paragraphStyle setMaximumLineHeight:letterSize-2];
    
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"TUTORIAL_1_TEXT", @"Tutorial 1 text")];
    [commentString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [commentString length])];
    [commentString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f] range:NSMakeRange(0, [commentString length])];
    [text1 setAttributedText:commentString];
    
    text1.font = [UIFont fontWithName:@"HelveticaNeue" size:letterSize];
    text1.textAlignment = NSTextAlignmentCenter;
    text1.editable = NO;
    text1.selectable = NO;
    [text1 sizeToFit];
    text1.center = CGPointMake(first.frame.size.width/2, textY);
    [first addSubview:text1];
    
    // Second view
    UIView *second = [[UIView alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    second.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:second];
    
    UITextView* text2 = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 0, self.view.frame.size.width)];
    text2.backgroundColor = [UIColor clearColor];
    
    NSMutableAttributedString *commentString2 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"TUTORIAL_2_TEXT", @"Tutorial 2 text")];
    [commentString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [commentString2 length])];
    [commentString2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f] range:NSMakeRange(0, [commentString2 length])];
    [text2 setAttributedText:commentString2];
    
    text2.font = [UIFont fontWithName:@"HelveticaNeue" size:letterSize];
    text2.textAlignment = NSTextAlignmentCenter;
    text2.editable = NO;
    text2.selectable = NO;
    [text2 sizeToFit];
    text2.center = CGPointMake(second.frame.size.width/2, textY);
    [second addSubview:text2];
    
    UILabel* combo = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    combo.text = @"x2";
    combo.font = [UIFont fontWithName:@"Helvetica-Light" size:25];
    combo.textColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
    [combo sizeToFit];
    combo.center = CGPointMake(230, 255-ycorrection);
    [second addSubview:combo];
    
    UIImageView* arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    arrow.frame = CGRectMake(80, 230-ycorrection, 45, 45);
    arrow.alpha = 0.7;
    [second addSubview:arrow];
    
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         arrow.center = CGPointMake(arrow.center.x-20, arrow.center.y);
                     }  completion:NULL];
    
    // Third view
    UIView *third = [[UIView alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width*2, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    third.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:third];
    
    UITextView* text3 = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    text3.backgroundColor = [UIColor clearColor];
    
    NSMutableAttributedString *commentString3 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"TUTORIAL_3_TEXT", @"Tutorial 3 text")];
    [commentString3 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [commentString3 length])];
    [commentString3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f] range:NSMakeRange(0, [commentString3 length])];
    [text3 setAttributedText:commentString3];
    
    text3.font = [UIFont fontWithName:@"HelveticaNeue" size:letterSize];
    text3.textAlignment = NSTextAlignmentCenter;
    text3.editable = NO;
    text3.selectable = NO;
    [text3 sizeToFit];
    text3.center = CGPointMake(third.frame.size.width/2, textY);
    [third addSubview:text3];
    
    [self createCircle:CGPointMake(105, 205-ycorrection) :third];
    [self createCircle: CGPointMake(171, 205-ycorrection):third];
    [self createCircle:CGPointMake(239, 205-ycorrection) :third];
    
    
    // Forth view
    UIView *fourth = [[UIView alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width*3, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    fourth.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:fourth];
    
    UITextView* text4 = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    text4.backgroundColor = [UIColor clearColor];
    
    NSMutableAttributedString *commentString4 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"TUTORIAL_4_TEXT", @"Tutorial 4 text")];
    [commentString4 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [commentString4 length])];
    [commentString4 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f] range:NSMakeRange(0, [commentString4 length])];
    [text4 setAttributedText:commentString4];
    
    text4.font = [UIFont fontWithName:@"HelveticaNeue" size:letterSize];
    text4.textAlignment = NSTextAlignmentCenter;
    text4.editable = NO;
    text4.selectable = NO;
    [text4 sizeToFit];
    text4.center = CGPointMake(fourth.frame.size.width/2, textY);
    [fourth addSubview:text4];
    [self createCircle:CGPointMake(105, 205-ycorrection) :fourth];
    [self createCircle: CGPointMake(171, 205-ycorrection):fourth];
    [self createCircle:CGPointMake(239, 205-ycorrection) :fourth];
    
    UIImageView* arrow2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    arrow2.frame = CGRectMake(175, 430-ycorrection, 45, 45);
    arrow2.alpha = 0.7;
    [fourth addSubview:arrow2];
    
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         arrow2.center = CGPointMake(arrow2.center.x-20, arrow2.center.y);
                     }  completion:NULL];
    

   [self startSpinnerAnimations];
}

// Scrollview
- (void) nextpage
{
    int page = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * (page+1);
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
    
    if (page==3) {
        [_delegate finishedReadingTutorial];
    }
    
}

- (void) backpage
{
    int page = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * (page-1);
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
}

- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self adjustScrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self adjustScrollView];
}

- (void) adjustScrollView
{
    int page = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    
    if (page==0) {
        [_next setTitle:NSLocalizedString(@"TUTORIAL_NEXT", @"Tutorial next") forState:UIControlStateNormal];
        [_next sizeToFit];
        _next.center = CGPointMake(self.view.frame.size.width - 0.5 * _next.frame.size.width -10, 23);
        [_screen setImage:[UIImage imageNamed:@"homegame"]];
        _spinner.hidden = NO;
        _finger.hidden = NO;
        _back.hidden = YES;
    }
    
    if (page==1) {
        [_next setTitle:NSLocalizedString(@"TUTORIAL_NEXT", @"Tutorial next")forState:UIControlStateNormal];
        [_next sizeToFit];
        _next.center = CGPointMake(self.view.frame.size.width - 0.5 * _next.frame.size.width -10, 23);
        [_screen setImage:[UIImage imageNamed:@"homegame"]];
        _spinner.hidden = NO;
        _finger.hidden = NO;
        _back.hidden = NO;

    }
    
    if (page==2) {
        [_next setTitle:NSLocalizedString(@"TUTORIAL_NEXT", @"Tutorial next") forState:UIControlStateNormal];
         [_next sizeToFit];
        _next.center = CGPointMake(self.view.frame.size.width - 0.5 * _next.frame.size.width -10, 23);
        [_screen setImage:[UIImage imageNamed:@"homegame"]];
        _spinner.hidden = NO;
        _back.hidden = NO;
        _finger.hidden = NO;
    }
    
    if (page==3) {
        _spinner.hidden = YES;
        _finger.hidden = YES;
        _back.hidden = NO;
        [_next setTitle:NSLocalizedString(@"TUTORIAL_PLAY", @"Tutorial play") forState:UIControlStateNormal];
        [_next sizeToFit];
        [_screen setImage:[UIImage imageNamed:@"finishgame.png"]];
        _next.center = CGPointMake(self.view.frame.size.width - 0.5 * _next.frame.size.width -10, 23);
    }
}

// Animations
- (void) startSpinnerAnimations
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration =  1.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INFINITY;
    [_spinner.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, 170, 473 - ycorrection*1.25, 60, M_PI * 0.333, M_PI * 2 + M_PI * 0.33, NO);
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.path = path;
    [pathAnimation setFillMode:kCAFillModeForwards];
    pathAnimation.duration = 1.5;
    pathAnimation.repeatCount = INFINITY;
    
    [_finger.layer addAnimation:pathAnimation forKey:@"position"];

}

- (void) createCircle: (CGPoint)location :(UIView *) placement
{
    UIView* circle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [circle.layer setBorderColor:[UIColor whiteColor].CGColor];
    [circle.layer setCornerRadius:20.0f];
    [circle.layer setBorderWidth:3];
    circle.center = location;
    [placement addSubview:circle];
    
    
    [UIView animateWithDuration:0.6
                          delay:0.0
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{
                         
                         circle.alpha = 0;
       
                     }
                     completion:NULL];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
