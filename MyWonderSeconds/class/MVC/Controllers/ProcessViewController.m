//
//  ProcessViewController.m
//  MyWonderSeconds
//
//  Created by 千锋 on 16/1/18.
//  Copyright © 2016年 千锋. All rights reserved.
//

#import "ProcessViewController.h"
#import "SAVideoRangeSlider.h"
#import "SelectMusicBtn.h"

#import <MLSelectPhoto/MLSelectPhoto.h>

//#import <MLSelectPhotoPickerViewController.h>


@interface ProcessViewController ()<ZLPhotoPickerViewControllerDelegate,SAVideoRangeSliderDelegate>

- (IBAction)leftItemPressed:(UIBarButtonItem *)sender;

- (IBAction)rightItemPressed:(UIBarButtonItem *)sender;
- (IBAction)musicPressed:(SelectMusicBtn *)sender;
@property (weak, nonatomic) IBOutlet SelectMusicBtn *musicBtn;

//播放器版面
@property (weak, nonatomic) IBOutlet UIButton *playerBarPlay;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@end

@implementation ProcessViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //UISlider
}

#pragma mark - UI

-(void)createUI{
    
    //设置slider属性
    [self.slider setThumbImage:[UIImage imageNamed:@"PlayerScrubberThumb"] forState:UIControlStateNormal];
    [self.slider setThumbImage:[UIImage imageNamed:@"PlayerScrubberThumb"]  forState:UIControlStateHighlighted];
    
    [self.slider setMinimumTrackImage:[UIImage imageNamed:@"PlayerScrubberTrack"] forState:UIControlStateHighlighted];
    [self.slider setMinimumTrackImage:[UIImage imageNamed:@"PlayerScrubberTrack"] forState:UIControlStateNormal];
    
    
    
    //设置音乐按钮属性
    [self.musicBtn setImage:[UIImage imageNamed:@"EnhanceIconMusicOff"] forState:UIControlStateNormal];
    [self.musicBtn setTitle:@"选择音乐" forState:UIControlStateNormal];
    
    //创建下方滑块
    SAVideoRangeSlider * videoRangeSlider = [[SAVideoRangeSlider alloc]initWithFrame:CGRectMake(0, kSCREEN_SIZE.height - 44, kSCREEN_SIZE.width, 44) videoUrl:[NSURL fileURLWithPath:@"/Users/qianfeng/Desktop/practice/项目阶段/MyWonderSeconds/MyWonderSeconds/thaiPhuketKaronBeach.MOV"]];
    //videoRangeSlider.backgroundColor = [Tools randomColorWithAlpha:1];
    
    [self.view addSubview:videoRangeSlider];
    // Purple
    videoRangeSlider.topBorder.backgroundColor = [UIColor colorWithRed: 0.768 green: 0.665 blue: 0.853 alpha: 1];
    videoRangeSlider.bottomBorder.backgroundColor = [UIColor colorWithRed: 0.535 green: 0.329 blue: 0.707 alpha: 1];
    //videoRangeSlider.topBorder
    videoRangeSlider.delegate = self;
    
}


#pragma mark - IBAction

- (IBAction)leftItemPressed:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rightItemPressed:(UIBarButtonItem *)sender {
    MLSelectPhotoPickerViewController * imgPicker = [[MLSelectPhotoPickerViewController alloc]init];
    imgPicker.delegate = self;
    imgPicker.status = PickerViewShowStatusVideo;
    imgPicker.minCount = self.numberOfVideo;
    
    [imgPicker show];
}

- (IBAction)musicPressed:(SelectMusicBtn *)sender {
    NSLog(@"选择音乐");
}
- (IBAction)sliderChange:(UISlider *)sender {
    
    NSLog(@"我的滑板鞋\t%2.f",sender.value);
}

#pragma mark - SAVideoRangeSliderDelegate


-(void)videoRange:(SAVideoRangeSlider *)videoRange didChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition{
    NSLog(@"%s\t%.3f",__func__,rightPosition);
}


-(void)videoRange:(SAVideoRangeSlider *)videoRange didGestureStateEndedLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition{
    NSLog(@"%s\t%.3f",__func__,rightPosition);
}

#pragma mark - MSSelectPhoto

-(void)pickerViewControllerDoneAsstes:(NSArray *)assets{
    
    NSLog(@"%s\tassets:%@",__func__,assets);
}

@end
