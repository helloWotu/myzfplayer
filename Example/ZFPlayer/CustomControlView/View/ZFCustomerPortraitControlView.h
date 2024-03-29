//
//  ZFCustomerPortraitControlView.h
//  ZFPlayer_Example
//
//  Created by Tuzy on 2019/8/27.
//  Copyright © 2019 紫枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZFPlayer/ZFPlayerController.h>
#import "ZFSliderView.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZFCustomerPortraitControlView : UIView
/// 底部工具栏
@property (nonatomic, strong, readonly) UIView *bottomToolView;

/// 顶部工具栏
@property (nonatomic, strong, readonly) UIView *topToolView;

/// 标题
@property (nonatomic, strong, readonly) UILabel *titleLabel;

/// 播放或暂停按钮
@property (nonatomic, strong, readonly) UIButton *playOrPauseBtn;

/// 播放的当前时间
@property (nonatomic, strong, readonly) UILabel *currentTimeLabel;

/// 滑杆
@property (nonatomic, strong, readonly) ZFSliderView *slider;

/// 视频总时间
@property (nonatomic, strong, readonly) UILabel *totalTimeLabel;

/// 全屏按钮
@property (nonatomic, strong, readonly) UIButton *fullScreenBtn;

/// 播放器
@property (nonatomic, weak) ZFPlayerController *player;

///slider滑动开始
@property (nonatomic, copy) void(^sliderTouchBegan)(void);

/// slider滑动中
@property (nonatomic, copy, nullable) void(^sliderValueChanging)(CGFloat value,BOOL forward);

@property (nonatomic, copy, nullable) void(^sliderValueChangingLive)(CGFloat value,BOOL forward ,NSString *sliderTimeString);

@property (nonatomic, copy) void(^changeUrlBlock)(void);

/// slider滑动结束
@property (nonatomic, copy, nullable) void(^sliderValueChanged)(CGFloat value);
/// slider点击
@property (nonatomic, copy, nullable) void(^sliderTapped)(CGFloat value);

@property (nonatomic, assign) BOOL isLive;

@property (nonatomic, assign) NSTimeInterval liveTotalTime;

@property (nonatomic, assign) NSTimeInterval currentLivePlayedTime;

@property (nonatomic, assign) NSTimeInterval currentChangeTime;


/// 如果是暂停状态，seek完是否播放，默认YES
@property (nonatomic, assign) BOOL seekToPlay;

/// 重置控制层
- (void)resetControlView;

/// 显示控制层
- (void)showControlView;

/// 隐藏控制层
- (void)hideControlView;

/// 设置播放时间
- (void)videoPlayer:(ZFPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime;

/// 设置缓冲时间
- (void)videoPlayer:(ZFPlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime;

/// 是否响应该手势
- (BOOL)shouldResponseGestureWithPoint:(CGPoint)point withGestureType:(ZFPlayerGestureType)type touch:(nonnull UITouch *)touch;

/// 标题和全屏模式
- (void)showTitle:(NSString *_Nullable)title fullScreenMode:(ZFFullScreenMode)fullScreenMode;

/// 根据当前播放状态取反
- (void)playOrPause;

/// 播放按钮状态
- (void)playBtnSelectedState:(BOOL)selected;

/// 调节播放进度slider和当前时间更新
- (void)sliderValueChanged:(CGFloat)value currentTimeString:(NSString *)timeString;

/// 滑杆结束滑动
- (void)sliderChangeEnded;

@end

NS_ASSUME_NONNULL_END
