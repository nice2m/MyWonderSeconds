//
//  VideoItemCell.h
//  MyWonderSeconds
//
//  Created by 千锋 on 16/1/14.
//  Copyright © 2016年 千锋. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "VideoItemModel.h"
#import "ThumbnailsModel.h"

@interface VideoItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbNailImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@property(nonatomic,strong)ThumbnailsModel * model;

@end
