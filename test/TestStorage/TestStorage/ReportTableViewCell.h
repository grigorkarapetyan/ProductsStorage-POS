//
//  ReportTableViewCell.h
//  TestStorage
//
//  Created by Grigor Karapetyan on 3/6/17.
//  Copyright © 2017 Grigor Karapetyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *barcodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pluLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *chequeNumberLabel;

@end
