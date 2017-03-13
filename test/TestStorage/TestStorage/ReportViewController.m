//
//  ReportViewController.m
//  TestStorage
//
//  Created by Grigor Karapetyan on 3/5/17.
//  Copyright © 2017 Grigor Karapetyan. All rights reserved.
//

#import "ReportViewController.h"
#import "SWRevealViewController.h"
#import "DataManager.h"
#import "ReportTableViewCell.h"

@interface ReportViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *fromDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *toDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *filterPickerView;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UITableView *reportTableView;
@property (nonatomic) NSDateFormatter *formatter;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic) UITextField *chosedTextField;
@property (nonatomic,copy) NSArray *filterValues;
@property (nonatomic,copy) NSArray<ProductAmount *> *findProducts;
@property (nonatomic) BOOL startDayCheck;

@end

@implementation ReportViewController

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
    self.filterValues = @[@"search by PLU",@"search by barcode",@"search by name"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    self.formatter = formatter;
    self.startDate = [self.formatter dateFromString:@"01-01-2000"];
    self.endDate = [NSDate date];
    self.startDayCheck = YES;

    self.searchTextField.delegate = self;
    self.reportTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}


- (void)showTotalDetails {
    NSInteger totalAmount = 0;
    NSInteger totalCount = 0;
    for (ProductAmount *oneProduct in self.findProducts) {
        totalAmount = totalAmount + ([[oneProduct product] price] * [oneProduct amount]);
        totalCount = totalCount + [oneProduct amount];
    }
    self.totalCountLabel.text = [NSString stringWithFormat:@"%ld", (long)totalCount];
    self.totalAmountLabel.text = [ NSString stringWithFormat:@"%ld", (long)totalAmount];

}

// TABLE VIEW building
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.findProducts count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reportCell" forIndexPath:indexPath];
    
    NSString *name = [[[self.findProducts objectAtIndex:indexPath.row] product] name];
    NSString *barcode = [[[self.findProducts objectAtIndex:indexPath.row] product] barcode];
    NSDate *purchaseDate = [[[self.findProducts objectAtIndex:indexPath.row] purchase] date];
    NSInteger price = [[[self.findProducts objectAtIndex:indexPath.row] product] price];
    NSInteger plu = [[[self.findProducts objectAtIndex:indexPath.row] product] plu];
    NSInteger quantity = [[self.findProducts objectAtIndex:indexPath.row] amount];
    NSInteger chequeNumber = [[[self.findProducts objectAtIndex:indexPath.row] purchase] number];
    cell.nameLabel.text = name;
    cell.barcodeLabel.text = barcode;
    cell.dateLabel.text = [self.formatter stringFromDate:purchaseDate];
    cell.priceLabel.text = [NSString stringWithFormat:@"%ld",(long)price];
    cell.pluLabel.text = [NSString stringWithFormat:@"%ld",(long)plu];
    cell.quantityLabel.text = [NSString stringWithFormat:@"%ld",(long)quantity];
    cell.chequeNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)chequeNumber];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)reload {
    [self.reportTableView reloadData];
    [self showTotalDetails];
}

//SEARCH sold products
- (IBAction)searchByFilters:(id)sender {
    if (![self.searchTextField.text isEqualToString:@""]){
        NSString *searchParameter = self.searchTextField.text;
        switch ([self.filterPickerView selectedRowInComponent:0]) {
            case 0:
                self.findProducts = [[DataManager sharedManager] fetchProductAmountsByPLU:[searchParameter intValue] startDate:self.startDate endDate:self.endDate];
                break;
            case 1:
                self.findProducts = [[DataManager sharedManager] fetchProductAmountsByBarcode:searchParameter startDate:self.startDate endDate:self.endDate];
                break;
            case 2:
                self.findProducts = [[DataManager sharedManager] fetchProductAmountsByName:searchParameter startDate:self.startDate endDate:self.endDate];
                break;
            default:
                break;
        }
        if (self.findProducts.count != 0) {
            NSLog(@"amount: %hd",self.findProducts[0].amount);
            [self reload];
        } else {
            NSLog(@"no purchases by this filter");
            [self reload];
        }

    } else {
        self.findProducts = [[DataManager sharedManager] fetchProductAmountsByStartDate:self.startDate andEndDate:self.endDate];
        if (self.findProducts.count != 0) {
            NSLog(@"amount: %hd",self.findProducts[0].amount);
            [self reload];
        } else {
            NSLog(@"no purchases by this filter");
            [self reload];
        }
    }
}


//DATEPICKERs implementations
- (IBAction)dateEditingDidBegin:(id)sender {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(datePickerDateChanged:) forControlEvents:UIControlEventValueChanged];

    self.chosedTextField = sender;
    self.chosedTextField.inputView = datePicker;

    if ([self.chosedTextField isEqual:self.toDateTextField]){
        datePicker.date = self.endDate;
    } else if (self.startDayCheck) {
        datePicker.date = [NSDate date];
    } else {
        datePicker.date = self.startDate;
    }
}
- (IBAction)dateEditingDidEnd:(id)sender {
    if ([self.chosedTextField isEqual:self.fromDateTextField]) {
        self.fromDateTextField.text = [self.formatter stringFromDate:self.startDate];
    } else {
        self.toDateTextField.text = [self.formatter stringFromDate:self.endDate];
    }
}
- (void) datePickerDateChanged:(UIDatePicker *)datePicker{
    
    if ([self.chosedTextField isEqual:self.fromDateTextField]) {
        self.fromDateTextField.text = [self.formatter stringFromDate:datePicker.date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:datePicker.date];
        [components setHour:0];
        [components setMinute:0];
        [components setSecond:0];
        self.startDate = [calendar dateFromComponents:components];
        self.startDayCheck = NO;
    } else {
        self.toDateTextField.text = [self.formatter stringFromDate:datePicker.date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:datePicker.date];
        [components setHour:23];
        [components setMinute:59];
        [components setSecond:59];
        self.endDate = [calendar dateFromComponents:components];
    }
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
//.....
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.searchTextField) {
        [self searchByFilters:nil];
    }
    return  YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

@end





