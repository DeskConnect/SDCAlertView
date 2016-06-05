//
//  SDCTextFieldsViewController.m
//  SDCAlertView
//
//  Created by Ari on 5/29/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCTextFieldsViewController.h"
#import "SDCTextFieldCell.h"

static NSString * const SDCTextFieldCellIdentifier = @"textFieldCell";

@interface SDCTextFieldsViewController () <UITableViewDataSource>

@property (nonatomic, copy) NSArray<UITextField *> *textFields;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SDCTextFieldsViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithNibName:nil bundle:nil];
    if (!self)
        return nil;
    
    _textFields = @[];
    
    return self;
}

- (instancetype)initWithTextFields:(NSArray<UITextField *> *)textFields {
    self = [super initWithNibName:nil bundle:nil];
    if (!self)
        return nil;
    
    _textFields = [textFields copy];
    
    return self;
}

- (void)loadView {
    NSString *nibName = NSStringFromClass([SDCTextFieldCell class]);
    UINib *cellNib = [UINib nibWithNibName:nibName bundle:[NSBundle bundleForClass:[self class]]];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:SDCTextFieldCellIdentifier];
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    
    self.view = self.tableView;
}

- (CGFloat)requiredHeight {
    return (self.tableView.rowHeight * (CGFloat)[self.tableView numberOfRowsInSection:0]);
}

- (void)setVisualStyle:(SDCAlertVisualStyle *)visualStyle {
    _visualStyle = visualStyle;
    if (visualStyle)
        self.tableView.rowHeight = visualStyle.textFieldHeight;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.textFields.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SDCTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:SDCTextFieldCellIdentifier forIndexPath:indexPath];
    cell.textField = self.textFields[indexPath.row];
    cell.visualStyle = self.visualStyle;
    return cell;
}

@end
