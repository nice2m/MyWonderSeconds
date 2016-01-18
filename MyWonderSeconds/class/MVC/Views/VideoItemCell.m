//
//  VideoItemCell.m
//  MyWonderSeconds
//
//  Created by 千锋 on 16/1/14.
//  Copyright © 2016年 千锋. All rights reserved.
//

#import "VideoItemCell.h"

@implementation VideoItemCell

- (void)awakeFromNib {
    //设置背景颜色
    self.thumbNailImageView.backgroundColor = [Tools randomColorWithAlpha:0.5];
    self.durationLabel.backgroundColor = [Tools randomColorWithAlpha:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setModel:(ThumbnailsModel *)model{
    _model = model;
    self.detailLabel.hidden = YES;
    self.titleLabel.text = @"编辑并上传";
    self.durationLabel.text = _model.duration;
    NSString * filePath = [MWS_DOCUMENT_DIRECTORY stringByAppendingPathComponent:_model.thumbNailPath];
    self.thumbNailImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
    //NSLog(@"%s\tfilePath:%@",__func__,filePath);
}


@end
