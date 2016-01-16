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
        finalStr = [MWS_DOCUMENT_DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%@",parentPath,imgName]];
    }else{
        finalStr = [MWS_DOCUMENT_DIRECTORY stringByAppendingString:imgName];
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
    CGFloat radius = CGRectGetWidth(view.frame) / 2;
    view.clipsToBounds = YES;
    view.layer.cornerRadius = radius;
}


/*---------------网络相关----------------*/




/*---------------多媒体----------------*/


+(BOOL)generateDataWithPHFetchResult:(PHFetchResult *)fetchResult{
    BOOL _isSuccess;
    if (_manager == nil) {
        _manager = [PHImageManager defaultManager];
    }
    NSString * plistPath =[Tools getSavePathWithFileName:@"thumbnailsInfo.plist" ofParentPath:@"LocalData"];
    NSMutableDictionary * rsDict = @{}.mutableCopy;
    NSMutableArray * tempArr = @[].mutableCopy;
    NSMutableDictionary * tempDict = @{}.mutableCopy;
    //获取缩略图,存入本地path
    NSDate * latestDate ;
    for (int i = 0;  i < fetchResult.count; i ++) {
        PHAsset * asset = [fetchResult objectAtIndex:i];
        if (i == 0) {
            latestDate = asset.modificationDate;
            NSLog(@"i == 0 time:%@",latestDate);
        }
        if ([asset.modificationDate compare:latestDate] == NSOrderedDescending) {
            latestDate = asset.modificationDate;
            //NSLog(@"time:%@",latestDate);
        }
        tempDict[@"assetLocalIdentifier"] = asset.localIdentifier;
        tempDict[@"thumbNailPath"] = [MWS_DOCUMENT_DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"/LocalData/%@",[asset.localIdentifier stringByReplacingOccurrencesOfString:@"/" withString:MWS_REPLACED_STRING]]];
        tempDict[@"duration"] = @(asset.duration);
        //NSLog(@"%@",asset.localIdentifier);
        //NSLog(@"thumbNailPath:%@",tempDict[@"thumbNailPath"]);
        //将属性信息加入数组中
        [tempArr addObject:tempDict];
    }
    rsDict[@"latestModifiedDate"] = latestDate;
    rsDict[@"thumbNailsImages"] = tempArr;
    //写入到本地plist 文件
    [rsDict writeToFile:plistPath atomically:YES];
#warning notice!!! if plist file not create successfully expect handler
    //存缩略图
    [tempArr removeAllObjects];
    
    for (int i = 0 ; i < fetchResult.count; i ++) {
        [self thumbnailImageWithPhasset:[fetchResult objectAtIndex:i] targetArray:tempArr andTotal:fetchResult.count];
    }
    return _isSuccess;
}

/** 监听缩略图获取 通知*/
+(void)observeNotificationWithObserver:(id)observer selector:(SEL)action name:(NSString *)name object:(id)object{
    [[NSNotificationCenter defaultCenter]addObserver:observer selector:action name:name object:object];
}

+(void)postNotificationWithName:(NSString *)name object:(id)obj userInfo:(NSDictionary *)info{
    [[NSNotificationCenter defaultCenter]postNotificationName:name object:obj userInfo:info];
}

+(void)thumbnailImageWithPhasset:(PHAsset *)phasset targetArray:(NSMutableArray *)array andTotal:(NSUInteger)total{
    if (_manager == nil) {
        _manager = [PHImageManager defaultManager];
    }
    //data 写入路径
    NSString * imgDataPath = [self getSavePathWithFileName:[phasset.localIdentifier stringByReplacingOccurrencesOfString:@"/" withString:MWS_REPLACED_STRING] ofParentPath:@"LocalData"];
    //请求图片
    [_manager requestAVAssetForVideo:phasset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        AVAssetImageGenerator * generator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
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
        NSError * err;
        [data writeToFile:imgDataPath options:0 error:&err];
        
        if (err) {
            NSLog(@"err:%@",[err localizedDescription]);
        }
        [data writeToURL:[NSURL fileURLWithPath:imgDataPath] atomically:YES];
        
        [array addObject:img];
        
        CGImageRelease(imgRef);
        if ([array count] == total) {
            [[NSNotificationCenter defaultCenter]postNotificationName:MWS_NOTIFICATION_FETCH_THUMBNAILS_DONE object:nil];
        }
    }];
}





@end
