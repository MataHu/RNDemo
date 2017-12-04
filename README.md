# RNDemo
基于ReactNative开发的iOS应用，未做Android适配。后续会继续完善页面，增加新功能页面
clone项目以后，进到项目目录执行 npm install。完成后进入ios文件目录下，执行 pod install。完成后打开Cash.xcworkspace，command+r 运行。会报一个error，#import <React/RCTValueAnimatedNode.h>因为React把RCTValueAnimatedNode类移除，本地导入这个类的工作已完成，所以只需改成#import "RCTValueAnimatedNode.h"就可以。重新编译运行。
