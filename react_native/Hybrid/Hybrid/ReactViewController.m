//
//  ReactViewController.m
//  Hybrid
//
//  Created by Hirohisa Kawasaki on 4/25/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

#import "ReactViewController.h"
#import "RCTRootView.h"

@interface ReactView : UIView

@property (nonatomic, strong) RCTRootView *view;
@end

@implementation ReactView

- (void)awakeFromNib {

    NSURL *URL = [NSURL URLWithString:@"http://localhost:8081/index.ios.bundle"];
    self.view = [[RCTRootView alloc] initWithBundleURL:URL
                                            moduleName:@"SimpleApp"
                                         launchOptions:nil];

}


@end

@interface ReactViewController ()

@property (nonatomic, weak) IBOutlet ReactView *reactView;

@end

@implementation ReactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
