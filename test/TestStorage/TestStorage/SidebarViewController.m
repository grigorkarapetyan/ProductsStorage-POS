//
//  SidebarViewController.m
//  ProductsStorage
//
//  Created by Grigor Karapetyan on 1/16/17.
//  Copyright © 2017 Grigor Karapetyan. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "MenuTableViewCell.h"
#import "GeneratingViewController.h"

@interface SidebarViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (nonatomic) NSArray *menuSections;

@end

@implementation SidebarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.menuSections = @[@"All products",@"Purchase",@"Report",@"Generate"];
}

// TableView building
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuSections count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sectionCell" forIndexPath:indexPath];
    cell.sectionLabel.text = [self.menuSections objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger index = indexPath.row;
    NSString *viewSegue = self.menuSections[index];
    
    [self performSegueWithIdentifier:viewSegue sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"All products"]) {
//        GeneratingViewController *generateVC = [segue destinationViewController];
//    };
}
@end
