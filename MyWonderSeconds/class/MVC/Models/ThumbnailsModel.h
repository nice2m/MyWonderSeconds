//
//  ThumbnailsModel.h
//  MyWonderSeconds
//
//  Created by 千锋 on 16/1/16.
//  Copyright © 2016年 千锋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThumbnailsModel : NSObject

/** 时长*/
@property(nonatomic,copy)NSString * duration;

/** 所在PHAsset视频的获取标识*/
@property(nonatomic,copy)NSString * assetLocalIdentifier;

/** 图片的本地路径*/
@property(nonatomic,copy)NSString * thumbNailPath;

@end
