//
//  MyProduct.h
//  TestStorage
//
//  Created by Grigor Karapetyan on 2/5/17.
//  Copyright © 2017 Grigor Karapetyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyProduct : NSObject
@property (nonatomic,copy) NSString *productName;
@property (nonatomic,copy) NSString *productBarcode;
@property (nonatomic) NSInteger productPrice;
@property (nonatomic) NSInteger productPLU;
@property (nonatomic,copy) NSData *prpductImage;
@property (nonatomic) NSInteger productQuantity;

@end
