//
//  PUHeader.h
//  Revolution
//
//  Created by Martí Serra Vivancos on 05/03/14.
//  Copyright (c) 2014 Tomorrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PUButtonsDelegate;

@interface PUHeader : UIView

@property (nonatomic, strong) UILabel* lifePULabel;
@property (nonatomic, strong) UILabel* immuPULabel;
@property (nonatomic, strong) UILabel* comboPULabel;
@property (assign, nonatomic) id<PUButtonsDelegate> delegate;

@property (nonatomic) bool inBuyView;
- (void) load;
- (void) resetLabelValue;

@end


@protocol PUButtonsDelegate <NSObject>

- (void) PUtouched: (int) type;


@end

