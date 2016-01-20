//
//  SettingViewController.m
//  0103-myWonderSecs
//
//  Created by 千锋 on 16/1/4.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@property(nonatomic,strong)UIView * container;
@property(nonatomic,strong)UIView  *headerView;
@property(nonatomic,strong)UIImageView *userIcon;
@property(nonatomic,strong)UILabel *userName;
@property(nonatomic,strong)UILabel *userMato;

@property(nonatomic,strong)UITableView * tableView;


@end

@implementation SettingViewController

-(void)awakeFromNib{
    
}

- (void)viewDidLoad {
    self.container.backgroundColor = [Tools randomColorWithAlpha:0.5];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    //CGFloat newW = CGRectGetWidth(self.view.frame) - self.contextOffsetCenterX;
    CGRect clipRect = CGRectMake(0, 0, self.contentWidth, CGRectGetHeight(self.view.frame));
    self.container = [[UIView alloc]initWithFrame:clipRect];
    [self.view addSubview:self.container];
    
    NSLog(@"newFrame:%@",NSStringFromCGRect(clipRect));
    NSLog(@"self.container.frame:%@",NSStringFromCGRect(self.container.frame));
    //创建UI
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** 创建视图*/
-(void)createUI{
    //1. 创建子视图
    self.headerView = [UIView new];
    [self.container addSubview:self.headerView];
    self.headerView.backgroundColor = [Tools randomColorWithAlpha:0.4];
    
    self.userIcon = [UIImageView new];
    self.userIcon.image = [UIImage imageNamed:@"mm2"];
    [self.headerView addSubview:self.userIcon];
    
    self.userName = [UILabel new];
    [self.headerView addSubview:self.userName];
    self.userMato = [UILabel new];
    [self.headerView addSubview:self.userMato];
    //[self.userName sizeToFit];
    //[self.userMato sizeToFit];
    self.userName.text = @"userNameuserName";
    self.userMato.text = @"userMatouserMato";
    self.userMato.numberOfLines = 0;
    //self.userName.numberOfLines = 0;
    self.userMato.font = [UIFont systemFontOfSize:14];
    self.userName.font = [UIFont systemFontOfSize:14];
    
    self.tableView = [UITableView new];
    [self.container addSubview:self.tableView];
    
    //2. 创建约束
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container);
        make.left.equalTo(self.container);
        make.width.equalTo(self.container);
        make.height.mas_equalTo(kSCREEN_SIZE.width * 0.4);
        //NSLog(@"=-===self.container.frame:%@",NSStringFromCGRect(self.container.frame));
        //NSLog(@"=======%.3f",kSCREEN_SIZE.width * 0.4);
    }];
    //NSLog(@"%s\t%.3f",__func__,CGRectGetHeight(self.headerView.frame));
    
    //表格视图约束
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.headerView);
        make.width.equalTo(self.headerView);
        make.bottom.equalTo(self.container.mas_bottom);
    }];
    
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).offset(MWS_STATUS_HEIGHT);
        make.top.equalTo(self.headerView).offset(MWS_STATUS_HEIGHT);
        CGFloat w = kSCREEN_SIZE.width * 0.3;
        make.size.mas_equalTo(CGSizeMake(w, w));
    }];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userIcon).offset( -2 * MWS_PADDING_SPACING_NORMAL);
        make.left.equalTo(self.userIcon.mas_right).offset(2 * MWS_PADDING_SPACING_NORMAL);
        make.right.equalTo(self.headerView.mas_right).offset(-MWS_PADDING_SPACING_NORMAL);
        //CGSize size = [self.userName.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        //make.size.mas_equalTo(size);
    }];
    [self.userMato mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userName);
        make.top.equalTo(self.userName.mas_bottom).offset(2 *MWS_PADDING_SPACING_NORMAL);
        make.right.equalTo(self.userName);
        //CGSize size = [self.userMato.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        //make.size.mas_equalTo(size);
    }];
}
#pragma  mark -selector

- (void)viewDidLayoutSubviews
{
    [self.view layoutIfNeeded];
    //修剪视图
    self.userIcon.clipsToBounds = YES;
    self.userIcon.layer.cornerRadius = CGRectGetHeight(self.userIcon.frame) / 2.f;
}
@end









