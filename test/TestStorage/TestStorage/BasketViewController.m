//
//  BasketViewController.m
//  TestStorage
//
//  Created by Grigor Karapetyan on 2/26/17.
//  Copyright © 2017 Grigor Karapetyan. All rights reserved.
//

#import "BasketViewController.h"
#import "DataManager.h"
#import "PurchaseTableViewCell.h"
#import "MyPurchase.h"

@interface BasketViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *PurchasesTableView;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (nonatomic) NSInteger totalAmount;
@property (nonatomic,copy) NSArray<MyPurchase *> *myPurchase;

@end

@implementation BasketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myPurchase = [[DataManager sharedManager] currentBasket];    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [self reload];
}

// TABLE VIEW building

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.myPurchase count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"purchaseCell" forIndexPath:indexPath];

    NSString *name = [[[self.myPurchase objectAtIndex:indexPath.row] product] name];
    NSInteger price = [[[self.myPurchase objectAtIndex:indexPath.row] product] price];
    NSInteger quantity = [[self.myPurchase objectAtIndex:indexPath.row] quantity];
    
    cell.productNameLabel.text = name;
    cell.productPriceLabel.text = [NSString stringWithFormat:@"%ld",(long)price];
    cell.productQuantityLabel.text = [NSString stringWithFormat:@"%ld",(long)quantity];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)reload {
    self.myPurchase = [[DataManager sharedManager] currentBasket];
    [self.PurchasesTableView reloadData];
    NSInteger amount = 0;
    for (MyPurchase *onePurchase in self.myPurchase) {
        amount = amount + ([[onePurchase product] price] * [onePurchase quantity]);
    }
    self.totalAmountLabel.text = [ NSString stringWithFormat:@"%ld", (long)amount];
    self.totalAmount = amount;
}

//  DELETING product
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSInteger index = indexPath.row;
        [[DataManager sharedManager] deleteProductFromBasket:index];
        [self reload];
    }
}

//COMMIT purchase
- (IBAction)commitPurchase:(id)sender {
    if (self.myPurchase.count != 0){
        
        [[DataManager sharedManager] purchaseRegister:self.myPurchase];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
        NSString *purchaseDate = [formatter stringFromDate:self.myPurchase[0].purchaseDate];
        
        NSString *purchaseDetails = [NSString stringWithFormat:@"Cheque:%ld \n Date:%@ \n Amount:%ld",(long)[[DataManager sharedManager] currentPurchaseNumber],purchaseDate,(long)self.totalAmount ];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Purchase details"
                                                                       message:purchaseDetails
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
        [self reload];
        
    }
    
    NSArray<Purchase *> *allPurchases = [[DataManager sharedManager] fetchAllPurchases];
    NSArray<ProductAmount *> *allProductAmounts = [[DataManager sharedManager] fetchAllProductAmounts];
    
    for (Purchase *onePurchase in allPurchases) {
        NSLog(@"purchaseNumber:%d \n ",onePurchase.number);
    }
    for (ProductAmount *oneProductAmount in allProductAmounts) {
        NSLog(@"productAmount:%d \n ",oneProductAmount.amount);
    }
//checking
//    [[DataManager sharedManager] deleteAllPurchases:allPurchases];
//    [[DataManager sharedManager] deleteAllProductAmounts:allProductAmounts];
}

@end










