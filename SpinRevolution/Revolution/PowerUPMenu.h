//
//  PowerUPMenu.h
//  Revolution
//
//  Created by Martí Serra Vivancos on 01/03/14.
//  Copyright (c) 2014 Tomorrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PUMenuDelegate;

@interface PowerUPMenu : UIView 
@property (nonatomic, retain) UITextView *menuTitle;
@property (nonatomic, retain) UITextView *menuInfo;
@property (nonatomic, retain) UILabel *quantityLabel;
@property (nonatomic, retain) UILabel *priceLabel;

@property (nonatomic, retain) UIButton *oneMore;
@property (nonatomic, retain) UIButton *oneLess;
@property (nonatomic, retain) UIButton *buyButton;

@property (assign, nonatomic) id<PUMenuDelegate> delegate;

- (void) openPowerMenu: (int)type;
- (void) closePowerMenu;

@end

@protocol PUMenuDelegate <NSObject>

- (void) finishedBuyingPU: (int)type :(int)quantity;

@end

