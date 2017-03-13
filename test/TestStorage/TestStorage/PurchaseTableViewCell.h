//
//  PurchaseTableViewCell.h
//  TestStorage
//
//  Created by Grigor Karapetyan on 3/2/17.
//  Copyright © 2017 Grigor Karapetyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productQuantityLabel;

@end
