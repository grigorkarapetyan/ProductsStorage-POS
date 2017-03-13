//
//  ProductAmount+CoreDataClass.h
//  TestStorage
//
//  Created by Grigor Karapetyan on 1/24/17.
//  Copyright © 2017 Grigor Karapetyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Product, Purchase;

NS_ASSUME_NONNULL_BEGIN

@interface ProductAmount : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "ProductAmount+CoreDataProperties.h"
