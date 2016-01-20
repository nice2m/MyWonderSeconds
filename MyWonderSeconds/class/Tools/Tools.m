//
//  Tools.m
//  MyWonderSeconds
//
//  Created by 千锋 on 16/1/8.
//  Copyright © 2016年 千锋. All rights reserved.
//

#import "Tools.h"

@interface Tools()

@end

@implementation Tools

static PHImageManager * _manager;

static NSString * documentPath;
/*---------------Objective - C 相关---------------*/



+(UIColor *)randomColorWithAlpha:(CGFloat)alpha{
    CGFloat randomR = arc4random() % 255;
    CGFloat randomG = arc4random() % 255;
    CGFloat randomB = arc4random() % 255;
    UIColor * color = [UIColor colorWithRed:randomR / 255.f green:randomG / 255.f blue:randomB / 255.f alpha:alpha];
    return color;
}
/** 传入秒数，返回00:00:00 时间格式的字符串*/
+(NSString *)timeFormedStringWithSecond:(NSInteger)seconds{
    
    NSInteger  hour = seconds / 3600;
    NSInteger minute = (seconds - hour * 3600) / 60;
    NSInteger second = seconds - hour * 3600 - minute * 60;
    NSString * resultStr = nil;
    if (hour == 0) {
        resultStr = [NSString stringWithFormat:@"%02ld:%02ld",minute,second];
    }else{
        [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hour,minute,second];
    }
    return resultStr;
}

+(NSString *)getSavePathWithFileName:(NSString *)imgName ofParentPath:(NSString *)parentPath{
    NSString * finalStr = nil;
    if (parentPath.length != 0) {
        finalStr = [MWS_DOCUMENT_DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",parentPath,imgName]];
    }else{
        finalStr = [MWS_DOCUMENT_DIRECTORY stringByAppendingPathComponent:imgName];
    }
    NSFileManager * manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:[finalStr stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    return finalStr;
}


/*---------------视图相关----------------*/

/** 将传入的view 剪切为指定圆角*/
+(void)clipsBorderWithView:(UIView *)view andRaius:(CGFloat)radius{
    view.clipsToBounds = YES;
    view.layer.cornerRadius = radius;
}
/** 将传入的正方形view 且为圆形 */
+(void)clipsBorderToCircle:(UIView *)view{
    CGFloat radius = CGRectGetWidth(view.frame) / 2.f;
    view.clipsToBounds = YES;
    view.layer.cornerRadius = radius;
}


/*---------------网络相关----------------*/




/*---------------多媒体----------------*/


+(void)generateDataWithPHFetchResult:(PHFetchResult *)fetchResult{
    if (_manager == nil) {
        _manager = [PHImageManager defaultManager];
    }
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.baidu.com", DISPATCH_QUEUE_CONCURRENT);
    //线程一：请求字典信息数据
    dispatch_group_async(group, queue, ^{
#warning error!!!may cause an error,might be Tool Class methods below
        NSString * plistPath =[Tools getSavePathWithFileName:MWS_THUMBNAIL_PLIST_FILE_NAME ofParentPath:@"LocalData"];
        NSMutableDictionary * rsDict = @{}.mutableCopy;
        NSMutableArray * tempArr = @[].mutableCopy;
        //获取缩略图,存入本地path
        
        NSDate * latestDate = nil ;
        for (int i = 0 ; i < fetchResult.count; i ++) {
            NSMutableDictionary * tempDict = @{}.mutableCopy;
            PHAsset * asset = [fetchResult objectAtIndex:i];
            if (i == 0) {
                latestDate = asset.modificationDate;
                //NSLog(@"i == 0 time:%@",latestDate);
            }
            if ([asset.modificationDate compare:latestDate] == NSOrderedDescending) {
                latestDate = asset.modificationDate;
            }
            tempDict[@"assetLocalIdentifier"] = asset.localIdentifier;
            //NSLog(@"assetLocalIdentifeier:%@",asset.localIdentifier);
            NSString * tempStr = [MWS_LOCALDATA_DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[asset.localIdentifier stringByReplacingOccurrencesOfString:@"/" withString:MWS_REPLACED_STRING]]];
            
            tempDict[@"thumbNailPath"] = tempStr;
            
            NSLog(@"%s\ttempStr:\t%@",__func__,tempStr);
            
            //NSLog(@"%@",tempDict[@"thumbNailPath"]);
            tempDict[@"duration"] = [self timeFormedStringWithSecond:(NSInteger)asset.duration];
            //NSLog(@"duration:%f",asset.duration);
            //将属性信息加入数组中
            [tempArr addObject:tempDict];
        }
        rsDict[@"latestModifiedDate"] = latestDate;
        rsDict[@"thumbNailsImages"] = tempArr;
        //写入到本地plist 文件
#warning notice!!! if plist file not create successfully expect handler
        
        if([rsDict writeToFile:plistPath atomically:YES]){
            NSLog(@"本地plist文件写入成功！");
        }else{
            NSLog(@"本地缩略图plist 文件写入失败");
        }

    });
    //线程二：请求图片数据保存到本地
    //记录图片的存取情况
    __block NSInteger tempCount = 0;
    
    dispatch_group_async(group, queue, ^{
        for (int i = 0;  i < fetchResult.count; i ++) {
            PHAsset * asset1 = [fetchResult objectAtIndex:i];
            //将缩略图写入本地
            //data 写入路径
            NSString * imgDataPath = [self getSavePathWithFileName:[asset1.localIdentifier stringByReplacingOccurrencesOfString:@"/" withString:MWS_REPLACED_STRING] ofParentPath:@"/LocalData"];
            //NSLog(@"imgDataPath:%@",imgDataPath);
            //请求图片
            [_manager requestAVAssetForVideo:asset1 options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                AVAssetImageGenerator * generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
                CMTime actualTime;
                CMTime startTime = CMTimeMakeWithSeconds(1.0, 30);
                CGImageRef imgRef = [generator copyCGImageAtTime:startTime actualTime:&actualTime error:nil];
                //设置获取图片大小
                generator.maximumSize = CGSizeMake(16,9);
                generator.appliesPreferredTrackTransform = YES;
                //将图片转换为数据NSData
                UIImage * img = [UIImage imageWithCGImage:imgRef];
                NSData * data = UIImagePNGRepresentation(img);
                if (data == nil) {
                    data = UIImageJPEGRepresentation(img, 1.0);
                }
                //将data 写入为文件到指定地址
                if([data writeToFile:imgDataPath atomically:YES]){
                    NSLog(@"写入本地缩略图成功！");
                    tempCount +=1;
                    //加载完成，发送通知
                    if (tempCount == fetchResult.count) {
                        NSLog(@"所有数据加载完成！");
                        [Tools postNotificationWithName:MWS_NOTIFICATION_FETCH_THUMBNAILS_DONE object:nil userInfo:nil];
                    }
                }else{
#warning notice!!! single thumbNail writes error expect a handler
                    NSLog(@"缩略图片写入本地有问题!");
                }
                //释放图片关联
                CGImageRelease(imgRef);
            }];
        }
    });
}

/** 监听缩略图获取 通知*/
+(void)observeNotificationWithObserver:(id)observer selector:(SEL)action name:(NSString *)name object:(id)object{
    [[NSNotificationCenter defaultCenter]addObserver:observer selector:action name:name object:object];
}
+(void)postNotificationWithName:(NSString *)name object:(id)obj userInfo:(NSDictionary *)info{
    [[NSNotificationCenter defaultCenter]postNotificationName:name object:obj userInfo:info];
}


@end
