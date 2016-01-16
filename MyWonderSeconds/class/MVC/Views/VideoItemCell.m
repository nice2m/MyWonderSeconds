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
    self.thumbNailImageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.durationLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setModel:(VideoItemModel *)model{
    _model = model;
    self.detailLabel.hidden = YES;
    self.titleLabel.text = @"编辑并上传";
    self.durationLabel.text = _model.duration;
    if (_model.editingNum > 0) {
        self.detailLabel.hidden = NO;
        self.detailLabel.text = [NSString stringWithFormat:@"共包含\t%d个视频文件",_model.editingNum];
    }
}


@end
