//
//  Product+CoreDataProperties.h
//  TestStorage
//
//  Created by Grigor Karapetyan on 1/24/17.
//  Copyright © 2017 Grigor Karapetyan. All rights reserved.
//

#import "Product+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Product (CoreDataProperties)

+ (NSFetchRequest<Product *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int32_t price;
@property (nullable, nonatomic, copy) NSString *barcode;
@property (nonatomic) int32_t plu;
@property (nullable, nonatomic, retain) NSData *image;
@property (nonatomic) int16_t quantity;
@property (nullable, nonatomic, retain) NSSet<ProductAmount *> *amount;

@end

@interface Product (CoreDataGeneratedAccessors)

- (void)addAmountObject:(ProductAmount *)value;
- (void)removeAmountObject:(ProductAmount *)value;
- (void)addAmount:(NSSet<ProductAmount *> *)values;
- (void)removeAmount:(NSSet<ProductAmount *> *)values;

@end

NS_ASSUME_NONNULL_END
