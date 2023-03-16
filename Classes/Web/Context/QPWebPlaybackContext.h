//
//  QPWebPlaybackContext.h
//  QPlayer
//
//  Created by chenxing on 2023/3/9.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPBaseContext.h"
#import "QPWKWebViewAdapter.h"
#import "QPPlayerController.h"

typedef NS_ENUM(NSUInteger, QPPlayerType) {
    QPPlayerTypeZFPlayer,
    QPPlayerTypeIJKPlayer,
    QPPlayerTypeKSYMediaPlayer,
};

@interface QPWebPlaybackContext : QPBaseContext
@property (nonatomic, weak) QPWKWebViewAdapter *adapter;
@property (nonatomic, weak) QPBaseViewController *controller;

- (instancetype)initWithAdapter:(QPWKWebViewAdapter *)adapter viewController:(QPBaseViewController *)viewController;

- (BOOL)canAllowNavigation:(NSURL *)URL;

- (void)queryVideoUrlByJavaScript;
- (void)queryVideoUrlByJavaScrip;

- (void)attemptToPlayVideo:(NSString *)url;
- (void)playVideoWithTitle:(NSString *)title urlString:(NSString *)urlString;
- (void)playVideoWithTitle:(NSString *)title urlString:(NSString *)urlString playerType:(QPPlayerType)type;

@end