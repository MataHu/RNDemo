//
//  DetectFinishViewController.m
//  MegLiveDemo
//
//  Created by megviio on 2017/5/26.
//  Copyright © megvii. All rights reserved.
//

#import "DetectFinishViewController.h"
#import <MGLivenessDetection/MGLivenessDetection.h>
#import <Masonry/Masonry.h>
#import "UIButton+Detect.h"

@interface DetectFinishViewController ()

@property (nonatomic, strong) UIImageView *resultImageV;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation DetectFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"检测结果";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self barButtonItem];
    [self buildView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - BarButtonItem
- (void)barButtonItem {
    self.navigationItem.leftBarButtonItem = nil;
}

#pragma mark - BuildView
- (void)buildView {
    UIButton* detectButton = [[UIButton new] faceIDSDKTestButtonTitle:@"确定"
                                                               detect:@selector(backRootVC:)];
    [self.view addSubview:detectButton];
    [detectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.messageLabel.mas_bottom).offset(20.0f);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.5f);
        make.height.offset(40.0f);
    }];
}

#pragma mark - Setter and Getter
- (void)setResultData:(FaceIDData *)resultData {
    NSData* bestImageData = [resultData.images objectForKey:@"image_best"];
    UIImage* bestImage = [UIImage imageWithData:bestImageData scale:1.0];
    [self.resultImageV setImage:bestImage];
    [self.messageLabel setText:[NSString stringWithFormat:@"%@ %@", @"活体检测", self.isDetectFinish ? @"成功" : @"未成功"]];
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        [self.view addSubview:self.messageLabel];
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20.0f);
            make.right.equalTo(self.view).offset(-20.0f);
            make.top.equalTo(self.view.mas_centerY);
            make.height.offset(30.0f);
        }];
        [self.messageLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _messageLabel;
}

- (UIImageView *)resultImageV {
    if (!_resultImageV) {
        _resultImageV = [[UIImageView alloc] init];
        [self.view addSubview:self.resultImageV];
        [self.resultImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.messageLabel.mas_top).offset(-15.0f);
            make.width.equalTo(self.view.mas_width).multipliedBy(0.5f);
            make.height.equalTo(self.resultImageV.mas_width);
        }];
    }
    return _resultImageV;
}

#pragma mark - BackRootVC
- (void)backRootVC:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
