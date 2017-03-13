//
//  Purchase+CoreDataProperties.h
//  TestStorage
//
//  Created by Grigor Karapetyan on 1/24/17.
//  Copyright © 2017 Grigor Karapetyan. All rights reserved.
//

#import "Purchase+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Purchase (CoreDataProperties)

+ (NSFetchRequest<Purchase *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *date;
@property (nonatomic) int16_t number;
@property (nullable, nonatomic, retain) NSSet<ProductAmount *> *amount;

@end

@interface Purchase (CoreDataGeneratedAccessors)

- (void)addAmountObject:(ProductAmount *)value;
- (void)removeAmountObject:(ProductAmount *)value;
- (void)addAmount:(NSSet<ProductAmount *> *)values;
- (void)removeAmount:(NSSet<ProductAmount *> *)values;

@end

NS_ASSUME_NONNULL_END
