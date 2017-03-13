//
//  DataManager.m
//  ProductsStorage
//
//  Created by Grigor Karapetyan on 1/9/17.
//  Copyright © 2017 Grigor Karapetyan. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager
const int productsCount = 500;

+ (instancetype)sharedManager {
    static DataManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DataManager alloc] init];
    });
    return instance;
}


// FETCHING all products
- (NSArray <Product *>*) fetchAllProducts {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    return [[[DataManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:nil];
}

//FETCHING products after filter

- (NSArray <Product *>*) fetchProductsByName:(NSString *) name {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Product"];

    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@",name];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    return [[[DataManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:nil];
}
- (NSArray <Product *>*) fetchProductsByBarcode:(NSString *) barcode {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Product"];

    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"barcode CONTAINS[c] %@",barcode];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    return [[[DataManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:nil];
}
- (NSArray <Product *>*) fetchProductsByFullBarcode:(NSString *) barcode {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"barcode LIKE[c] %@",barcode];
//    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    return [[[DataManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:nil];
}
- (NSArray <Product *>*) fetchProductsByPLUContains:(int) plu {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"plu CONTAINS[c] %i",plu];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    return [[[DataManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:nil];
}
- (NSArray <Product *>*) fetchProductsByPLU:(int) plu {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"plu == %i",plu];
//    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    return [[[DataManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:nil];
}


// GENERATE all products
- (void)generateProducts {
    NSManagedObjectContext *context = [[DataManager sharedManager] managedObjectContext];
    
    NSDictionary *products = [[DataManager sharedManager] generateAllProductsDetails];
    for (int i = 0; i < productsCount; i++) {
        Product *newProduct = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:context];
        newProduct.name = [[products objectForKey:@"names"] objectAtIndex:i];
        NSNumber *price = [[products objectForKey:@"prices"] objectAtIndex:i];
        NSNumber *plu = [[products objectForKey:@"PLUs"] objectAtIndex:i];
        newProduct.price = [price intValue];
        newProduct.plu = [plu intValue];

        if (![[[products objectForKey:@"barcodes"] objectAtIndex:i] isKindOfClass:[NSNull class]]){
            newProduct.barcode = [[products objectForKey:@"barcodes"] objectAtIndex:i];
        }
        [[DataManager sharedManager] saveContext];
    }
}

//ADD one product
- (void)addOneProduct:(MyProduct *) product {
    NSManagedObjectContext *context = [[DataManager sharedManager] managedObjectContext];
    Product *newProduct = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:context];
    
    newProduct.name = product.productName;
    newProduct.barcode = product.productBarcode;
    newProduct.price = (int) product.productPrice;
    newProduct.plu = (int) product.productPLU;
    
    [[DataManager sharedManager] saveContext];
}

//DELETE all products
- (void)deleteAllProducts:(NSArray<Product *> *) allProducts {
    for (Product * product in allProducts) {
    NSManagedObjectContext *context = [product managedObjectContext];
    [context deleteObject:product];
    [[DataManager sharedManager] saveContext];
    }
}

//DELETE selected product
- (void)deleteProduct:(Product *) product {
    NSManagedObjectContext *context = [product managedObjectContext];
    [context deleteObject:product];
    
    [[DataManager sharedManager] saveContext];
}

// EDIT selected product
- (void)editSelectedProduct {
    if ([[DataManager sharedManager] selectedProduct]) {
        [[DataManager sharedManager] saveContext];
    }
}

#pragma mark - PURCHASE product

// ADD product to BASKET
- (void)addProductToBasket:(MyPurchase *) purchase {
    if (!self.currentBasket) {
        self.currentBasket = [[NSMutableArray alloc] init];
    }
    [self.currentBasket addObject:purchase];
    NSLog(@"all purchases: %@",self.currentBasket);
}

//DELETE product from BASKET
- (void)deleteProductFromBasket:(NSInteger) index {
    [self.currentBasket removeObjectAtIndex:index];
}

//REGISTER the purchase
- (void)purchaseRegister:(NSArray <MyPurchase *>*) myPurchase {
    [self generatePurchaseNumber];
    
    NSManagedObjectContext *context = [[DataManager sharedManager] managedObjectContext];
    Purchase *newPurchase = [NSEntityDescription insertNewObjectForEntityForName:@"Purchase" inManagedObjectContext:context];
    
    newPurchase.date = myPurchase[0].purchaseDate;
    newPurchase.number = self.currentPurchaseNumber; // Could be edited by required logic
    
    for (MyPurchase *onePurchase in myPurchase) {
        ProductAmount *newProductAmount = [NSEntityDescription insertNewObjectForEntityForName:@"ProductAmount" inManagedObjectContext:context];
        newProductAmount.amount = (int) onePurchase.quantity;
        newProductAmount.purchase = newPurchase;
        newProductAmount.product = onePurchase.product;
    }
    
    [[DataManager sharedManager] saveContext];
    [self.currentBasket removeAllObjects];
}

- (void)generatePurchaseNumber {
    NSArray<Purchase *> *allPurchases = [self fetchAllPurchases];
    self.currentPurchaseNumber = allPurchases.count + 1;
}

// FETCHING all ProductAmounts
- (NSArray <ProductAmount *>*) fetchAllProductAmounts {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ProductAmount"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"amount" ascending:NO]];
    return [[[DataManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:nil];
}
// FETCHING all Purchases
- (NSArray <Purchase *>*) fetchAllPurchases {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Purchase"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"number" ascending:NO]];
    return [[[DataManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:nil];
}

//DELETE all Purchases
- (void)deleteAllPurchases:(NSArray<Purchase *> *) allPurchases {
    for (Purchase * onePurchase in allPurchases) {
        NSManagedObjectContext *context = [onePurchase managedObjectContext];
        [context deleteObject:onePurchase];
        [[DataManager sharedManager] saveContext];
    }
}
//DELETE all ProductAmounts
- (void)deleteAllProductAmounts:(NSArray<ProductAmount *> *) allProductAmounts {
    for (ProductAmount * oneProductAmount in allProductAmounts) {
        NSManagedObjectContext *context = [oneProductAmount managedObjectContext];
        [context deleteObject:oneProductAmount];
        [[DataManager sharedManager] saveContext];
    }
}

#pragma mark - REPORT

//FETCHING ProductAmounts after filter

- (NSArray <ProductAmount *>*) fetchProductAmountsByBarcode:(NSString *) barcode startDate:(NSDate *) startDate endDate:(NSDate *) endDate {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ProductAmount"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"ANY product.barcode LIKE[c] %@ AND (purchase.date >= %@) AND (purchase.date <= %@)",barcode,startDate,endDate];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"purchase.date" ascending:NO]];
    return [[[DataManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:nil];
}
- (NSArray <ProductAmount *>*) fetchProductAmountsByName:(NSString *) name startDate:(NSDate *) startDate endDate:(NSDate *) endDate {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ProductAmount"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"ANY product.name LIKE[c] %@ AND (purchase.date >= %@) AND (purchase.date <= %@)",name,startDate,endDate];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"purchase.date" ascending:NO]];
    return [[[DataManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:nil];
}
- (NSArray <ProductAmount *>*) fetchProductAmountsByPLU:(int) plu startDate:(NSDate *) startDate endDate:(NSDate *) endDate {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ProductAmount"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"ANY product.plu == %i AND (purchase.date >= %@) AND (purchase.date <= %@)",plu,startDate,endDate];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"purchase.date" ascending:NO]];
    return [[[DataManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:nil];
}
- (NSArray <ProductAmount *>*) fetchProductAmountsByStartDate:(NSDate *) startDate andEndDate:(NSDate *) endDate {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ProductAmount"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"ANY purchase.date >= %@ AND purchase.date <= %@",startDate,endDate];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"purchase.date" ascending:NO]];
    return [[[DataManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:nil];
}

#pragma mark - generating product DETAILS

- (NSDictionary *)generateAllProductsDetails {
    NSMutableDictionary *products = [[NSMutableDictionary alloc] init];
    NSArray *names = [[DataManager sharedManager] generateAllProductsNames];
    NSArray *prices = [[DataManager sharedManager] generateAllProductsPrices];
    NSArray *barcodes = [[DataManager sharedManager] generateAllProductsBarcodes];
    NSArray *PLUs = [[DataManager sharedManager] generateAllProductsPLUs];

    [products setObject:names forKey:@"names"];
    [products setObject:prices forKey:@"prices"];
    [products setObject:barcodes forKey:@"barcodes"];
    [products setObject:PLUs forKey:@"PLUs"];

    for (int i = 0; i < [names count]; i++) {
        NSLog(@"%i product \n name: %@ ;\n price: %@ ;\n barcode: %@ ;\n PLU: %@",i,[[products objectForKey:@"names"] objectAtIndex:i],[[products objectForKey:@"prices"] objectAtIndex:i],[[products objectForKey:@"barcodes"] objectAtIndex:i],[[products objectForKey:@"PLUs"] objectAtIndex:i] );
    } //  CHECKING generated products data
    
    return products;
}

- (NSArray *)generateAllProductsNames {
    NSMutableArray *names = [[NSMutableArray alloc] init];
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    for (int i = 0; i < productsCount; i++) {
        int nameLength = (arc4random()% 11) + 5;
        NSMutableString *randomString = [NSMutableString stringWithCapacity: nameLength];
        for (int j = 0; j < nameLength; j++) {
            [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random()%([letters length])]];
        }
        [names addObject:randomString];
//        NSLog(@"name-%i : %@",i,randomString);    //CHECKING
    }
    return names;
}

- (NSArray *)generateAllProductsPrices {
    NSMutableArray *prices = [[NSMutableArray alloc] init];
    for (int i = 0; i < productsCount; i++) {
        int finalPrice = 0;
        int randomPrice = (arc4random()%4991) + 10;
        if (!((randomPrice % 10) == 0)) {
            if ((randomPrice % 10) < 5) {
                finalPrice = (randomPrice / 10) * 10;
            } else {
                finalPrice = ((randomPrice / 10) + 1) * 10;
            }
        } else {
            finalPrice = randomPrice;
        }
        [prices addObject:[NSNumber numberWithInt:finalPrice]];
//        NSLog(@"price-%i : %i",i,finalPrice);     //CHECKING
    }
    return prices;
}

- (NSArray *)generateAllProductsBarcodes {
    NSMutableArray *barcodes = [[NSMutableArray alloc] init];
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    int barcodeLength = 13;
    int k = 1;
    BOOL isMatch = NO;
    for (int i = 0; i < productsCount; i++) {
        NSMutableString *randomString = [NSMutableString stringWithCapacity: barcodeLength];
        if (k == 10) {
            randomString = NULL;
            k = 1;
        } else {
            do {
                isMatch = NO;
                for (int j = 0; j < barcodeLength; j++) {
                    [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random()%([letters length])]];
                }
                for (int p = 0; p < [barcodes count]; p++) {
                    if ([randomString isEqualToString:barcodes[p]]) {
                        isMatch = YES;
                        break;
                    }
                }
            } while (isMatch);
            k += 1;
        }
        if (k == 1) {
            [barcodes addObject:[NSNull null]];
//            NSLog(@"barcode-%i : %@",i,randomString);     //CHECKING
        } else {
            [barcodes addObject:randomString];
//            NSLog(@"barcode-%i : %@",i,randomString);     //CHECKING
        }
    }
//    return barcodes;
    return [barcodes copy];

}

- (NSArray *)generateAllProductsPLUs {
    NSMutableArray *PLUs = [[NSMutableArray alloc] init];
    BOOL isMatch;
    int randomPLU;
    for (int i = 0; i < productsCount; i++) {
        NSNumber *finalPLU;
        do {
            isMatch = NO;
            randomPLU = (arc4random()%99999) + 1;
            for (int p = 0; p < [PLUs count]; p++) {
                if (PLUs[p] == [NSNumber numberWithInt:randomPLU]) {
                    isMatch = YES;
                    break;
                }
            }
        } while (isMatch);
        finalPLU = [NSNumber numberWithInt:randomPLU];
        [PLUs addObject:finalPLU];
//        NSLog(@"PLU-%i : %@",i,finalPLU);     //CHECKING
    }
    return PLUs;
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    return context;
}

- (NSPersistentContainer *)persistentContainer {

    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"TestStorage"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
