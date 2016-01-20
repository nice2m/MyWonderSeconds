//
//  SelectMusicBtn.m
//  MyWonderSeconds
//
//  Created by 千锋 on 16/1/20.
//  Copyright © 2016年 千锋. All rights reserved.
//

#import "SelectMusicBtn.h"

@implementation SelectMusicBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imgX = 0;
    CGFloat imgY = 0;
    CGFloat imgW = CGRectGetWidth(contentRect);
    CGFloat imgH = CGRectGetHeight(contentRect) * self.ratio;
    CGRect rsRect = CGRectMake(imgX, imgY, imgW, imgH);
    return rsRect;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat imgX = 0;
    CGFloat imgY = CGRectGetHeight(contentRect) * self.ratio;
    CGFloat imgW = CGRectGetWidth(contentRect);
    CGFloat imgH = CGRectGetHeight(contentRect) * (1- self.ratio);
    CGRect rsRect = CGRectMake(imgX, imgY, imgW, imgH);
    return rsRect;
}
@end
