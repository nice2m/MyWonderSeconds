//
//  UIBarButtonItem+Utils.h
//  0103-myWonderSecs
//
//  Created by 千锋 on 16/1/6.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Utils)


+(UIBarButtonItem *)barButtonItemWithNorImageName:(NSString *)norImg andHighlightedImage:(NSString *)hlImg andTarget:(id)target andAction:(SEL)action;
@end
