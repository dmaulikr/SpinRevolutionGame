//
//  TutorialVC.h
//  Revolution
//
//  Created by Martí Serra Vivancos on 19/05/14.
//  Copyright (c) 2014 Tomorrow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@protocol TutorialDelegate;

@interface TutorialVC : UIViewController <UIScrollViewDelegate>

@property (nonatomic, retain) UIView *buttonView;
@property (nonatomic, retain) UIButton *back;
@property (nonatomic, retain) UIButton *next;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *screen;
@property (nonatomic, retain) UIImageView *spinner;
@property (nonatomic, retain) UIImageView *finger;

@property (assign, nonatomic) id<TutorialDelegate> delegate;

@end

@protocol TutorialDelegate <NSObject>

- (void) finishedReadingTutorial;

@end
