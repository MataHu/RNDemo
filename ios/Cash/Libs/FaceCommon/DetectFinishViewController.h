//
//  DetectFinishViewController.h
//  MegLiveDemo
//
//  Created by megviio on 2017/5/26.
//  Copyright © megvii. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FaceIDData;

@interface DetectFinishViewController : UIViewController

@property (nonatomic, assign) BOOL isDetectFinish;
@property (nonatomic, strong) FaceIDData* resultData;

@end
