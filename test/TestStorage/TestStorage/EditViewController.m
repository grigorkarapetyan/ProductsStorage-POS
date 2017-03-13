//
//  EditViewController.m
//  TestStorage
//
//  Created by Grigor Karapetyan on 1/31/17.
//  Copyright © 2017 Grigor Karapetyan. All rights reserved.
//

#import "EditViewController.h"
#import "DataManager.h"
#import "MyProduct.h"
@interface EditViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *pluTextField;
@property (weak, nonatomic) IBOutlet UITextField *barcodeTextField;
@property (nonatomic) Product *product;
@property (nonatomic) BOOL somthingEdited;
@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Back"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem = cancelButton;
    
    if ([DataManager sharedManager].editingRequest) {
        self.product = [[DataManager sharedManager] selectedProduct];
        self.nameTextField.text = self.product.name;
        NSString *price = [NSString stringWithFormat:@"%d",self.product.price];
        self.priceTextField.text = price;
        NSString *plu = [NSString stringWithFormat:@"%d",self.product.plu];
        self.pluTextField.text = plu;
        self.barcodeTextField.text = self.product.barcode;
        
    }
}

- (IBAction)savingProduct:(id)sender {
    if ([DataManager sharedManager].editingRequest) {
        if (self.somthingEdited) {
            if ([self validationCondition]) { //details validation
                [[[DataManager sharedManager] selectedProduct] setName:self.nameTextField.text];
                [[[DataManager sharedManager] selectedProduct] setBarcode:self.barcodeTextField.text];
                [[[DataManager sharedManager] selectedProduct] setPlu:[self.pluTextField.text intValue]];
                [[[DataManager sharedManager] selectedProduct] setPrice:[self.priceTextField.text intValue]];

                [[DataManager sharedManager] editSelectedProduct];
                [self completionAlertWithTitle:@"Completed" andMessage:@"Product was successfully edited"];
            }
        }
        
    } else {
        if (self.somthingEdited) {
            if ([self validationCondition]) { //details validation
                
                MyProduct *newProduct = [[MyProduct alloc] init];
                newProduct.productName = self.nameTextField.text;
                newProduct.productBarcode = self.barcodeTextField.text;
                newProduct.productPrice = [self.priceTextField.text intValue];
                newProduct.productPLU = [self.pluTextField.text intValue];
                [[DataManager sharedManager] addOneProduct:newProduct];
                [self prepareForNextAddition];
            }
        }
    }
}
- (void)prepareForNextAddition {
    self.nameTextField.text = @"";
    self.barcodeTextField.text = @"";
    self.priceTextField.text = @"";
    self.pluTextField.text = @"";

    [self completionAlertWithTitle:@"Completed" andMessage:@"New product was successfully added"];
    NSArray<Product *> *allProducts = [[DataManager sharedManager] fetchAllProducts];
    [[DataManager sharedManager] setCurrentProducts:allProducts];
}

// VALIDATION conditions
- (BOOL)validationCondition { 
    if ([self.nameTextField.text isEqualToString:@""] || [self.priceTextField.text isEqualToString:@""] || [self.pluTextField.text isEqualToString:@""]) {
        NSString *alertMessage = @"Name, Price and PLU are required fields";
        [self validationAlert:alertMessage];
        return NO;
    } else if (![self priceValidation]) {
        NSString *alertMessage = @"Wrong product price";
        [self validationAlert:alertMessage];
        return NO;
    } else if (![self pluValidation]) {
        NSString *alertMessage = @"PLU must be unique and numeric";
        [self validationAlert:alertMessage];
        return NO;
    } else if (![self barcodeValidation]) {
        NSString *alertMessage = @"Barcode must be unique and alphanumeric";
        [self validationAlert:alertMessage];
        return NO;
    } else {

    return YES;
    }
}
- (void)validationAlert:(NSString *) message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Wrong data"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)completionAlertWithTitle:(NSString *) title andMessage:(NSString *) message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}
- (BOOL)barcodeValidation {
    NSString *barcode = self.barcodeTextField.text;
    if (![self alphanumericValidation:barcode] && ![barcode isEqualToString:@""]) {
        return NO;
    }
    NSArray<Product *> *allProducts = [[DataManager sharedManager] currentProducts];
    for (Product *product in allProducts) {
        if ([barcode isEqualToString:product.barcode] && ![barcode isEqualToString:@""] && ![barcode isEqualToString:self.product.barcode]) {
            return NO;
        }
    }
    return YES;
}
- (BOOL)pluValidation {
    if (![self numericValidation:self.pluTextField.text]) {
        return NO;
    }
    NSInteger plu = [self.pluTextField.text intValue];
    NSArray<Product *> *allProducts = [[DataManager sharedManager] currentProducts];
    for (Product *product in allProducts) {
        if ( plu == product.plu && plu != self.product.plu) {
            return NO;
        }
    }
    return YES;
}
- (BOOL)priceValidation {
    if (![self numericValidation:self.priceTextField.text]) {
        return NO;
    }
    if ([self.priceTextField.text intValue] <= 0) {
        return NO;
    }
        
    return YES;
}
- (BOOL)numericValidation:(NSString *)pluTest {
    NSString *valueRegex = @"^([+-]?)(?:|0|[1-9]\\d*)?$";
    NSPredicate *numericTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", valueRegex];
    return [numericTest evaluateWithObject:pluTest];
}
- (BOOL)alphanumericValidation:(NSString *)barcodeTest {
    NSString *valueRegex = @"[a-zA-Z0-9]*";
    NSPredicate *alphanumericTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", valueRegex];
    return [alphanumericTest evaluateWithObject:barcodeTest];
}

- (IBAction)editingInfoChanged:(id)sender {
    self.somthingEdited = YES;

}
//.....
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return  YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

@end
