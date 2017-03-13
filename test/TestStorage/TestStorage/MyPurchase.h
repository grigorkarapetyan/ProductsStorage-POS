//
//  MyPurchase.h
//  TestStorage
//
//  Created by Grigor Karapetyan on 3/1/17.
//  Copyright © 2017 Grigor Karapetyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

@interface MyPurchase : NSObject
@property (nonatomic) Product *product;
@property (nonatomic,copy) NSDate *purchaseDate;
@property (nonatomic) NSInteger quantity;
@property (nonatomic,copy) NSNumber *purchaseNumber;

@end
