//
//  ViewController.m
//  IMMapAroundUsers
//
//  Created by mac on 15/4/23.
//  Copyright (c) 2015年 IMSDK. All rights reserved.
//

#import "ViewController.h"
#import "IMLoginView.h"
#import "MapAroundUsersViewController.h"

@interface ViewController () <IMLoginViewDelegate>

@end

@implementation ViewController {
    IMLoginView *_loginView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _loginView = [[IMLoginView alloc] initWithFrame:self.view.bounds];
    
    [_loginView setType:IMLoginViewFunctionTypeDefault];
    [_loginView setDelegate:self];
    [[self view] addSubview:_loginView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_loginView viewWillAppear];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginViewDidLogin:(BOOL)autoLogin {
    MapAroundUsersViewController *controller = [[MapAroundUsersViewController alloc] init];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)loginViewLoginFailedWithError:(NSString *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登陆失败" message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles:  nil];
    
    [alertView show];
}

@end
