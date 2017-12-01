//
//  CustomDetectViewController.m
//  MegLiveDemo
//
//  Created by megviio on 2017/5/26.
//  Copyright © megvii. All rights reserved.
//

#import "CustomDetectViewController.h"
#import "DetectFinishViewController.h"
#import "MyBottomView.h"

@interface CustomDetectViewController ()

@end

@implementation CustomDetectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@%@", @"自定义UI", @"活体检测"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Default Setting
- (void)defaultSetting {
    if (!self.liveManager && !self.videoManager) {
        MGLiveActionManager *ActionManager = [MGLiveActionManager LiveActionRandom:NO
                                                                       actionArray:@[@1, @2, @3]
                                                                       actionCount:3];
        MGLiveErrorManager *errorManager = [[MGLiveErrorManager alloc] initWithFaceCenter:CGPointMake(0.5, 0.4)];
        
        MGVideoManager *videoManager = [MGVideoManager videoPreset:AVCaptureSessionPreset640x480
                                                    devicePosition:AVCaptureDevicePositionFront
                                                       videoRecord:NO
                                                        videoSound:NO];
        [videoManager setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
        MGLiveDetectionManager *liveManager = [[MGLiveDetectionManager alloc]initWithActionTime:8
                                                                                  actionManager:ActionManager
                                                                                   errorManager:errorManager];
        
        [self setLiveManager:liveManager];
        [self setVideoManager:videoManager];
    }
}

#pragma mark - CreateV
-(void)creatView {
    self.headerView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.headerView setImage:[MGLiveBundle LiveImageWithName:@"header_bg_img"]];
    [self.headerView setContentMode:UIViewContentModeScaleAspectFill];
    [self.headerView setFrame:CGRectMake(0, self.topViewHeight, MG_WIN_WIDTH, MG_WIN_WIDTH)];
    
    self.bottomView = [[MyBottomView alloc] initWithFrame:CGRectMake(0,
                                                                     MG_WIN_WIDTH + self.topViewHeight,
                                                                     MG_WIN_WIDTH,
                                                                     MG_WIN_HEIGHT - MG_WIN_WIDTH - self.topViewHeight)
                                         andCountDownType:MGCountDownTypeRing];
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.bottomView];
}

#pragma mark - Detect Result
- (void)liveDetectionFinish:(MGLivenessDetectionFailedType)type checkOK:(BOOL)check liveDetectionType:(MGLiveDetectionType)detectionType {
    [super liveDetectionFinish:type checkOK:check liveDetectionType:detectionType];

    DetectFinishViewController* detectFinishVC = [[DetectFinishViewController alloc] init];
    detectFinishVC.isDetectFinish = check;
    if (check == YES) {
        FaceIDData* faceData = [self.liveManager getFaceIDData];
        [detectFinishVC setResultData:faceData];
    }
    [self.navigationController pushViewController:detectFinishVC animated:YES];
}

@end
