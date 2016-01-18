//
//  ContentViewController.m
//  0103-myWonderSecs
//
//  Created by 千锋 on 16/1/6.
//  Copyright (c) 2016年 千锋. All rights reserved.
//


#import "RootViewController.h"

#import "HomeViewController.h"
#import "SettingViewController.h"
#import <RESideMenu.h>

@interface RootViewController ()

@end

@implementation RootViewController

-(void)awakeFromNib{
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController * homeVC = [mainSB instantiateViewControllerWithIdentifier:@"HomeViewController"];
    SettingViewController * settingVC = [mainSB instantiateViewControllerWithIdentifier:@"SettingViewController"];
    UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:homeVC];
    self.contentViewController = navi;
    self.leftMenuViewController = settingVC;
    self.contentViewInPortraitOffsetCenterX = 80;
    
    //self.scaleBackgroundImageView = NO;
    //self.scaleContentView = NO;
    //self.scaleMenuView = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //加载fileManager
    FileManager * fileManager = [FileManager sharedManager];
    //是否需要创建Plist 文件
    if ([fileManager shouldCreatePlist]) {
        //不存在，然后，创建plist 文件
        [fileManager updatePlist];
    }else{
        //已经存在，是否更新
        if ([fileManager shouldUpdatePlist]) {
            //更新
            [fileManager updatePlist];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
