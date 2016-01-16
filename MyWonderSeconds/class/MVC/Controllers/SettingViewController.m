//
//  SettingViewController.m
//  0103-myWonderSecs
//
//  Created by 千锋 on 16/1/4.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UIImageView  *headerView;

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userMato;

@end

@implementation SettingViewController

-(void)awakeFromNib{
//    self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
//    self.userIcon.translatesAutoresizingMaskIntoConstraints = NO;
//    self.userMato.translatesAutoresizingMaskIntoConstraints = NO;
//    self.userName.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建UI
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** 创建视图*/
-(void)createUI{
    self.userName.text = @"wodeshijie";
    self.userMato.text = @"Hello world!";
    self.userIcon.backgroundColor  = [UIColor lightGrayColor];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(kSCREEN_SIZE.width * 0.4);
    }];
    
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(MWS_STATUS_HEIGHT);
        make.top.equalTo(self.view).offset(MWS_STATUS_HEIGHT);
        CGFloat iconW = CGRectGetHeight(self.headerView.frame) ;
        make.size.mas_equalTo(CGSizeMake(iconW, iconW));
        
        NSLog(@"b:%@",NSStringFromCGRect(self.userIcon.frame));
    }];
    //创建视图
    self.userIcon.clipsToBounds = YES;
    self.userIcon.layer.cornerRadius = CGRectGetHeight(self.userIcon.frame) / 2.f;
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userIcon).offset( -2 * MWS_PADDING_SPACING_NORMAL);
        make.left.equalTo(self.userIcon.mas_right).offset(2 * MWS_PADDING_SPACING_NORMAL);
        CGSize size = [self.userName.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        make.size.mas_equalTo(size);
    }];
    [self.userMato mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userName);
        make.top.equalTo(self.userName.mas_bottom).offset(2 *MWS_PADDING_SPACING_NORMAL);
        CGSize size = [self.userMato.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        make.size.mas_equalTo(size);
    }];
}
#pragma  mark -selector

@end









