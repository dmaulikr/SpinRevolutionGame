//
//  AppDelegate.m
//  Revolution
//
//  Created by Martí Serra Vivancos on 08/02/14.
//  Copyright (c) 2014 Tomorrow. All rights reserved.
//

#import "AppDelegate.h"


#define MIXPANEL_TOKEN @"e8429217f5a5aa0dec4a893d94960c2d"

// What we consider standard values
#define STANDARD_INITIAL_DIFFICULTY  20
#define STANDARD_DIFFICULTY_INCREASE 1.5
#define STANDARD_SHIFT_TIME          1.1
#define STANDARD_ERROR_MARGIN        0.554

// Margins: Max/Min = Standard +/- Margin
#define MARGIN_INITIAL_DIFFICULTY  6
#define MARGIN_DIFFICULTY_INCREASE 1.5
#define MARGIN_SHIFT_TIME          0.3
#define MARGIN_ERROR_MARGIN        0.03

@implementation AppDelegate

@synthesize mixpanel;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Rater
    [Appirater setAppId:@"802170884"];
    [Appirater setDaysUntilPrompt:3];
    [Appirater setUsesUntilPrompt:3];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];

    // Push notifications login
    if ([[UIApplication sharedApplication]respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
  
    // Create NSUserDefaults for the first time
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"firstLoadDone"] boolValue] != YES)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"extraPU"];
        [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"comboPU"];
        [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"immuPU"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"everBought"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"gamesPlayed"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"walletPoints"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"answeredSurvey"];
    
        // Fixed values for each constant
        // * Initial difficulty
        // * Difficulty increase
        // * Shift time
        // * Error margin
        /*float * gaussianNums = [self fourGaussianNumbers];
        float initialDifficulty  = STANDARD_INITIAL_DIFFICULTY  + gaussianNums[0] * MARGIN_INITIAL_DIFFICULTY;
        float difficultyIncrease = STANDARD_DIFFICULTY_INCREASE + gaussianNums[1] * MARGIN_DIFFICULTY_INCREASE;
        float shiftTime          = STANDARD_SHIFT_TIME          + gaussianNums[2] * MARGIN_SHIFT_TIME;
        float errorMargin        = STANDARD_ERROR_MARGIN        + gaussianNums[3] * MARGIN_ERROR_MARGIN;*/
        
        [[NSUserDefaults standardUserDefaults] setFloat:14  forKey:@"initialDifficulty"];
        [[NSUserDefaults standardUserDefaults] setFloat:3 forKey:@"difficultyIncrease"];
        [[NSUserDefaults standardUserDefaults] setFloat:1.3          forKey:@"shiftTime"];
        [[NSUserDefaults standardUserDefaults] setFloat:0.58        forKey:@"errorMargin"];
        
        NSLog(@"New user");
    }
    
    // Mixpanel login
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    mixpanel = [Mixpanel sharedInstance];
    [mixpanel identify:[UIDevice currentDevice].identifierForVendor.UUIDString];
    mixpanel.showSurveyOnActive = NO;
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error)
     {
         if (localPlayer.isAuthenticated)
         {
             NSLog(@"Done");
         }
         else if (error != nil)
         {
             NSLog(@"error : %@", [error description]);
         }
     };
    
    
    return YES;
}

// Box-Muller transformation in polar form
/*- (float *)fourGaussianNumbers
{
    float * gaussianNums = (float *)malloc(sizeof(float) * 4);
    int gNumsSize = 0;
    
    float x1, x2, w, y1, y2;
    do
    {
        do
        {
            x1 = 2.0 * (float)(arc4random() % 10000 + 1) / 10000 - 1.0;
            x2 = 2.0 * (float)(arc4random() % 10000 + 1) / 10000 - 1.0;
            
            w = x1 * x1 + x2 * x2;
        }
        while (w >= 1.0);
        w  = sqrtf((-2.0 * logf(w)) / w);
        y1 = x1 * w > 1.0 ? 1.0 : (x1 * w < -1.0 ? -1.0 : x1 * w);
        y2 = x2 * w > 1.0 ? 1.0 : (x2 * w < -1.0 ? -1.0 : x2 * w);
        
        if (gNumsSize < 4 && fabs(y1) < 1.0)
        {
            gaussianNums[gNumsSize] = y1;
            gNumsSize++;
        }
        if (gNumsSize < 4 && fabs(y2) < 1.0)
        {
            gaussianNums[gNumsSize] = y2;
            gNumsSize++;
        }
    }
    while (gNumsSize < 4);
        
    return gaussianNums;
}*/

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Pass to Mixpanel the device tolen
    [mixpanel.people addPushDeviceToken:deviceToken];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
