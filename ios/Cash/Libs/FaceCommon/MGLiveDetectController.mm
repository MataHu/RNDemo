//
//  ViewController.m
//  MegLiveDemo
//
//  Created by megvii on 16/1/28.
//  Copyright © megvii. All rights reserved.
//

#import "MGLiveDetectController.h"
#import <Masonry/Masonry.h>
#import <MGLivenessDetection/MGLivenessDetection.h>
#import "UIButton+Detect.h"
#import "CustomDetectViewController.h"

@interface MGLiveDetectController ()

@property (nonatomic, strong) UIImageView *resultImageV;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UISwitch* randomSwitch;
@property (nonatomic, strong) UISegmentedControl* countSeg;
@property (nonatomic, strong) UIStepper* timeoutStepper;
@property (nonatomic, strong) UILabel* timeoutDetailLabel;

@end

@implementation MGLiveDetectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![MGLiveManager getLicense]) {
        [MGLiveManager licenseForNetWokrFinish:^(bool License) {
            NSLog(@"%@", [NSString stringWithFormat:@"%@ %@", @"授权", License ? @"成功" : @"失败"]);
        }];
    }
    self.title = @"活体检测";
    
    [self buildView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - BuildView
- (void)buildView {
    UILabel* versionLabel = [[UILabel alloc] init];
    [self.view addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12.0f);
        make.right.equalTo(self.view).offset(-12.0f);
        make.bottom.equalTo(self.view);
        make.height.offset(20.0f);
    }];
    [versionLabel setAdjustsFontSizeToFitWidth:YES];
    [versionLabel setTextAlignment:NSTextAlignmentRight];
    [versionLabel setText:[MGLiveManager LiveDetectionVersion]];
    
    UIButton* detectButton = [[UIButton new] faceIDSDKTestButtonTitle:@"开始检测"
                                                               detect:@selector(startDetect:)];
    [self.view addSubview:detectButton];
    [detectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20.0f);
        make.right.equalTo(self.view).offset(-20.0f);
        make.top.equalTo(self.view.mas_centerY).offset(40.0f);
        make.height.offset(50.0f);
    }];
    
    _messageLabel = [[UILabel alloc] init];
    [self.view addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(detectButton);
        make.bottom.equalTo(detectButton.mas_top).offset(-20.0f);
        make.height.offset(60.0f);
    }];
    [self.messageLabel setTextAlignment:NSTextAlignmentCenter];
    [self.messageLabel setNumberOfLines:0];
    [self.messageLabel setAdjustsFontSizeToFitWidth:YES];
    
    _resultImageV = [[UIImageView alloc] init];
    [self.view addSubview:self.resultImageV];
    [self.resultImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.messageLabel.mas_top).offset(-15.0f);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.5f);
        make.height.equalTo(self.resultImageV.mas_width);
    }];
    
    UILabel* randomLabel = [self remindLabelTitle:@"是否随机"];
    [self.view addSubview:randomLabel];
    [randomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(detectButton);
        make.top.equalTo(detectButton.mas_bottom).offset(20.0f);
        make.width.offset(120.0f);
        make.height.offset(30.0f);
    }];
    [randomLabel setAdjustsFontSizeToFitWidth:YES];
    _randomSwitch = [[UISwitch alloc] init];
    [self.view addSubview:self.randomSwitch];
    [self.randomSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(randomLabel.mas_right);
        make.top.bottom.equalTo(randomLabel);
        make.width.offset(60.0f);
    }];
    
    UILabel* countLabel = [self remindLabelTitle:@"动作个数"];
    [self.view addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(randomLabel);
        make.top.equalTo(randomLabel.mas_bottom).offset(10.0f);
    }];
    [countLabel setAdjustsFontSizeToFitWidth:YES];
    _countSeg = [[UISegmentedControl alloc] initWithItems:@[@"1", @"2", @"3", @"4"]];
    [self.view addSubview:self.countSeg];
    [self.countSeg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(countLabel.mas_right);
        make.top.bottom.equalTo(countLabel);
        make.right.equalTo(detectButton);
    }];
    [self.countSeg setSelectedSegmentIndex:2];
    
    UILabel* timeoutLabel = [self remindLabelTitle:@"超时时间"];
    [self.view addSubview:timeoutLabel];
    [timeoutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(randomLabel);
        make.top.equalTo(countLabel.mas_bottom).offset(10.0f);
    }];
    [timeoutLabel setAdjustsFontSizeToFitWidth:YES];
    _timeoutStepper = [[UIStepper alloc] init];
    [self.view addSubview:self.timeoutStepper];
    [self.timeoutStepper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeoutLabel.mas_right);
        make.top.bottom.equalTo(timeoutLabel);
        make.width.offset(90.0f);
    }];
    [_timeoutStepper setMaximumValue:30];
    [_timeoutStepper setMinimumValue:3];
    [_timeoutStepper setStepValue:1];
    [_timeoutStepper setValue:10];
    [_timeoutStepper addTarget:self
                        action:@selector(changeTimeOut:)
              forControlEvents:UIControlEventValueChanged];
    _timeoutDetailLabel = [self remindLabelTitle:[NSString stringWithFormat:@"%d", (int)_timeoutStepper.value]];
    [self.view addSubview:self.timeoutDetailLabel];
    [self.timeoutDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeoutStepper.mas_right).offset(10.0f);
        make.top.bottom.equalTo(self.timeoutStepper);
        make.width.offset(30.0f);
    }];
    
    UIButton* customDetectButton = [[UIButton new] faceIDSDKTestButtonTitle:@"自定义UI"
                                                                     detect:@selector(openCustomUIDetect:)];
    [self.view addSubview:customDetectButton];
    [customDetectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10.0f);
        make.bottom.equalTo(self.view).offset(-5.0f);
        make.height.offset(30.0f);
        make.width.offset(120.0f);
    }];
}

#pragma mark - RemindLabel
- (UILabel *)remindLabelTitle:(NSString *)textStr {
    UILabel* label = [[UILabel alloc] init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [label setText:textStr];
    return label;
}

#pragma mark - TimeOut
- (void)changeTimeOut:(UIStepper *)sender {
    [self.timeoutDetailLabel setText:[NSString stringWithFormat:@"%d", (int)sender.value]];
}

#pragma mark - StartDetect
- (void)startDetect:(UIButton *)sender {
    if (![MGLiveManager getLicense]) {
        UIAlertController* alertC = [UIAlertController alertControllerWithTitle:@"提示"
                                                                        message:@"SDK授权失败，请检查"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确定"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        [alertC addAction:cancelAction];
        [self presentViewController:alertC
                           animated:YES
                         completion:nil];
        return;
    }
    
    sender.userInteractionEnabled = NO;
    [self.resultImageV setImage:nil];
    [self.messageLabel setText:nil];
    
    MGLiveManager *liveManager = [[MGLiveManager alloc] init];
    liveManager.actionCount = self.countSeg.selectedSegmentIndex + 1;
    liveManager.actionTimeOut = (int)self.timeoutStepper.value;
    liveManager.randomAction = self.randomSwitch.isOn;
    if (!self.randomSwitch.isOn) {
        NSMutableArray* actionMutableArray = [[NSMutableArray alloc] initWithCapacity:liveManager.actionCount];
        for (int i = 1; i <= liveManager.actionCount; i++) {
            [actionMutableArray addObject:[NSNumber numberWithInt:i]];
        }
        liveManager.actionArray = (NSArray *)actionMutableArray;
    }
    [liveManager startFaceDecetionViewController:self
                                          finish:^(FaceIDData *finishDic, UIViewController *viewController) {
                                              sender.userInteractionEnabled = YES;
                                              [viewController dismissViewControllerAnimated:YES completion:nil];
                                              NSData *resultData = [[finishDic images] valueForKey:@"image_best"];
                                              UIImage *resultImage = [UIImage imageWithData:resultData];
                                              [self.resultImageV setImage:resultImage];
                                              [self.messageLabel setText:[NSString stringWithFormat:@"%@ %@", @"活体检测", @"成功"]];
                                              [self.messageLabel setTextColor:[UIColor blueColor]];
                                          }
                                           error:^(MGLivenessDetectionFailedType errorType, UIViewController *viewController) {
                                               sender.userInteractionEnabled = YES;
                                               [viewController dismissViewControllerAnimated:YES completion:nil];
                                               [self showErrorString:errorType];
                                               [self.messageLabel setTextColor:[UIColor redColor]];
                                           }];
    
    
}

#pragma mark - CustomDetectVC
- (void)openCustomUIDetect:(UIButton *)sender {
    if (![MGLiveManager getLicense]) {
        [MGLiveManager licenseForNetWokrFinish:nil];
        return;
    }
    CustomDetectViewController* customDetectVC = [[CustomDetectViewController alloc] initWithDefauleSetting];
    [self.navigationController pushViewController:customDetectVC animated:YES];
}

#pragma mark - Detect failurd message
- (void)showErrorString:(MGLivenessDetectionFailedType)errorType {
    switch (errorType) {
        case DETECTION_FAILED_TYPE_ACTIONBLEND: {
            [self.messageLabel setText:[NSString stringWithFormat:@"%@ %@\n%@", @"活体检测", @"未成功", @"请按照提示完成动作"]];
        }
            break;
        case DETECTION_FAILED_TYPE_NOTVIDEO: {
            [self.messageLabel setText:[NSString stringWithFormat:@"%@ %@", @"活体检测", @"未成功"]];
        }
            break;
        case DETECTION_FAILED_TYPE_TIMEOUT: {
            [self.messageLabel setText:[NSString stringWithFormat:@"%@ %@\n%@", @"活体检测", @"未成功", @"请在规定时间内完成动作"]];
        }
            break;
        default: {
            [self.messageLabel setText:[NSString stringWithFormat:@"%@ %@", @"活体检测", @"失败"]];
        }
            break;
    }
}

@end

