//
//  PurchaseViewController.m
//  TestStorage
//
//  Created by Grigor Karapetyan on 2/21/17.
//  Copyright © 2017 Grigor Karapetyan. All rights reserved.
//

#import "PurchaseViewController.h"
#import "SWRevealViewController.h"
#import "DataManager.h"
#import "MyPurchase.h"

@interface PurchaseViewController () <UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *pluLabel;
@property (weak, nonatomic) IBOutlet UILabel *barcodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITextField *findTextField;
@property (nonatomic,copy) NSArray<Product *> *findProducts;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *filterPickerView;
@property (nonatomic,copy) NSArray *filterValues;
@property (nonatomic) Product *product;
@property (nonatomic) NSInteger productQuantity;

@end

@implementation PurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
// ADDING reveal part
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sideBarButton setTarget: self.revealViewController];
        [self.sideBarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
// -----------------------------------

    self.findTextField.delegate = self;
    [self noFindProduct];
    self.filterValues = @[@"by PLU",@"by barcode"];
    self.productQuantity = 1;
    self.quantityTextField.text = [NSString stringWithFormat:@"%ld",(long)self.productQuantity];
    
    self.addButton.showsTouchWhenHighlighted = YES;
}
- (void)viewDidAppear:(BOOL)animated {
//    [self noFindProduct];
}

//PICKER VIEW building
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 2;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.filterValues objectAtIndex:row];
}

- (IBAction)findProduct {
    if (![self.findTextField.text isEqualToString:@""]){
        NSString *searchParameter = self.findTextField.text;
        if ([self.filterPickerView selectedRowInComponent:0] == 0) {
            self.findProducts = [[DataManager sharedManager] fetchProductsByPLU:[searchParameter intValue]];
        } else {
            self.findProducts = [[DataManager sharedManager] fetchProductsByFullBarcode:searchParameter];
        }
        if ([self.findProducts count] == 0)  {
            NSLog(@"no any product find");
            [self noFindProduct];
        } else{
            self.nameLabel.text = [[self.findProducts objectAtIndex:0] name];
            self.pluLabel.text = [NSString stringWithFormat:@"%d",[self.findProducts[0] plu]];
            self.priceLabel.text = [NSString stringWithFormat:@"%d",[self.findProducts[0] price]];
            self.barcodeLabel.text = [[self.findProducts objectAtIndex:0] barcode];
            self.product = [self.findProducts objectAtIndex:0];
        }
    } else {
        NSLog(@"no title for searching");
        [self noFindProduct];
    }
}
- (void)noFindProduct {
    self.nameLabel.text = @"";
    self.pluLabel.text = @"";
    self.priceLabel.text = @"";
    self.barcodeLabel.text = @"";
    self.product = nil;
}
- (IBAction)addQuantity {
    self.productQuantity ++;
    self.quantityTextField.text = [NSString stringWithFormat:@"%ld",(long)self.productQuantity];
}
- (IBAction)reduceQuantity {
    if (self.productQuantity >= 2) {
        self.productQuantity --;
        self.quantityTextField.text = [NSString stringWithFormat:@"%ld",(long)self.productQuantity];
    }
}

- (IBAction)quantityChanged {
//....
}

- (IBAction)quantityEditingDidEnd {
    if (![self quantityValidation:self.quantityTextField.text] || [self.quantityTextField.text isEqualToString:@""]) {
        [self quantityValidationAlert];
        self.productQuantity = 1;
        self.quantityTextField.text = [NSString stringWithFormat:@"%ld",(long)self.productQuantity];
    } else {
        self.productQuantity = [self.quantityTextField.text intValue];
        self.quantityTextField.text = [NSString stringWithFormat:@"%ld",(long)self.productQuantity];
    }
}

- (BOOL)quantityValidation:(NSString *)quantity {
    NSString *quantityRegex = @"^([+-]?)(?:|0|[1-9]\\d*)?$";
    NSPredicate *quantityTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", quantityRegex];
    return [quantityTest evaluateWithObject:quantity];
}
- (void)quantityValidationAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid quantity"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)addToBasket {
    if (self.product) {

        MyPurchase *purchaseForAdd = [[MyPurchase alloc] init];
        purchaseForAdd.product = self.product;
        purchaseForAdd.quantity = self.productQuantity;
        purchaseForAdd.purchaseDate = [NSDate date];
        NSLog(@"%@ and \n quantity:%ld",purchaseForAdd.product,(long)purchaseForAdd.quantity);
        [[DataManager sharedManager] addProductToBasket:purchaseForAdd];

    } else {
        NSLog(@"no product to add");
    }
}

- (IBAction)goToPurchaseBasket:(id)sender {
    
    [self performSegueWithIdentifier:@"basketView" sender:nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"basketView"]) {
        //.......
    };
}

//.....
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.findTextField) {
        [self findProduct];
    }
    return  YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


@end
