//
//  UIBarButtonItem+Utils.m
//  0103-myWonderSecs
//
//  Created by 千锋 on 16/1/6.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import "UIBarButtonItem+Utils.h"

@implementation UIBarButtonItem (Utils)

+(UIBarButtonItem *)barButtonItemWithNorImageName:(NSString *)norImg andHighlightedImage:(NSString *)hlImg andTarget:(id)target andAction:(SEL)action{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setImage:[UIImage imageNamed:norImg] forState:UIControlStateNormal];
    
    [btn setImage:[UIImage imageNamed:hlImg] forState:UIControlStateHighlighted];
    CGSize size = btn.currentImage.size;
    
   btn.frame = CGRectMake(0, 0, size.width + MWS_PADDING_SPACING_NORMAL, size.height + MWS_PADDING_SPACING_NORMAL);
   // btn.frame = CGRectMake(0, 0, 60, 60);

    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    return item;
    
}
@end
