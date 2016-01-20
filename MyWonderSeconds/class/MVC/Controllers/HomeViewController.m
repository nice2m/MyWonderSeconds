//
//  HomeViewController.m
//  0103-myWonderSecs
//
//  Created by 千锋 on 16/1/4.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>



#import "HomeViewController.h"
#import "SettingViewController.h"
#import "UIBarButtonItem+Utils.h"
#import <RESideMenu.h>
//#import "VideoItemModel.h"
#import "VideoItemCell.h"
#import "ThumbnailsModel.h"
#import "ProcessViewController.h"

@interface HomeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>

/** ==================视图相关*/
/** 相机背景图层*/
@property (nonatomic,strong) UIImageView *cameraImageView;
/**  视频录制（选择）器*/
@property(strong,nonatomic) UIImagePickerController * imagePicker;
/** 表格视图*/
@property(nonatomic,strong)UITableView * tableView;
//权限是否可用
@property(nonatomic,assign)BOOL isAccessAvalabel;


/** =================数据数组*/
//视频模型数组
//@property(nonatomic,strong)NSMutableArray * videoModels;
//视频缩略图数组
@property(nonatomic,strong)NSMutableArray * videoThumbNails;
//@property(nonatomic,assign)NSInteger tempCount;

/** ==================图片库相关*/
//@property(nonatomic,strong)PHPhotoLibrary * libraryManager;
@property(nonatomic,strong)PHFetchResult * fetchResult;
//@property(nonatomic,strong)PHImageManager * imgManager;

@end

static NSString * reuseID = @"reuseID1";

@implementation HomeViewController


#pragma mark - LazilyLoad

-(UIImagePickerController *)imagePicker{
    if (_imagePicker == nil) {
        //设置资源类型
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            _imagePicker = [[UIImagePickerController alloc]init];
            _imagePicker.delegate = self;
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            _imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
            _imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        }else{
#warning notice!!! expect While no access permission handler
            NSLog(@"摄像头不可用！");
            return nil;
        }
    }
    return _imagePicker;
}

-(UITableView *)tableView{
    if (_tableView  == nil) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"VideoItemCell" bundle:nil] forCellReuseIdentifier:reuseID];
    }
    return _tableView;
}

-(UIImageView *)cameraImageView{
    if (_cameraImageView == nil) {
        _cameraImageView = [[UIImageView alloc]init];;
    }
    return _cameraImageView;
}

//
//-(NSMutableArray *)videoModels{
//    if (_videoModels == nil) {
//        _videoModels = [NSMutableArray array];
//    }
//    return _videoModels;
//}

-(NSMutableArray *)videoThumbNails{
    if (_videoThumbNails == nil ) {
        _videoThumbNails = @[].mutableCopy;
    }
    return _videoThumbNails;
}

//-(PHPhotoLibrary *)libraryManager{
//    if (_libraryManager == nil) {
//        _libraryManager = [PHPhotoLibrary sharedPhotoLibrary];
//    }
//    return _libraryManager;
//}

//-(PHImageManager *)imgManager{
//    if (_imgManager == nil) {
//        _imgManager = [PHImageManager defaultManager];
//    }
//    return _imgManager;
//}

-(PHFetchResult *)fetchResult{
    if (_fetchResult == nil) {
        PHFetchOptions * options =[PHFetchOptions new];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        _fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:options];
    }
    return _fetchResult;
}
#pragma mark - UI
//当从文件中激活时调用
-(void)awakeFromNib{
    
    [self.view addSubview:self.cameraImageView];
    
    [self.view addSubview:self.tableView];
    //创建约束
    [self.cameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat cW = kSCREEN_SIZE.width - MWS_STATUS_HEIGHT;
        CGFloat cH = kSCREEN_SIZE.width * 0.5;
        make.left.equalTo(self.view).offset(MWS_PADDING_SPACING_NORMAL);
        make.top.equalTo(self.view).offset(kTOPSPACE_FROM_NAVI);
        make.size.mas_equalTo(CGSizeMake(cW, cH));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cameraImageView.mas_bottom).offset(MWS_PADDING_SPACING_NORMAL);
        make.right.left.equalTo(self.cameraImageView);
        make.bottom.equalTo(self.view);
    }];
}

//创建UI
-(void)createUI{
#if 1
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
}


#pragma mark - Controller 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //请求权限！
    //[self requestPermission];
    //创建UI
    [self createUI];
    //获取数据
    [self getDataAndFill];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据相关
-(void)getDataAndFill{
    //根据plist 文件,生成数据
    NSString * plistPath = [MWS_DOCUMENT_DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",MWS_LOCALDATA_DIRECTORY,MWS_THUMBNAIL_PLIST_FILE_NAME]];
    NSDictionary * dict1 = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    //NSLog(@"filePath:%@",plistPath);
    //NSLog(@"dict of file:%@",dict1);
    NSArray * arr = dict1[@"thumbNailsImages"];
    for (NSDictionary * dict  in arr) {
        ThumbnailsModel * model = [ThumbnailsModel new];
        [model setValuesForKeysWithDictionary:dict];
        
        [self.videoThumbNails addObject:model];
    }
    //NSLog(@"dataArr:%@",self.videoThumbNails);
    [self.tableView reloadData];
}

#pragma mark - selector
//
////请求权限
///** 请求权限*/
//-(void)requestPermission{
//    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
//        if (status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusNotDetermined) {
//            _isAccessAvalabel = YES;
//        }else{
//#warning notice!!! user's access to photo denied! expect a handler!
//            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在[设置]->[隐私]中，开启相册权限" preferredStyle:UIAlertControllerStyleAlert];
//            [self presentViewController:alertController animated:YES completion:nil];
//            NSLog(@"用户拒绝权限！");
//        }
//    }];
//}


//弹出左侧菜单
-(void)barItemPressed:(UIButton *)sender{
    //显示菜单按钮
    [self.sideMenuViewController presentLeftMenuViewController];
}
//弹出视频录制
-(void)cameraOnTap:(UITapGestureRecognizer *)sender{
    if (self.imagePicker) {
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }else{
#warning notice!!!  expect handler ,problem with imagePicker
        NSLog(@"图片选择器有问题！");
    }
    
}

/** 刷新数据*/
//-(void)thumbNailImagesReady{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.tableView reloadData];
//    });
//}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.fetchResult.count > 0) {
        
        return self.fetchResult.count;
        
    }else{
        
        self.tableView.frame = CGRectZero;
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoItemCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    if (self.videoThumbNails.count > 0) {
        cell.model = self.videoThumbNails[indexPath.row];
    }else{
        NSLog(@"%s\tself.videoThumbNails:%ld",__func__,self.videoThumbNails.count);
    }
    return cell;
}


#pragma mark --UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProcessViewController * pVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProcessViewController"];
    //转换类型
    NSNumber * num = [NSNumber numberWithUnsignedInteger:self.fetchResult.count];
    pVC.numberOfVideo = [num integerValue];
    [self.navigationController pushViewController:pVC animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
#pragma mark - UIImag ePickerController 代理方法

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"取消");
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//摄像完成时候回调
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString * mediaTypeString = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaTypeString isEqualToString:(NSString *) kUTTypeMovie]) {
        NSURL * url = [info objectForKey:UIImagePickerControllerMediaURL];
        NSString * filePath = [url path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(filePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum(filePath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
#warning notice!!! might be errors  after picked video,expect handler
        NSLog(@"error:%@",[error localizedDescription]);
    }else{
        NSLog(@"ok!filePath:%@",videoPath);
    }
}
#pragma mark - Other 

/** 更新表格的内容*/
-(void)updateTableView{
    //[self.tableView reloadData];
    [self getDataAndFill];
}
/**
 //解决图片的方向问题，
 - (UIImage *)normalizedImage {
 if (self.imageOrientation == UIImageOrientationUp) return self;
 UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
 [self drawInRect:(CGRect){0, 0, self.size}];
 UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 return normalizedImage;
 }
 */

@end
