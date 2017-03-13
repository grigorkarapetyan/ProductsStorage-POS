//
//  ProductsListViewController.m
//  TestStorage
//
//  Created by Grigor Karapetyan on 1/29/17.
//  Copyright © 2017 Grigor Karapetyan. All rights reserved.
//

#import "ProductsListViewController.h"
#import "SWRevealViewController.h"
#import "ProductTableViewCell.h"
#import "DataManager.h"
#import "EditViewController.h"

@interface ProductsListViewController () <UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *productsTableView;
@property (weak, nonatomic) IBOutlet UIPickerView *filterPicker;
@property (nonatomic,copy) NSArray<Product *> *allProducts;
@property (nonatomic,copy) NSArray *filterValues;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation ProductsListViewController

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

    self.allProducts = [[DataManager sharedManager] fetchAllProducts];
    self.filterValues = @[@"by name",@"by PLU",@"by barcode"];
    
    self.productsTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)viewDidAppear:(BOOL)animated {
    [[DataManager sharedManager] setEditingRequest:NO];
    if ([self.searchTextField.text isEqualToString:@""]) {
        [self reload];
    } else {
        [self startToSearch:nil];
    }
}
// TABLE VIEW building

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allProducts count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productCell" forIndexPath:indexPath];
    
    cell.productName.text = [self.allProducts[indexPath.row] name];
    cell.productBarcode.text = [self.allProducts[indexPath.row] barcode];
    NSString *price = [NSString stringWithFormat:@"%d",[self.allProducts[indexPath.row] price]];
    cell.productPrice.text = price;
    NSString *plu = [NSString stringWithFormat:@"%d",[self.allProducts[indexPath.row] plu]];
    cell.productPLU.text = plu;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger index = indexPath.row;
    Product *testProduct = self.allProducts[index];
    [[DataManager sharedManager] setSelectedProduct:testProduct];
    [[DataManager sharedManager] setEditingRequest:YES];
    [[DataManager sharedManager] setCurrentProducts:self.allProducts];
    [self performSegueWithIdentifier:@"editView" sender:nil];
    
}

//PICKER VIEW building
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.filterValues objectAtIndex:row];
}

//ADDING/EDITING product
- (IBAction)addNewProduct:(id)sender {
    [[DataManager sharedManager] setCurrentProducts:self.allProducts];
    [self performSegueWithIdentifier:@"editView" sender:nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editView"]) {
//        EditViewController *editVC = [segue destinationViewController];
//        [[DataManager sharedManager] setEditingRequest:NO];
    };
}

//  DELETING product
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSInteger index = indexPath.row;
        Product *deletedProduct = self.allProducts[index];
        [[DataManager sharedManager] deleteProduct:deletedProduct];
        [self reload];
    }
}

- (void)reload {
    self.allProducts = [[DataManager sharedManager] fetchAllProducts];
    [self.productsTableView reloadData];
}

//SEARCHING with filter
- (IBAction)startToSearch:(id)sender {
    if([self.searchTextField.text isEqualToString:@""]) {
        [self reload];
    } else {
        NSString *searchText = self.searchTextField.text;
        if ([self.filterPicker selectedRowInComponent:0] == 0) {
            self.allProducts = [[DataManager sharedManager] fetchProductsByName:searchText];
        } else if ([self.filterPicker selectedRowInComponent:0] == 1) {
            self.allProducts = [[DataManager sharedManager] fetchProductsByPLUContains:[searchText intValue]];
        } else {
            self.allProducts = [[DataManager sharedManager] fetchProductsByBarcode:searchText];
        }
        NSLog(@"all filtered products are %@",self.allProducts);
        [self.productsTableView reloadData];
    }
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
