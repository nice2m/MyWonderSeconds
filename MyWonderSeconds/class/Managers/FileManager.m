//
//  FileManager.m
//  MyWonderSeconds
//
//  Created by ntms on 16/1/16.
//  Copyright © 2016年 千锋. All rights reserved.
//

#import "FileManager.h"

static FileManager * sharedManager;
@implementation FileManager

+(instancetype)sharedManager{
    if (sharedManager == nil) {
        sharedManager = [FileManager new];
    }
    return sharedManager;
}

/** 懒加载*/
-(PHFetchResult *)fetchResult{
    if (_fetchResult == nil) {
        PHFetchOptions * options = [PHFetchOptions new];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        _fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:options];
    }
    return _fetchResult;
}

-(void)updatePlist{
    [Tools generateDataWithPHFetchResult:self.fetchResult];
}
-(BOOL)shouldUpdatePlist{
    NSDate * latestDateInDict = nil;
    NSString * plistPath = [MWS_DOCUMENT_DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",MWS_LOCALDATA_DIRECTORY,MWS_THUMBNAIL_PLIST_FILE_NAME]];
    //NSLog(@"%s:%@",__func__,plistPath);
    NSDictionary * dict =  [NSDictionary dictionaryWithContentsOfFile:plistPath];
    latestDateInDict = dict[@"latestModifiedDate"];
    for (int i = 0  ; i < self.fetchResult.count; i ++) {
        PHAsset * asset = [self.fetchResult objectAtIndex:i];
        if ([asset.modificationDate compare:latestDateInDict] == NSOrderedDescending) {
            latestDateInDict = asset.modificationDate;
            return YES;
        }
    }
    return NO;
}
-(BOOL)shouldCreatePlist{
    NSFileManager * man = [NSFileManager defaultManager];
    NSString * filePath = [MWS_DOCUMENT_DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",MWS_LOCALDATA_DIRECTORY,MWS_THUMBNAIL_PLIST_FILE_NAME]];
    //NSLog(@"%s\tfilePath:%@",__func__,filePath);
    BOOL _shouldCreate = [man fileExistsAtPath:filePath];
    return !_shouldCreate;
}
@end
