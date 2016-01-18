//
//  FileManager.h
//  MyWonderSeconds
//
//  Created by ntms on 16/1/16.
//  Copyright © 2016年 千锋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

@property(nonatomic,strong)PHFetchResult * fetchResult;
@property(nonatomic,strong)NSDate * latestDate;


/** 返回单例方法*/
+(instancetype)sharedManager;

/** 是否需要创建本地plist 文件*/
-(BOOL)shouldCreatePlist;

/** 是否需要更新本地plist 文件 YES 需要更新，NO 反之*/
-(BOOL)shouldUpdatePlist;

/** 执行更新本地plist文件*/
-(void)updatePlist;

@end
