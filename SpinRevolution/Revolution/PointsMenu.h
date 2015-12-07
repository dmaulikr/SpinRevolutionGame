//
//  PointsMenu.h
//  Revolution
//
//  Created by Martí Serra Vivancos on 04/03/14.
//  Copyright (c) 2014 Tomorrow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "Innapp.h"
#import "Mixpanel.h"

@protocol IAMenuDelegate;

@interface PointsMenu : UIView <UIAlertViewDelegate, MixpanelDelegate>

- (void) openPointsMenu;
- (void) closePointsMenu;

@property (nonatomic, strong) Innapp *inapp;
@property (nonatomic, strong) Mixpanel *mixpanel;

@property (assign, nonatomic) id<IAMenuDelegate> delegate;

@end

@protocol IAMenuDelegate <NSObject>

- (void) finishedBuyingIA;

@end

