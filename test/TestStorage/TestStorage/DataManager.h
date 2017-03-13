//
//  DataManager.h
//  ProductsStorage
//
//  Created by Grigor Karapetyan on 1/9/17.
//  Copyright © 2017 Grigor Karapetyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Product+CoreDataClass.h"
#import "ProductAmount+CoreDataClass.h"
#import "Purchase+CoreDataClass.h"
#import "MyProduct.h"
#import "MyPurchase.h"

@class MyPurchase;

@interface DataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic) BOOL editingRequest;
@property (nonatomic) Product *selectedProduct;
@property (nonatomic,copy) NSArray<Product *> *currentProducts;
@property (nonatomic) NSMutableArray<MyPurchase *> *currentBasket;
@property (nonatomic) NSInteger currentPurchaseNumber;


- (NSDictionary *)generateAllProductsDetails ;
- (NSArray *)generateAllProductsNames ;
- (NSArray *)generateAllProductsPrices ;
- (NSArray *)generateAllProductsBarcodes ;
- (NSArray *)generateAllProductsPLUs ;

- (void)generateProducts ;
- (void)deleteAllProducts:(NSArray<Product *> *) allProducts ;
- (void)deleteProduct:(Product *) product ;
- (void)editSelectedProduct ;
- (void)addOneProduct:(MyProduct *) product ;

- (NSArray <Product *>*) fetchAllProducts ;
- (NSArray <Product *>*) fetchProductsByName:(NSString *) name ;
- (NSArray <Product *>*) fetchProductsByBarcode:(NSString *) barcode ;
- (NSArray <Product *>*) fetchProductsByFullBarcode:(NSString *) barcode ;
- (NSArray <Product *>*) fetchProductsByPLUContains:(int) plu ;
- (NSArray <Product *>*) fetchProductsByPLU:(int) plu ;
- (NSArray <ProductAmount *>*) fetchProductAmountsByBarcode:(NSString *) barcode startDate:(NSDate *) startDate endDate:(NSDate *) endDate ;
- (NSArray <ProductAmount *>*) fetchProductAmountsByName:(NSString *) name startDate:(NSDate *) startDate endDate:(NSDate *) endDate ;
- (NSArray <ProductAmount *>*) fetchProductAmountsByPLU:(int) plu startDate:(NSDate *) startDate endDate:(NSDate *) endDate ;
- (NSArray <ProductAmount *>*) fetchProductAmountsByStartDate:(NSDate *) startDate andEndDate:(NSDate *) endDate ;

- (void)addProductToBasket:(MyPurchase *) purchase ;
- (void)deleteProductFromBasket:(NSInteger) index ;

- (void)purchaseRegister:(NSArray <MyPurchase *>*) myPurchase ;
- (NSArray <ProductAmount *>*) fetchAllProductAmounts ;
- (NSArray <Purchase *>*) fetchAllPurchases ;
- (void)deleteAllPurchases:(NSArray<Purchase *> *) allPurchases ;
- (void)deleteAllProductAmounts:(NSArray<ProductAmount *> *) allProductAmounts ;

// Core data part
+ (instancetype)sharedManager;

- (NSManagedObjectContext *)managedObjectContext ;

- (void)saveContext;

@end
