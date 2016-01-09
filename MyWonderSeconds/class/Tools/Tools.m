//
//  Tools.m
//  MyWonderSeconds
//
//  Created by 千锋 on 16/1/8.
//  Copyright © 2016年 千锋. All rights reserved.
//

#import "Tools.h"

@implementation Tools



+(void)clipsBorderWithView:(UIView *)view andRaius:(CGFloat)radius{
    view.clipsToBounds = YES;
    view.layer.cornerRadius = radius;
}

+(void)clipsBorderToCircle:(UIView *)view{
    CGFloat radius = CGRectGetWidth(view.frame) / 2;
    view.clipsToBounds = YES;
    view.layer.cornerRadius = radius;
}
@end
