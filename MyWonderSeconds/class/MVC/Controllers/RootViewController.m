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
{
    HomeViewController * _homeVC;
}
@end

@implementation RootViewController

-(void)awakeFromNib{
    
    NSLog(@"%s:%@",__func__,[NSString stringWithFormat:@"%@/%@/%@",MWS_DOCUMENT_DIRECTORY,MWS_LOCALDATA_DIRECTORY,MWS_THUMBNAIL_PLIST_FILE_NAME]);
    
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _homeVC = [mainSB instantiateViewControllerWithIdentifier:@"HomeViewController"];
    SettingViewController * settingVC = [mainSB instantiateViewControllerWithIdentifier:@"SettingViewController"];
    UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:_homeVC];
    self.contentViewController = navi;
    self.leftMenuViewController = settingVC;
    settingVC.contentWidth = (kSCREEN_SIZE.width / 2.f + 80.f);
    
    self.contentViewInPortraitOffsetCenterX = 80.f;
    
    self.scaleBackgroundImageView = NO;
    self.scaleContentView = NO;
    self.scaleMenuView = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //加载fileManager
    FileManager * fileManager = [FileManager sharedManager];
    //添加监听通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTableView) name:MWS_NOTIFICATION_FETCH_THUMBNAILS_DONE object:nil];
    NSLog(@"开始监听通知！%s",__func__);
    //NSLog(@"%s\t%@",__func__,MWS_LOCALDATA_DIRECTORY);
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

#pragma mark - selector

-(void)updateTableView{
    //更新表格
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%s,收到通知，更新表格",__func__);
        [_homeVC updateTableView];
    });
}

//销毁通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
