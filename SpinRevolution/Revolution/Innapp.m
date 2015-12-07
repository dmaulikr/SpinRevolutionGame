//
//  Innapp.m
//  Revolution
//
//  Created by Martí Serra Vivancos on 21/03/14.
//  Copyright (c) 2014 Tomorrow. All rights reserved.
//

#import "Innapp.h"

@implementation Innapp

- (void)proceedPurchaseWithType:(NSString *)inapp withCallback:(proceedPurchaseCallback)callback
{
    _callback = [callback copy];
    
    _inType = [inapp copy];
    
    if ([SKPaymentQueue canMakePayments]){
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        SKProductsRequest *req = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObjects:inapp, nil]];
        [req setDelegate:self];
        [req start];
        
    }
    else if (_callback) _callback(false);
}


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    SKProduct *product = [response.products objectAtIndex:0];
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    

}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    _callback(YES);
    
    if ([_inType  isEqual: @"25points"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:[[[NSUserDefaults standardUserDefaults] valueForKey:@"walletPoints"] integerValue]+20000 forKey:@"walletPoints"];

    }
    
    if ([_inType  isEqual: @"75points"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:[[[NSUserDefaults standardUserDefaults] valueForKey:@"walletPoints"] integerValue]+50000 forKey:@"walletPoints"];
        
    }
    
    if ([_inType  isEqual: @"150points"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:[[[NSUserDefaults standardUserDefaults] valueForKey:@"walletPoints"] integerValue]+100000 forKey:@"walletPoints"];
        
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}



- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    _callback(NO);
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Unsuccessful"
                                                        message:@"Your purchase failed. Please try again."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

@end
