//
//  UIButton+Detect.m
//  FaceIDDemo
//
//  Created by megviio on 2017/5/17.
//  Copyright © megvii. All rights reserved.
//

#import "UIButton+Detect.h"

@implementation UIButton (Detect)

- (UIButton *)faceIDSDKTestButtonTitle:(NSString *)titleStr detect:(SEL)actionSEL {
    UIButton *detectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [detectButton setBackgroundColor:[UIColor colorWithRed:0.344 green:0.680 blue:1.000 alpha:1.00]];
    [detectButton setTitle:titleStr
                  forState:UIControlStateNormal];
    [detectButton setTitleColor:[UIColor whiteColor]
                       forState:UIControlStateNormal];
    [detectButton setTitleColor:[UIColor lightGrayColor]
                       forState:UIControlStateHighlighted];
    [detectButton addTarget:self
                     action:actionSEL
           forControlEvents:UIControlEventTouchUpInside];
    return detectButton;
}

@end
