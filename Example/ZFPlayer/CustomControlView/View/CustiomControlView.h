//
//  CustiomControlView.h
//  ZFPlayer_Example
//
//  Created by Tuzy on 2019/8/27.
//  Copyright © 2019 紫枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFPortraitControlView.h"
#import "ZFLandScapeControlView.h"
#import <ZFPlayer/ZFPlayerMediaControl.h>
#import "ZFSpeedLoadingView.h"
#import "ZFSmallFloatControlView.h"
#import "ZFCustomerPortraitControlView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustiomControlView : UIView<ZFPlayerMediaControl>
/// 竖屏控制层的View
@property (nonatomic, strong, readonly) ZFCustomerPortraitControlView *portraitControlView;

/// 横屏控制层的View
@property (nonatomic, strong, readonly) ZFLandScapeControlView *landScapeControlView;

/// 加载loading
@property (nonatomic, strong, readonly) ZFSpeedLoadingView *activity;

/// 快进快退View
@property (nonatomic, strong, readonly) UIView *fastView;

/// 快进快退进度progress
@property (nonatomic, strong, readonly) ZFSliderView *fastProgressView;

/// 快进快退时间
@property (nonatomic, strong, readonly) UILabel *fastTimeLabel;

/// 快进快退ImageView
@property (nonatomic, strong, readonly) UIImageView *fastImageView;

/// 加载失败按钮
@property (nonatomic, strong, readonly) UIButton *failBtn;

/// 底部播放进度
@property (nonatomic, strong, readonly) ZFSliderView *bottomPgrogress;

/// 封面图
@property (nonatomic, strong, readonly) UIImageView *coverImageView;

/// 高斯模糊的背景图
@property (nonatomic, strong, readonly) UIImageView *bgImgView;

/// 高斯模糊视图
@property (nonatomic, strong, readonly) UIView *effectView;

/// 小窗口控制层
@property (nonatomic, strong, readonly) ZFSmallFloatControlView *floatControlView;

/// 快进视图是否显示动画，默认NO.
@property (nonatomic, assign) BOOL fastViewAnimated;

/// 视频之外区域是否高斯模糊显示，默认YES.
@property (nonatomic, assign) BOOL effectViewShow;

/// 直接进入全屏模式，只支持全屏模式
@property (nonatomic, assign) BOOL fullScreenOnly;

/// 如果是暂停状态，seek完是否播放，默认YES
@property (nonatomic, assign) BOOL seekToPlay;

/// 返回按钮点击回调
@property (nonatomic, copy) void(^backBtnClickCallback)(void);

/// 控制层显示或者隐藏
@property (nonatomic, readonly) BOOL controlViewAppeared;

/// 控制层显示或者隐藏的回调
@property (nonatomic, copy) void(^controlViewAppearedCallback)(BOOL appeared);

/// 控制层自动隐藏的时间，默认2.5秒
@property (nonatomic, assign) NSTimeInterval autoHiddenTimeInterval;

/// 控制层显示、隐藏动画的时长，默认0.25秒
@property (nonatomic, assign) NSTimeInterval autoFadeTimeInterval;

/// 当前直播已经播放的时间
@property (nonatomic, assign) NSTimeInterval currentLivePlayedTime;

/// 横向滑动控制播放进度时是否显示控制层,默认 YES.
@property (nonatomic, assign) BOOL horizontalPanShowControlView;

/// prepare时候是否显示控制层,默认 NO.
@property (nonatomic, assign) BOOL prepareShowControlView;

/// prepare时候是否显示loading,默认 NO.
@property (nonatomic, assign) BOOL prepareShowLoading;

/// 是否自定义禁止pan手势，默认 NO.
@property (nonatomic, assign) BOOL customDisablePanMovingDirection;

/**
 设置标题、封面、全屏模式
 
 @param title 视频的标题
 @param coverUrl 视频的封面，占位图默认是灰色的
 @param fullScreenMode 全屏模式
 */
- (void)showTitle:(NSString *)title coverURLString:(NSString *)coverUrl fullScreenMode:(ZFFullScreenMode)fullScreenMode;

/**
 设置标题、封面、默认占位图、全屏模式
 
 @param title 视频的标题
 @param coverUrl 视频的封面
 @param placeholder 指定封面的placeholder
 @param fullScreenMode 全屏模式
 */
- (void)showTitle:(NSString *)title coverURLString:(NSString *)coverUrl placeholderImage:(UIImage *)placeholder fullScreenMode:(ZFFullScreenMode)fullScreenMode;

/**
 设置标题、UIImage封面、全屏模式
 
 @param title 视频的标题
 @param image 视频的封面UIImage
 @param fullScreenMode 全屏模式
 */
- (void)showTitle:(NSString *)title coverImage:(UIImage *)image fullScreenMode:(ZFFullScreenMode)fullScreenMode;

/**
 重置控制层
 */
- (void)resetControlView;

@end

NS_ASSUME_NONNULL_END
