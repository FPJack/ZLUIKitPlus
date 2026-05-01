//
//  ZLViewController.m
//  ZLUIKitPlus
//
//  Created by fanpeng on 04/24/2026.
//  Copyright (c) 2026 fanpeng. All rights reserved.
//

#import "ZLViewController.h"
#import <ZLUIKitPlus/ZLUIKitPlus.h>
#import "ZLButtonDemoVC.h"
#import "ZLImageViewDemoVC.h"
#import "ZLLabelDemoVC.h"
#import "ZLPairViewDemoVC.h"
#import "ZLTagListViewDemoVC.h"

@interface ZLViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray<NSDictionary *> *demos;
@end

@implementation ZLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZLUIKitPlus Demos";
    self.view.backgroundColor = UIColor.whiteColor;
//    return;
    {
        UIStackView *stack = UIStackView.new;
//        stack.axis = UILayoutConstraintAxisVertical;
//        [self.view addSubview:stack];
//        stack.backgroundColor = UIColor.lightGrayColor;
//        stack.KFC.width(200);
//        stack.KFC.center();
        
        UILabel *lab1 = UILabel.new;
        lab1.text = @"Hello";
        [stack addArrangedSubview:lab1];
        
        UIButton *btn = UIButton.new;
        [btn setTitle:@"World" forState:UIControlStateNormal];
        [stack addArrangedSubview:btn];
        
        UIImageView *imgView = UIImageView.new;
        imgView.image = [UIImage systemImageNamed:@"star"];
        [stack addArrangedSubview:imgView];
        
        UITextField *textField = UITextField.new;
        textField.placeholder = @"Input";
        textField.text = @"ZLUIKitPlus";
        [stack addArrangedSubview:textField];
        
        UISwitch *switchView = UISwitch.new;
        switchView.on = YES;
        [stack addArrangedSubview:switchView];
        
        UITextView *textView = UITextView.new;
        textView.text = @"This is a UITextView.";
        [stack addArrangedSubview:textView];
        
    }
    
    
    
//    return;
    
    self.demos = @[
        @{@"title": @"ZLButton Demo", @"class": ZLButtonDemoVC.class},
        @{@"title": @"ZLImageView Demo", @"class": ZLImageViewDemoVC.class},
        @{@"title": @"ZLLabel Demo", @"class": ZLLabelDemoVC.class},
        @{@"title": @"ZLPairView Demo", @"class": ZLPairViewDemoVC.class},
        @{@"title": @"ZLTagListView Demo", @"class": ZLTagListViewDemoVC.class},
    ];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    tableView.KFC.edgesZero();
    
  
   
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.demos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.demos[indexPath.row][@"title"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Class cls = self.demos[indexPath.row][@"class"];
    UIViewController *vc = [[cls alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
