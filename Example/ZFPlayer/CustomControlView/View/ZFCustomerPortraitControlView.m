//
//  ZFCustomerPortraitControlView.m
//  ZFPlayer_Example
//
//  Created by Tuzy on 2019/8/27.
//  Copyright © 2019 紫枫. All rights reserved.
//

#import "ZFCustomerPortraitControlView.h"
#import "UIView+ZFFrame.h"
#import "ZFUtilities.h"
#import <ZFPlayer/ZFPlayer.h>

@interface ZFCustomerPortraitControlView () <ZFSliderViewDelegate>
/// 底部工具栏
@property (nonatomic, strong) UIView *bottomToolView;
/// 顶部工具栏
@property (nonatomic, strong) UIView *topToolView;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 播放或暂停按钮
@property (nonatomic, strong) UIButton *playOrPauseBtn;

@property (nonatomic, strong) UIButton *bottomPlayOrPauseBtn;

/// 播放的当前时间
@property (nonatomic, strong) UILabel *currentTimeLabel;
/// 滑杆
@property (nonatomic, strong) ZFSliderView *slider;
/// 视频总时间
@property (nonatomic, strong) UILabel *totalTimeLabel;
/// 全屏按钮
@property (nonatomic, strong) UIButton *fullScreenBtn;

@property (nonatomic, assign) BOOL isShow;

/// 滑动显示的当前时间
@property (nonatomic, strong) UILabel *currentSiderTimeLabel;

@property (nonatomic, assign) BOOL isFirsetSet;
@end

@implementation ZFCustomerPortraitControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 添加子控件
        [self addSubview:self.topToolView];
        [self addSubview:self.bottomToolView];
        [self addSubview:self.playOrPauseBtn];
        [self addSubview:self.currentTimeLabel];
        [self addSubview:self.currentSiderTimeLabel];
        [self.topToolView addSubview:self.titleLabel];
        [self.bottomToolView addSubview:self.currentTimeLabel];
        [self.bottomToolView addSubview:self.slider];
        [self.bottomToolView addSubview:self.totalTimeLabel];
        [self.bottomToolView addSubview:self.fullScreenBtn];
        [self.bottomToolView addSubview:self.bottomPlayOrPauseBtn];
        
        // 设置子控件的响应事件
        [self makeSubViewsAction];
        
        [self resetControlView];
        self.clipsToBounds = YES;
        
        self.isLive = NO;
        self.isFirsetSet = NO;
        
        self.currentLivePlayedTime = 60 * 3;
    }
    return self;
}

- (void)makeSubViewsAction {
    [self.playOrPauseBtn addTarget:self action:@selector(playPauseButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomPlayOrPauseBtn addTarget:self action:@selector(playPauseButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fullScreenBtn addTarget:self action:@selector(fullScreenButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - ZFSliderViewDelegate

- (void)sliderTouchBegan:(float)value {
    self.slider.isdragging = YES;
    self.currentSiderTimeLabel.hidden = NO;
    if (self.sliderTouchBegan) self.sliderTouchBegan();
}

- (void)sliderTouchEnded:(float)value {
    if (self.isLive) {
        
        if (self.liveTotalTime > 0) {
            
            CGFloat disTime = self.liveTotalTime * (1-value);
            self.currentChangeTime = disTime;
            NSURL * url= self.player.currentPlayerManager.assetURL;
            NSString *urlString = url.absoluteString;
            if ([urlString containsString:@"?"]) {
                urlString = [urlString componentsSeparatedByString:@"?"][0];
            }
           
            NSString *URLString = [[NSString stringWithFormat:@"%@?mvtm=%f",urlString,disTime] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
             NSLog(@"urlString:%@",URLString);
            self.player.currentPlayerManager.assetURL = [NSURL URLWithString:URLString];
            [self showControlView];
            self.slider.isdragging = NO;
        } else {
            self.slider.isdragging = NO;
        }
        self.currentSiderTimeLabel.hidden = YES;
    }else {
        if (self.player.totalTime > 0) {
            @weakify(self)
            
            [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
                @strongify(self)
                if (finished) {
                    self.slider.isdragging = NO;
                }
            }];
            if (self.seekToPlay) {
                [self.player.currentPlayerManager play];
            }
        } else {
            self.slider.isdragging = NO;
        }
    }
    if (self.sliderValueChanged) self.sliderValueChanged(value);
   
}

- (void)sliderValueChanged:(float)value {
    if (self.isLive) {
        if (self.liveTotalTime == 0) {
            self.slider.value = 0;
            return;
        }
        self.slider.isdragging = YES;
        NSString *currentTimeString = [ZFUtilities convertTimeSecond:self.liveTotalTime*value];
        if (self.sliderValueChangingLive) self.sliderValueChangingLive(value,self.slider.isForward,currentTimeString);
        self.currentSiderTimeLabel.text = currentTimeString;
//        self.currentSiderTimeLabel.hidden = NO;
    }else {
        if (self.player.totalTime == 0) {
            self.slider.value = 0;
            return;
        }
        self.slider.isdragging = YES;
        NSString *currentTimeString = [ZFUtilities convertTimeSecond:self.player.totalTime*value];
        self.currentTimeLabel.text = currentTimeString;
        if (self.sliderValueChanging) self.sliderValueChanging(value,self.slider.isForward);

    }
  
}

- (void)sliderTapped:(float)value {
    
    if (self.isLive) {
        if (self.liveTotalTime > 0) {
            self.slider.isdragging = YES;
            
            CGFloat disTime = self.liveTotalTime * (1-value);
            self.currentChangeTime = disTime;
           
            NSURL * url= self.player.currentPlayerManager.assetURL;
            NSString *urlString = url.absoluteString;
            if ([urlString containsString:@"?"]) {
                urlString = [urlString componentsSeparatedByString:@"?"][0];
            }
            
            NSString *URLString = [[NSString stringWithFormat:@"%@?mvtm=%f",urlString,disTime] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSLog(@"urlString:%@",URLString);
            self.player.currentPlayerManager.assetURL = [NSURL URLWithString:URLString];
            
            [self showControlView];
            self.slider.isdragging = NO;
            
            self.sliderTapped(value);
        } else {
            self.slider.isdragging = NO;
            self.slider.value = 0;
        }
//        self.currentSiderTimeLabel.hidden = YES;
        if (self.sliderValueChanged) self.sliderValueChanged(value);
    }else {
        if (self.player.totalTime > 0) {
            self.slider.isdragging = YES;
            @weakify(self)
            [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
                @strongify(self)
                if (finished) {
                    self.slider.isdragging = NO;
                    [self.player.currentPlayerManager play];
                }
            }];
        } else {
            self.slider.isdragging = NO;
            self.slider.value = 0;
        }
    }
}

#pragma mark - action

- (void)playPauseButtonClickAction:(UIButton *)sender {
    [self playOrPause];
}

- (void)fullScreenButtonClickAction:(UIButton *)sender {
    [self.player enterFullScreen:YES animated:YES];
}

/// 根据当前播放状态取反
- (void)playOrPause {
 
    if (self.isLive) {
        self.bottomPlayOrPauseBtn.selected = !self.bottomPlayOrPauseBtn.isSelected;
        self.bottomPlayOrPauseBtn.isSelected? [self.player.currentPlayerManager play]: [self.player.currentPlayerManager pause];
    }else {
        self.playOrPauseBtn.selected = !self.playOrPauseBtn.isSelected;
        self.playOrPauseBtn.isSelected? [self.player.currentPlayerManager play]: [self.player.currentPlayerManager pause];
    }

    
}

- (void)playBtnSelectedState:(BOOL)selected {
    if (self.isLive) {
        self.bottomPlayOrPauseBtn.selected = selected;
    }else {
        self.playOrPauseBtn.selected = selected;
    }
}

#pragma mark - 添加子控件约束

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;
    CGFloat min_margin = 9;
    
    min_x = 0;
    min_y = 0;
    min_w = min_view_w;
    min_h = 40;
    self.topToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 15;
    min_y = 5;
    min_w = min_view_w - min_x - 15;
    min_h = 30;
    self.titleLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_h = 40;
    min_x = 0;
    min_y = min_view_h - min_h;
    min_w = min_view_w;
    self.bottomToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_y = 0;
    min_w = 44;
    min_h = min_w;
    self.playOrPauseBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.playOrPauseBtn.center = self.center;
    
    min_w = 65;
    min_h = 20;
    min_x = self.center.x - min_w/2;
    min_y = self.center.y + min_h + 10;
    self.currentSiderTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = min_margin;
    min_w = 62;
    min_h = 28;
    min_y = (self.bottomToolView.zf_height - min_h)/2;
    self.currentTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_w = 28;
    min_h = min_w;
    min_x = self.bottomToolView.zf_width - min_w - min_margin;
    min_y = 0;
    self.fullScreenBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.fullScreenBtn.zf_centerY = self.currentTimeLabel.zf_centerY;
    
    min_w = 62;
    min_h = 28;
    min_x = self.fullScreenBtn.zf_left - min_w - 4;
    min_y = 0;
    self.totalTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.totalTimeLabel.zf_centerY = self.currentTimeLabel.zf_centerY;
    
    if (self.isLive) {
        min_x = self.bottomPlayOrPauseBtn.zf_right + min_margin;
        min_y = 0;
        min_w = self.totalTimeLabel.zf_left - min_x - 4;
        min_h = 30;
        self.slider.frame = CGRectMake(min_x, min_y, min_w, min_h);
        self.slider.zf_centerY = self.currentTimeLabel.zf_centerY;
        
    }else {
        min_x = self.currentTimeLabel.zf_right + 4;
        min_y = 0;
        min_w = self.totalTimeLabel.zf_left - min_x - 4;
        min_h = 30;
        self.slider.frame = CGRectMake(min_x, min_y, min_w, min_h);
        self.slider.zf_centerY = self.currentTimeLabel.zf_centerY;
    }
  
    if (!self.isShow) {
        self.topToolView.zf_y = -self.topToolView.zf_height;
        self.bottomToolView.zf_y = self.zf_height;
        self.playOrPauseBtn.alpha = 0;
    } else {
        self.topToolView.zf_y = 0;
        self.bottomToolView.zf_y = self.zf_height - self.bottomToolView.zf_height;
        self.playOrPauseBtn.alpha = 1;
    }
}

#pragma mark -

/** 重置ControlView */
- (void)resetControlView {
    self.bottomToolView.alpha        = 1;
    self.slider.value                = 0;
    self.slider.bufferValue          = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.currentSiderTimeLabel.text  = @"00:00";
    self.backgroundColor             = [UIColor clearColor];
    self.playOrPauseBtn.selected     = YES;
    self.bottomPlayOrPauseBtn.selected     = YES;
    self.titleLabel.text             = @"";
}

- (void)showControlView {
    self.topToolView.alpha           = 1;
    self.bottomToolView.alpha        = 1;
    self.isShow                      = YES;
    self.topToolView.zf_y            = 0;
    self.bottomToolView.zf_y         = self.zf_height - self.bottomToolView.zf_height;
    self.playOrPauseBtn.alpha        = 1;
    self.player.statusBarHidden      = NO;
}

- (void)hideControlView {
    self.isShow                      = NO;
    self.topToolView.zf_y            = -self.topToolView.zf_height;
    self.bottomToolView.zf_y         = self.zf_height;
    self.player.statusBarHidden      = NO;
    self.playOrPauseBtn.alpha        = 0;
    self.topToolView.alpha           = 0;
    self.bottomToolView.alpha        = 0;
}

- (BOOL)shouldResponseGestureWithPoint:(CGPoint)point withGestureType:(ZFPlayerGestureType)type touch:(nonnull UITouch *)touch {
    CGRect sliderRect = [self.bottomToolView convertRect:self.slider.frame toView:self];
    if (CGRectContainsPoint(sliderRect, point)) {
        return NO;
    }
    return YES;
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    if (!self.slider.isdragging) {
        NSString *currentTimeString = [ZFUtilities convertTimeSecond:currentTime];
        NSString *totalTimeString = [ZFUtilities convertTimeSecond:totalTime];
       
        //直播判断
        if (totalTime == 0 && videoPlayer.progress < 0.1 && currentTime > 0) {
            
            self.liveTotalTime = currentTime + self.currentLivePlayedTime;
            totalTimeString = [ZFUtilities convertTimeSecond:currentTime + self.currentLivePlayedTime];
            self.totalTimeLabel.text = totalTimeString;
            
            NSInteger disChangeTime = self.liveTotalTime - self.currentChangeTime;
            if (disChangeTime > 0) {
                self.slider.value = 1 - (self.liveTotalTime - disChangeTime) / self.liveTotalTime;
            }
            self.isLive = YES;
        }else {
            self.currentTimeLabel.text = currentTimeString;
            self.totalTimeLabel.text = totalTimeString;
            self.slider.value = videoPlayer.progress;
            self.isLive = NO;
        }
       
    }
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime {
    self.slider.bufferValue = videoPlayer.bufferProgress;
}

- (void)showTitle:(NSString *)title fullScreenMode:(ZFFullScreenMode)fullScreenMode {
    self.titleLabel.text = title;
    self.player.orientationObserver.fullScreenMode = fullScreenMode;
}

/// 调节播放进度slider和当前时间更新
- (void)sliderValueChanged:(CGFloat)value currentTimeString:(NSString *)timeString {
    self.slider.value = value;
    self.currentTimeLabel.text = timeString;
    self.slider.isdragging = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
}

/// 滑杆结束滑动
- (void)sliderChangeEnded {
    self.slider.isdragging = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformIdentity;
    }];
}

- (void)updateLivesFrame {
    self.currentTimeLabel.hidden = YES;
    self.playOrPauseBtn.hidden = YES;
    CGFloat min_margin = 9;
    CGFloat min_x = min_margin;
    CGFloat min_y = 0;
    CGFloat min_w = 40;
    CGFloat min_h = min_w;
    self.bottomPlayOrPauseBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.bottomPlayOrPauseBtn.zf_centerY = self.currentTimeLabel.zf_centerY;
    
    min_x = self.bottomPlayOrPauseBtn.zf_right + min_margin;
    min_y = 0;
    min_w = self.totalTimeLabel.zf_left - min_x - 4;
    min_h = 30;
    self.slider.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.slider.zf_centerY = self.currentTimeLabel.zf_centerY;
    
}

#pragma mark - getter

- (void)setIsLive:(BOOL)isLive {
    _isLive = isLive;
    if (isLive && !self.isFirsetSet) {
        self.slider.value = 1;
        [self updateLivesFrame];
        self.isFirsetSet = YES;
    }
}

- (UIView *)topToolView {
    if (!_topToolView) {
        _topToolView = [[UIView alloc] init];
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_top_shadow");
        _topToolView.layer.contents = (id)image.CGImage;
    }
    return _topToolView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _titleLabel;
}

- (UIView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] init];
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_bottom_shadow");
        _bottomToolView.layer.contents = (id)image.CGImage;
    }
    return _bottomToolView;
}

- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseBtn setImage:ZFPlayer_Image(@"new_allPlay_44x44_") forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:ZFPlayer_Image(@"new_allPause_44x44_") forState:UIControlStateSelected];
    }
    return _playOrPauseBtn;
}

- (UIButton *)bottomPlayOrPauseBtn {
    if (!_bottomPlayOrPauseBtn) {
        _bottomPlayOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomPlayOrPauseBtn setImage:ZFPlayer_Image(@"new_allPlay_44x44_") forState:UIControlStateNormal];
        [_bottomPlayOrPauseBtn setImage:ZFPlayer_Image(@"new_allPause_44x44_") forState:UIControlStateSelected];
    }
    return _bottomPlayOrPauseBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (ZFSliderView *)slider {
    if (!_slider) {
        _slider = [[ZFSliderView alloc] init];
        _slider.delegate = self;
        _slider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
        _slider.bufferTrackTintColor  = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _slider.minimumTrackTintColor = [UIColor whiteColor];
        [_slider setThumbImage:ZFPlayer_Image(@"ZFPlayer_slider") forState:UIControlStateNormal];
        _slider.sliderHeight = 2;
    }
    return _slider;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:ZFPlayer_Image(@"ZFPlayer_fullscreen") forState:UIControlStateNormal];
    }
    return _fullScreenBtn;
}

- (UILabel *)currentSiderTimeLabel {
    if (!_currentSiderTimeLabel) {
        _currentSiderTimeLabel = [[UILabel alloc] init];
        _currentSiderTimeLabel.textColor = [UIColor redColor];
        _currentSiderTimeLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _currentSiderTimeLabel.textAlignment = NSTextAlignmentCenter;
        _currentSiderTimeLabel.hidden = YES;
    }
    return _currentSiderTimeLabel;
}

@end
