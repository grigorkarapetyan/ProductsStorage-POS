//
//  ProductAmount+CoreDataProperties.m
//  TestStorage
//
//  Created by Grigor Karapetyan on 1/24/17.
//  Copyright © 2017 Grigor Karapetyan. All rights reserved.
//

#import "ProductAmount+CoreDataProperties.h"

@implementation ProductAmount (CoreDataProperties)

+ (NSFetchRequest<ProductAmount *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ProductAmount"];
}

@dynamic amount;
@dynamic product;
@dynamic purchase;

@end
