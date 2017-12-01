//
//  UIButton+Detect.h
//  FaceIDDemo
//
//  Created by megviio on 2017/5/17.
//  Copyright © megvii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Detect)

- (UIButton *)faceIDSDKTestButtonTitle:(NSString *)titleStr detect:(SEL)actionSEL;

@end
