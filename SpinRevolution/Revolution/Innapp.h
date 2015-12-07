//
//  Innapp.h
//  Revolution
//
//  Created by Martí Serra Vivancos on 21/03/14.
//  Copyright (c) 2014 Tomorrow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

typedef void (^proceedPurchaseCallback)(BOOL success);

@interface Innapp : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>{
    
    proceedPurchaseCallback _callback;
}

- (void)proceedPurchaseWithType:(NSString *)inapp withCallback:(proceedPurchaseCallback)callback;

@property (nonatomic, strong) NSString *inType;

@end
