//
//  Product+CoreDataProperties.m
//  TestStorage
//
//  Created by Grigor Karapetyan on 1/24/17.
//  Copyright © 2017 Grigor Karapetyan. All rights reserved.
//

#import "Product+CoreDataProperties.h"

@implementation Product (CoreDataProperties)

+ (NSFetchRequest<Product *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Product"];
}

@dynamic name;
@dynamic price;
@dynamic barcode;
@dynamic plu;
@dynamic image;
@dynamic quantity;
@dynamic amount;

@end
