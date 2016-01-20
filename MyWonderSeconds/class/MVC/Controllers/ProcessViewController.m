//
//  ProcessViewController.m
//  MyWonderSeconds
//
//  Created by 千锋 on 16/1/18.
//  Copyright © 2016年 千锋. All rights reserved.
//

#import "ProcessViewController.h"

#import <MLSelectPhoto/MLSelectPhoto.h>
//#import <MLSelectPhotoPickerViewController.h>


@interface ProcessViewController ()<ZLPhotoPickerViewControllerDelegate>

- (IBAction)leftItemPressed:(UIBarButtonItem *)sender;
- (IBAction)rightItemPressed:(UIBarButtonItem *)sender;

@end

@implementation ProcessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //UISlider
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)leftItemPressed:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rightItemPressed:(UIBarButtonItem *)sender {
    MLSelectPhotoPickerViewController * imgPicker = [[MLSelectPhotoPickerViewController alloc]init];
    imgPicker.delegate = self;
    imgPicker.status = PickerViewShowStatusVideo;
    imgPicker.minCount = 20;
    [imgPicker show];
}


#pragma mark - MLSelectPhotoDelegate

-(void)pickerViewControllerDoneAsstes:(NSArray *)assets{
    
    NSLog(@"%s\tassets:%@",__func__,assets);
}

@end
