//
//  UIView+Extension.m
//  phone
//
//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 吴峰. All rights reserved.
//

#import "UIView+Extension.h"
#import <objc/message.h>

@implementation UIView (Extension)

// x
- (void)setX:(CGFloat)x {
    
    CGRect frame   = self.frame;
    frame.origin.x = x;
    self.frame     = frame;
}
- (CGFloat)x {
    return self.frame.origin.x;
}

// y
- (void)setY:(CGFloat)y {
    
    CGRect frame   = self.frame;
    frame.origin.y = y;
    self.frame     = frame;
}
- (CGFloat)y {
    return self.frame.origin.y;
}

// width
- (void)setWidth:(CGFloat)width {
    
    CGRect frame     = self.frame;
    frame.size.width = width;
    self.frame       = frame;
}
- (CGFloat)width {
    return self.frame.size.width;
}

// height
- (void)setHeight:(CGFloat)height {
    
    CGRect frame      = self.frame;
    frame.size.height = height;
    self.frame        = frame;
}
- (CGFloat)height {
    return self.frame.size.height;
}

// origin
- (void)setOrigin:(CGPoint)origin {
    
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame   = frame;
}
- (CGPoint)origin {
    return self.frame.origin;
}

// size
- (void)setSize:(CGSize)size {
    
    CGRect frame = self.frame;
    frame.size   = size;
    self.frame   = frame;
}
- (CGSize)size {
    return self.frame.size;
}

// centerX
- (void)setCenterX:(CGFloat)centerX {
    
    CGPoint center = self.center;
    center.x       = centerX;
    self.center    = center;
}
- (CGFloat)centerX {
    return self.center.x;
}

// centerY
- (void)setCenterY:(CGFloat)centerY {
    
    CGPoint center = self.center;
    center.y       = centerY;
    self.center    = center;
}
- (CGFloat)centerY {
    return self.center.y;
}

// right
- (void)setRight:(CGFloat)right {
    self.x = right - self.width;
}
- (CGFloat)right {
    return CGRectGetMaxX(self.frame);
}

// bottom
- (void)setBottom:(CGFloat)bottom {
    self.y = bottom - self.height;
}
- (CGFloat)bottom {
    return CGRectGetMaxY(self.frame);
}

- (void)setModel:(id)model {
    objc_setAssociatedObject(self, @"model", model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id)model {
    return objc_getAssociatedObject(self, @"model");
}

+ (instancetype)viewFromXid {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
}
+ (NSArray *)viewsFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
}

/** 判断view是否相交 */
- (BOOL)intersectWithView:(UIView *)view {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect selfRect = [self convertRect:self.bounds toView:window];
    CGRect viewRect = [view convertRect:view.bounds toView:window];
    return CGRectIntersectsRect(selfRect, viewRect);
}

@end
