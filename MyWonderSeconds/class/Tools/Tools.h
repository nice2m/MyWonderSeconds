//
//  Tools.h
//  MyWonderSeconds
//
//  Created by 千锋 on 16/1/8.
//  Copyright © 2016年 千锋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject
/** 修改view的的边角*/
+(void)clipsBorderWithView:(UIView *)view andRaius:(CGFloat)radius;
/** 将view 修改为圆形*/
+(void)clipsBorderToCircle:(UIView *)view;
@end
