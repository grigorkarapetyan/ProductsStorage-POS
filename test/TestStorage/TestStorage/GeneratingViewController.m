//
//  GeneratingViewController.m
//  ProductsStorage
//
//  Created by Grigor Karapetyan on 1/9/17.
//  Copyright © 2017 Grigor Karapetyan. All rights reserved.
//

#import "GeneratingViewController.h"
#import "SWRevealViewController.h"
#import "DataManager.h"

@interface GeneratingViewController ()
@property (nonatomic,copy) NSArray<Product *> *allProducts;

@end

@implementation GeneratingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

// ADDING reveal part
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sideBarButton setTarget: self.revealViewController];
        [self.sideBarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
// -----------------------------------
  
}
- (IBAction)generateNewProducts {
    [self generateAlert];
}
- (IBAction)deleteHistory {
    [self deleteAlert];
}
- (void) generateAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Generate alert"
                                                                   message:@"All existing products and purchase history will be deleted"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* continueButton = [UIAlertAction actionWithTitle:@"Generate"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               [self deleteActions];
                                                               [self generateAction];
                                                           } ];
    
    UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alert addAction:continueButton];
    [alert addAction:cancelButton];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)deleteAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete alert"
                                                                   message:@"All products and purchase history will be deleted"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* continueButton = [UIAlertAction actionWithTitle:@"Continue"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 [self deleteActions];
                                                             } ];
    
    UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alert addAction:continueButton];
    [alert addAction:cancelButton];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)generateAction {
    [[DataManager sharedManager] generateProducts];
    self.allProducts = [[DataManager sharedManager] fetchAllProducts];
        
    for (Product *product in self.allProducts) {
        NSLog(@"product N:%lu \n name:%@ \n price:%d \n barcode:%@ \n PLU:%d \n",(unsigned long)[self.allProducts indexOfObject:product],product.name,product.price,product.barcode,product.plu);
    }  // checking
}

- (void)deleteActions {
    self.allProducts = [[DataManager sharedManager] fetchAllProducts];
    NSArray<Purchase *> *allPurchases = [[DataManager sharedManager] fetchAllPurchases];
    NSArray<ProductAmount *> *allProductAmounts = [[DataManager sharedManager] fetchAllProductAmounts];
    
    [[DataManager sharedManager] deleteAllProducts:self.allProducts];
    [[DataManager sharedManager] deleteAllPurchases:allPurchases];
    [[DataManager sharedManager] deleteAllProductAmounts:allProductAmounts];
}

@end
