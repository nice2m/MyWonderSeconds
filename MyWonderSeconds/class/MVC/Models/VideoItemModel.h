//
//  VideoItemModel.h
//  MyWonderSeconds
//
//  Created by 千锋 on 16/1/14.
//  Copyright © 2016年 千锋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoItemModel : NSObject

/** 时长*/
@property(nonatomic,copy)NSString * duration;

/** 视频的获取标识*/
@property(nonatomic,copy)NSString * localIdentifier;

/** 包含视频数目*/
@property(nonatomic,assign)NSInteger editingNum;

/** 缩略图*/
@property(nonatomic,strong)UIImage * thumbNail;

@end
