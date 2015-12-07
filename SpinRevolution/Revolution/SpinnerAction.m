//
//  SpinnerAction.m
//  Revolution
//
//  Created by Ramon Fernández Mir on 12/03/14.
//  Copyright (c) 2014 Tomorrow. All rights reserved.
//

#import "SpinnerAction.h"

@implementation SpinnerAction

int lastRandom;
float extraDestination;
float changeTime;

@synthesize destination, speedPUWorking;

- (id)init
{
    self = [super init];
    if (self)
    {        
        destination      = [[NSUserDefaults standardUserDefaults] floatForKey:@"initialDifficulty"];
        extraDestination = [[NSUserDefaults standardUserDefaults] floatForKey:@"difficultyIncrease"];
        
        lastRandom = 5;
        
        changeTime = (((float) (arc4random() % (unsigned)RAND_MAX + 1) / RAND_MAX) * 4) + 3;
    }
    return self;
}

- (SKAction *)actionWithNode:(SKNode *)node
{
    int random = arc4random() % 5;
    while (lastRandom == random)
    {
        random = arc4random() % 5;
    }
    lastRandom = random;
    
    int randomDestination = arc4random() % 2;
    
    destination = fabsf(destination) + extraDestination;
    destination = randomDestination == 0 ? destination : -destination;
    
    changeTime = (((float) (arc4random() % (unsigned)RAND_MAX + 1) / RAND_MAX) * 4) + 3;
    float c = changeTime / 7.0;
    
    NSArray * actions = @[[SKEase RotateToWithNode:node EaseFunction:CurveTypeElastic Mode:EaseInOut Time:changeTime ToVector:node.zRotation + destination * 0.1350 * c],
                          [SKEase RotateToWithNode:node EaseFunction:CurveTypeLinear  Mode:EaseInOut Time:changeTime ToVector:node.zRotation + destination * 0.9600 * c],
                          [SKEase RotateToWithNode:node EaseFunction:CurveTypeSine    Mode:EaseInOut Time:changeTime ToVector:node.zRotation + destination * 0.8625 * c],
                          [SKEase RotateToWithNode:node EaseFunction:CurveTypeExpo    Mode:EaseInOut Time:changeTime ToVector:node.zRotation + destination * 0.4200 * c],
                          [SKEase RotateToWithNode:node EaseFunction:CurveTypeBack    Mode:EaseInOut Time:changeTime ToVector:node.zRotation + destination * 0.3975 * c]
                          ];
    
    return [actions objectAtIndex:random];
}

- (float)functionChangeTime
{
    NSLog(@"%f", changeTime);
    return changeTime;
}

@end
