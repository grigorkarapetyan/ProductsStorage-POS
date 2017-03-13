//
//  ProductTableViewCell.h
//  TestStorage
//
//  Created by Grigor Karapetyan on 1/30/17.
//  Copyright © 2017 Grigor Karapetyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) IBOutlet UILabel *productPLU;
@property (weak, nonatomic) IBOutlet UILabel *productBarcode;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;

@end
