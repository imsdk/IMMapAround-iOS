//
//  UserInfoController.m
//  IMMapAroundUsers
//
//  Created by mac on 15/4/23.
//  Copyright (c) 2015年 IMSDK. All rights reserved.
//

#import "UserInfoController.h"
#import "UIView+IM.h"
#import "IMSDK+Nickname.h"
#import "IMSDK+MainPhoto.h"
#import "IMSDK+CustomUserInfo.h"
#import "IMMyself+Nickname.h"
#import "IMMyself.h"

@interface UserInfoController()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@end

@implementation UserInfoController {
    UITableView *_tableView;
    
    UIView *_tableHeaderView;
    UIImageView *_headView;
    UILabel *_userNameLabel;
    UILabel *_customUserIDLabel;
    UIImageView *_sexImageView;
    
    UIView *_tableFooterView;
    UIButton *_removeBlacklistBtn;
    UIButton *_chatBtn;
    UIButton *_sendFriendsRequestBtn;
    UIButton *_removeFriendsBtn;
    
    UIBarButtonItem *_rightBarButtonItem;
    
    NSString *_notifyText;
    UIImage *_notifyImage;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self navigationController] setTitle:@"个人资料"];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnButtonClick)];
    
    [[self navigationItem] setLeftBarButtonItem:item];
    
    CGRect rect = self.view.bounds;
    
    rect.origin.y += 64;
    rect.size.height -= 64;
    
    _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [[self view] addSubview:_tableView];
    
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    
    [_tableView setTableHeaderView:_tableHeaderView];
    
    _headView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    
    [[_headView layer] setCornerRadius:5.0];
    [[_headView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[_headView layer] setBorderWidth:0.3];
    [_headView setContentMode:UIViewContentModeScaleAspectFill];
    [_headView setClipsToBounds:YES];
    [_headView setBackgroundColor:[UIColor clearColor]];
    [_tableHeaderView addSubview:_headView];
    
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headView.right + 10, 10, 200, 30)];
    
    NSString *nickname = [g_pIMSDK nicknameOfUser:_customUserID];
    
    if ([nickname length] == 0) {
        nickname = _customUserID;
    }
    
    [_userNameLabel setBackgroundColor:[UIColor clearColor]];
    [_userNameLabel setText:nickname];
    [_userNameLabel setTextColor:[UIColor blackColor]];
    [_userNameLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [_tableHeaderView addSubview:_userNameLabel];
    
    [self resizeView:nickname];
    
    _customUserIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headView.right + 10, _userNameLabel.bottom, 200, 30)];
    
    [_customUserIDLabel setBackgroundColor:[UIColor clearColor]];
    [_customUserIDLabel setTextColor:[UIColor grayColor]];
    [_customUserIDLabel setFont:[UIFont systemFontOfSize:15]];
    [_customUserIDLabel setText:[NSString stringWithFormat:@"爱萌账号：%@",_customUserID]];
    [_tableHeaderView addSubview:_customUserIDLabel];
    
    _sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_userNameLabel.right + 10, _userNameLabel.top + 5, 20, 20)];
    
    [_tableHeaderView addSubview:_sexImageView];
    
    _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    
    [_tableView setTableFooterView:_tableFooterView];
    
    [self loadHeadImage];
    [self loadCustomUserInfomation];
}

- (void)returnButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resizeView:(NSString *)nickname {
    CGSize size;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        size = [nickname sizeWithFont:[UIFont systemFontOfSize:18.0f] constrainedToSize:CGSizeMake(200, 100000) lineBreakMode:NSLineBreakByCharWrapping];
    } else {
        size = [nickname boundingRectWithSize:CGSizeMake(200, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18.0f]} context:nil].size;
    }
    
    [_userNameLabel setFrame:CGRectMake(_userNameLabel.left, _userNameLabel.top, size.width, 30)];
    [_sexImageView setFrame:CGRectMake(_userNameLabel.right + 10, _userNameLabel.top + 5, 20, 20)];
}

- (void)rightBarButtonItenClick:(id)sender {
    if (sender != _rightBarButtonItem) {
        return;
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"加入黑名单" otherButtonTitles:@"投诉",nil];
    
    [actionSheet setTag:1000];
    [actionSheet setActionSheetStyle:UIActionSheetStyleAutomatic];
    [actionSheet showFromTabBar:[self tabBarController].tabBar];
    
}

- (void)loadHeadImage {
    UIImage *image = [g_pIMSDK mainPhotoOfUser:_customUserID];
    
    if (image == nil) {
        image = [UIImage imageNamed:@"IM_head_default.png"];
    }
    
    [_headView setImage:image];
    
    [g_pIMSDK requestMainPhotoOfUser:_customUserID success:^(UIImage *mainPhoto) {
        if (mainPhoto) {
            [_headView setImage:mainPhoto];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IMReloadMainPhotoNotification" object:_customUserID];
        }
    } failure:^(NSString *error) {
        NSLog(@"load head image failed for %@",error);
    }];
}

- (void)loadCustomUserInfomation {
    // firstly, load local custom userinfo
    NSString *userInfo = [g_pIMSDK customUserInfoWithCustomUserID:_customUserID];
    
    NSArray *array = [userInfo componentsSeparatedByString:@"\n"];
    
    if ([array count] > 0) {
        NSString *sex = [array objectAtIndex:0];
        
        if (![sex isEqualToString:@"男"] && ![sex isEqualToString:@"女"] ) {
            sex = @"男";
        }
        
        if ([sex isEqualToString:@"男"]) {
            [_sexImageView setImage:[UIImage imageNamed:@"IM_Male.png"]];
        } else {
            [_sexImageView setImage:[UIImage imageNamed:@"IM_Female.png"]];
        }
    } else {
        [_sexImageView setImage:[UIImage imageNamed:@"IM_Male.png"]];
    }
    
    [_tableView reloadData];
    
    //secondly, request server custom userinfo
    [g_pIMSDK requestCustomUserInfoWithCustomUserID:_customUserID success:^(NSString *customUserInfo) {
        if (customUserInfo == nil) {
            return ;
        }
        
        NSArray *array = [customUserInfo componentsSeparatedByString:@"\n"];
        
        if ([array count] > 0) {
            NSString *sex = [array objectAtIndex:0];
            
            if (![sex isEqualToString:@"男"] && ![sex isEqualToString:@"女"] ) {
                sex = @"男";
            }
            
            if ([sex isEqualToString:@"男"]) {
                [_sexImageView setImage:[UIImage imageNamed:@"IM_Male.png"]];
            } else {
                [_sexImageView setImage:[UIImage imageNamed:@"IM_Female.png"]];
            }
        } else {
            [_sexImageView setImage:[UIImage imageNamed:@"IM_Male.png"]];
        }
        
        [_tableView reloadData];
        
    } failure:^(NSString *error) {
        NSLog(@"load custom user information failed for %@",error);
    }];
    
    NSString *nickname = [g_pIMSDK nicknameOfUser:_customUserID];
    if ([nickname length] == 0) {
        nickname = _customUserID;
    }
    
    [self resizeView:nickname];
    
    [g_pIMSDK requestNicknameWithCustomUserID:_customUserID success:^(NSString *nickname) {
        if ([nickname length]) {
            [self resizeView:nickname];
        }
        
    } failure:^(NSString *error) {
        
    }];
}


#pragma mark - table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
    NSString *customUserInfo = [g_pIMSDK customUserInfoWithCustomUserID:_customUserID];
    
    NSArray *array = [customUserInfo componentsSeparatedByString:@"\n"];
    
    if ([indexPath row] == 0) {
        [[cell textLabel] setText:@"地区"];
        
        NSString *location = nil;
        if ([array count] >= 2) {
            location = [array objectAtIndex:1];
        }
        
        if (location == nil || [location length] == 0) {
            location = @"未填写";
        }
        [[cell detailTextLabel] setText:location];
        
    } else if ([indexPath row] == 1) {
        [[cell textLabel] setText:@"个性签名"];
        
        NSString *signature = nil;
        if ([array count] >= 3) {
            signature = [array objectAtIndex:2];
        }
        
        if (signature == nil || [signature length] == 0) {
            signature = @"未填写";
        }
        [[cell detailTextLabel] setText:signature];
    }
    
    [[cell detailTextLabel] setTextColor:[UIColor grayColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


#pragma mark - notifications

- (void)loadData {
    [_tableView reloadData];
}

@end
