//
//  Tools.h
//  MyWonderSeconds
//
//  Created by 千锋 on 16/1/8.
//  Copyright © 2016年 千锋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>


#import "ThumbnailsModel.h"



@interface Tools : NSObject

/*---------------Objective - C 相关---------------*/
/**  返回 00：00：00 / 00:00 格式的时间字符串*/
+(NSString *)timeFormedStringWithSecond:(NSInteger)seconds;

/** 传入文件的父路径，文件的名字，创建路径，并返回文件路径*/
+(NSString *)getSavePathWithFileName:(NSString *)imgName ofParentPath:(NSString *)parentPath;

/** 按透明度生成随机颜色*/
+(UIColor *)randomColorWithAlpha:(CGFloat)alpha;


/*---------------视图相关----------------*/



/** 修改view的的边角*/
+(void)clipsBorderWithView:(UIView *)view andRaius:(CGFloat)radius;

/** 将view 修改为圆形*/
+(void)clipsBorderToCircle:(UIView *)view;


/*---------------网络相关----------------*/



/*---------------多媒体----------------*/
/** 监听通知*/
+(void)observeNotificationWithObserver:(id)observer selector:(SEL)action name:(NSString *)name object:(id)object;
/** 发送通知*/
+(void)postNotificationWithName:(NSString *)name object:(id)obj userInfo:(NSDictionary *)info;

/** 根据PHFetchResult 保存缩略图片到本地，生成plist 文件*/
+(void)generateDataWithPHFetchResult:(PHFetchResult *)fetchResult;


/** 根据PHAsset ，将缩略图存入存入数组*/
//+(void )thumbnailImageWithPhasset:(PHAsset *)phasset targetArray:(NSMutableArray *)array andTotal:(NSUInteger)total;
@end
