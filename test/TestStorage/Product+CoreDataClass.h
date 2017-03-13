//
//  Product+CoreDataClass.h
//  TestStorage
//
//  Created by Grigor Karapetyan on 1/24/17.
//  Copyright © 2017 Grigor Karapetyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProductAmount;

NS_ASSUME_NONNULL_BEGIN

@interface Product : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Product+CoreDataProperties.h"
