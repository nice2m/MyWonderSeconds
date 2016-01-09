//
//  HomeViewController.m
//  0103-myWonderSecs
//
//  Created by 千锋 on 16/1/4.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import "HomeViewController.h"
#import "SettingViewController.h"
#import "UIBarButtonItem+Utils.h"

#import <RESideMenu.h>
#import <AVFoundation/AVFoundation.h>
//#import ""

@interface HomeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>

/** 相机背景图层*/
@property (nonatomic,strong) UIImageView *cameraImageView;
/** 收藏背景图层*/
@property(nonatomic,strong) UIView *collectionBgView;
/**  视频录制（选择）器*/
@property(strong,nonatomic) UIImagePickerController * imagePicker;
/** 表格视图*/
@property(nonatomic,strong)UITableView * tableView;
/** 视频播放器（测试使用）*/
@property(strong,nonatomic) AVPlayer * player;

@end

@implementation HomeViewController

//当从文件中激活时调用
-(void)awakeFromNib{
    
    self.cameraImageView = [[UIImageView alloc]init];
    [self.view addSubview:self.cameraImageView];
    self.collectionBgView = [[UIView alloc]init];
    self.collectionBgView.backgroundColor = [UIColor lightGrayColor];
    //self.cameraImageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.collectionBgView];
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.collectionBgView addSubview:self.tableView];
    
    
    //创建约束
    [self.cameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat cW = kSCREEN_SIZE.width - 20;
        CGFloat cH = kSCREEN_SIZE.width * 0.5;
        make.size.mas_equalTo(CGSizeMake(cW, cH));
        make.left.equalTo(self.view.mas_left).offset(MWS_PADDING_SPACING_NORMAL);
        make.top.equalTo(self.view.mas_top).offset(kTOPSPACE_FROM_NAVI);
    }];
    [self.collectionBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cameraImageView.mas_bottom).offset(MWS_PADDING_SPACING_NORMAL);
        make.left.equalTo(self.cameraImageView.mas_left);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kBOTTOMSPACE_TO_BOTTOM);
        CGFloat bgW = kSCREEN_SIZE.width - 20;
        make.width.mas_equalTo(bgW);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.equalTo(self.collectionBgView).offset(MWS_PADDING_SPACING_NORMAL);
        //make.top.equalTo(self.collectionBgView.mas_top).offset(10);
//        make.bottom.right.equalTo(self.collectionBgView).offset(-MWS_PADDING_SPACING_NORMAL);
//        make.top.left.equalTo(self.collectionBgView).offset(MWS_PADDING_SPACING_NORMAL);
        make.bottom.right.equalTo(self.collectionBgView);
        make.top.left.equalTo(self.collectionBgView);
    }];
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


//创建UI
-(void)createUI{
#if 0
    //添加触摸手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cameraOnTap:)];
    [self.cameraImageView addGestureRecognizer:tapGesture];
#endif
    //定制导航栏按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithNorImageName:@"SettingsButton" andHighlightedImage:@"SettingsButton" andTarget:self andAction:@selector(barItemPressed:)];
    
    self.cameraImageView.image = [UIImage imageNamed:@"Camera_head"];
    self.cameraImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.cameraImageView.userInteractionEnabled = YES;
    //定制摄像头的图片
    self.cameraImageView.clipsToBounds = YES;
    //self.cameraImageView.layer.cornerRadius = CGRectGetWidth(self.cameraImageView.frame) / 10;
    
}



#pragma  mark -selector
//弹出左侧菜单
-(void)barItemPressed:(UIButton *)sender{
    //显示菜单按钮
    [self.sideMenuViewController presentLeftMenuViewController];
    
    //manager postNotificationWithThemeName:ini
}



#pragma mark --UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reuseStr = @"reuseID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseStr];
    }
    cell.detailTextLabel.text = @"实施";
    return cell;
}

#warning notice!!以下代码待定，视频录制
#if 0
/**  懒加载*/

-(UIImagePickerController *)imagePicker{
    
    if (_imagePicker == nil) {
        //设置资源类型
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            _imagePicker = [[UIImagePickerController alloc]init];
            _imagePicker.delegate = self;
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
        }else{
            NSLog(@"摄像头不可用！");
            return nil;
        }
        //设置摄像头视图的弹出方式
        _imagePicker.modalPresentationStyle = UIModalPresentationPageSheet;
        //设置使用的设备
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        //设置媒体支持的类型
        _imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        //设置媒体的质量
        _imagePicker.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
        //设置摄像头模式
        _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    }
    return _imagePicker;
}

//弹出视频录制
-(void)cameraOnTap:(UITapGestureRecognizer *)sender{
    //[self presentViewController:self.imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerController 代理方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"取消");
    [_imagePicker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSLog(@"mediaType:%@",mediaType);
    NSURL * url = [info objectForKey:UIImagePickerControllerMediaURL];
    NSString * urlStr = [[url pathComponents] componentsJoinedByString:@"/"];
    NSLog(@"urlStr:%@",urlStr);
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
        UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(videoSaved), nil);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)videoSaved{
    
    NSLog(@"vedio,saved");
}
#endif
#warning notice!!我是结束符
@end
