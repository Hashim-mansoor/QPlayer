//
//  QPPlaybackSettingPanel.m
//  QPlayer
//
//  Created by dengyf on 2024/4/21.
//  Copyright © 2024 dyf. All rights reserved.
//

#import "QPPlaybackSettingPanel.h"

@interface QPPlaybackSettingPanel ()
@property (nonatomic, strong) UIView *settingPanel;
@end

@implementation QPPlaybackSettingPanel

- (void)setup
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAction:)];
    [self addGestureRecognizer:tap];
}

- (void)layoutUI
{
    if (!_settingPanel) {
        _settingPanel = [[UIView alloc] init];
        _settingPanel.backgroundColor = QPColorFromRGBAlp(20, 20, 20, 0.8);
        _settingPanel.layer.cornerRadius = 15;
        [self addSubview:_settingPanel];
        [self.settingPanel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self).offset(-QPStatusBarAndNavigationBarHeight/2);
            make.left.equalTo(@50);
            make.right.equalTo(@-50);
            make.height.equalTo(@230);
        }];
        
        UIImage *closeImg = [QPImageNamed(@"droplistview_close") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:closeImg forState:UIControlStateNormal];
        closeBtn.tintColor = [UIColor whiteColor];
        [closeBtn addTarget:self action:@selector(onClosePanel:) forControlEvents:UIControlEventTouchUpInside];
        [self.settingPanel addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.settingPanel).offset(0);
            make.right.equalTo(self.settingPanel).offset(-5);
            make.width.height.equalTo(@40);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.text = @"解析网页视频";
        label1.textColor = UIColor.whiteColor;
        label1.font = [UIFont boldSystemFontOfSize:14];
        [self.settingPanel addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.equalTo(closeBtn.mas_bottom).offset(5);
            make.height.equalTo(@30);
        }];
        UISwitch *sw1 = [[UISwitch alloc] init];
        sw1.tag = 88;
        [self.settingPanel addSubview:sw1];
        sw1.on = QPPlayerParsingWebVideo();
        [sw1 addTarget:self action:@selector(onSWAction:) forControlEvents:UIControlEventValueChanged];
        [sw1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.settingPanel).offset(-15);
            make.centerY.equalTo(label1);
            make.height.equalTo(@30);
        }];
        
        UILabel *label2 = [[UILabel alloc] init];
        label2.text = @"使用IJKPlayer播放器";
        label2.textColor = UIColor.whiteColor;
        label2.font = [UIFont boldSystemFontOfSize:14];
        [self.settingPanel addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.equalTo(label1.mas_bottom).offset(15);
            make.height.equalTo(@30);
        }];
        UISwitch *sw2 = [[UISwitch alloc] init];
        sw2.tag= 89;
        [self.settingPanel addSubview:sw2];
        sw2.on = QPPlayerUseIJKPlayer();
        [sw2 addTarget:self action:@selector(onSWAction:) forControlEvents:UIControlEventValueChanged];
        [sw2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(sw1.mas_right);
            make.centerY.equalTo(label2);
            make.height.equalTo(@30);
        }];
        
        UILabel *label3 = [[UILabel alloc] init];
        label3.text = @"使用硬解码播放";
        label3.textColor = UIColor.whiteColor;
        label3.font = [UIFont boldSystemFontOfSize:14];
        [self.settingPanel addSubview:label3];
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.equalTo(label2.mas_bottom).offset(15);
            make.height.equalTo(@30);
        }];
        UISwitch *sw3 = [[UISwitch alloc] init];
        sw3.tag= 90;
        [self.settingPanel addSubview:sw3];
        sw3.on = QPPlayerHardDecoding() == 1 ? YES : NO;
        [sw3 addTarget:self action:@selector(onSWAction:) forControlEvents:UIControlEventValueChanged];
        [sw3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(sw2.mas_right);
            make.centerY.equalTo(label3);
            make.height.equalTo(@30);
        }];
        
        UILabel *label4 = [[UILabel alloc] init];
        label4.text = @"允许运营商网络播放";
        label4.textColor = UIColor.whiteColor;
        label4.font = [UIFont boldSystemFontOfSize:14];
        [self.settingPanel addSubview:label4];
        [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.equalTo(label3.mas_bottom).offset(15);
            make.height.equalTo(@30);
        }];
        UISwitch *sw4 = [[UISwitch alloc] init];
        sw4.tag= 91;
        [self.settingPanel addSubview:sw4];
        sw4.on = QPCarrierNetworkAllowed();
        [sw4 addTarget:self action:@selector(onSWAction:) forControlEvents:UIControlEventValueChanged];
        [sw4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(sw3.mas_right);
            make.centerY.equalTo(label4);
            make.height.equalTo(@30);
        }];
    }
}

- (void)onTapAction:(UITapGestureRecognizer *)gesture {
    [self hidePanel:YES];
}

- (void)showPanel {
    if (!_settingPanel) {
        return;
    }
    self.settingPanel.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.settingPanel.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        self.settingPanel.transform = CGAffineTransformIdentity;
    }];
}

- (void)hidePanel:(BOOL)animated {
    if (_settingPanel) {
        if (!animated) {
            [self removePanel];
            if (self.onHideBlock) {
                self.onHideBlock(NO);
            }
            return;
        }
        self.settingPanel.transform = CGAffineTransformMakeScale(1.0, 1.0);
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.settingPanel.transform = CGAffineTransformMakeScale(0.0, 0.0);
        } completion:^(BOOL finished) {
            [self removePanel];
            if (self.onHideBlock) {
                self.onHideBlock(YES);
            }
        }];
    }
}

- (void)onClosePanel:(UIButton *)sender {
    [self hidePanel:YES];
}

- (void)removePanel {
    [self.settingPanel removeFromSuperview];
    self.settingPanel = nil;
}

- (void)onSWAction:(UISwitch *)sw {
    if (sw.tag == 88) {
        QPPlayerSetParingWebVideo(sw.isOn);
    } else if (sw.tag == 89) {
        QPPlayerSetUsingIJKPlayer(sw.isOn);
    } else if (sw.tag == 90) {
        QPPlayerSetHardDecoding(sw.isOn ? 1 : 0);
    } else if (sw.tag == 91) {
        QPSetCarrierNetworkAllowed(sw.isOn);
    }
    [QPHudUtils showTipMessageInWindow:sw.isOn ? @"已开启" : @"已关闭" duration:1.0];
}

@end
