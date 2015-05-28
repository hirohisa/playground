//
//  ViewController.m
//  Hybrid
//
//  Created by Hirohisa Kawasaki on 4/25/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

#import "ViewController.h"
#import "ReactViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = @"React ViewController";

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UIViewController *viewController = [[ReactViewController alloc] initWithNibName:@"ReactViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
