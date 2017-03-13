//
//  Purchase+CoreDataProperties.m
//  TestStorage
//
//  Created by Grigor Karapetyan on 1/24/17.
//  Copyright © 2017 Grigor Karapetyan. All rights reserved.
//

#import "Purchase+CoreDataProperties.h"

@implementation Purchase (CoreDataProperties)

+ (NSFetchRequest<Purchase *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Purchase"];
}

@dynamic date;
@dynamic number;
@dynamic amount;

@end
