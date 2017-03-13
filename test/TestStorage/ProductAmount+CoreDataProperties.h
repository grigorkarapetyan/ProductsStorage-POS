//
//  ProductAmount+CoreDataProperties.h
//  TestStorage
//
//  Created by Grigor Karapetyan on 1/24/17.
//  Copyright © 2017 Grigor Karapetyan. All rights reserved.
//

#import "ProductAmount+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ProductAmount (CoreDataProperties)

+ (NSFetchRequest<ProductAmount *> *)fetchRequest;

@property (nonatomic) int16_t amount;
@property (nullable, nonatomic, retain) Product *product;
@property (nullable, nonatomic, retain) Purchase *purchase;

@end

NS_ASSUME_NONNULL_END
