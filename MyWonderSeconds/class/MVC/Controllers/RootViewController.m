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
    UIStoryboard * mainSB =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController * homeVC = [mainSB instantiateViewControllerWithIdentifier:@"HomeViewController"];
    SettingViewController * settingVC = [mainSB instantiateViewControllerWithIdentifier:@"SettingViewController"];
    UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:homeVC];
    self.contentViewController = navi;
    self.leftMenuViewController = settingVC;
    //self.contentViewScaleValue = 0.5;
    //self.menuPrefersStatusBarHidden = YES;
    
//    self.parallaxEnabled = NO;
    //self.parallaxContentMaximumRelativeValue = 100;
    //self.parallaxContentMinimumRelativeValue = 10;
//    self.parallaxContentMinimumRelativeValue = 100;
//    self.contentViewScaleValue = 0.2;
//    self.parallaxMenuMaximumRelativeValue = 100;
//    self.parallaxMenuMinimumRelativeValue = 50;
    
    self.scaleBackgroundImageView = NO;
    self.scaleContentView = NO;
    self.scaleMenuView = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
