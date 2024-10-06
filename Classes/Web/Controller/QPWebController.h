//
//  QPWebController.h
//
//  Created by Tenfay on 2017/12/28. ( https://github.com/itenfay/QPlayer )
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import "BaseWebViewController.h"
#import "QPWKWebViewAdapter.h"
#import "QPWebCustomToolBarView.h"

@interface QPWebController : BaseWebViewController <UITextFieldDelegate>

- (instancetype)initWithAdapter:(QPWKWebViewAdapter *)adapter;

- (void)setupAdapter:(QPWKWebViewAdapter *)adapter;

/// ** Deprecated **
/// Builds a tool bar.
//- (UIImageView *)buildToolBar;
/// Builds a tool bar with a selector.
//- (UIImageView *)buildToolBar:(SEL)selector;
/// Builds a vertical tool bar.
//- (UIImageView *)buildVerticalToolBar;
/// Builds a vertical tool bar with a selector.
//- (UIImageView *)buildVerticalToolBar:(SEL)selector;

/// Override
- (void)loadDefaultRequest;

/// Override
- (UITextField *)titleView;

/// Override
- (QPWebCustomToolBarView *)webToolBar;

/// Override
- (void)configureWebViewAdapter;

/// Override
- (void)loadWebContents;

/// Override
- (void)adaptTitleViewStyle:(BOOL)isDark;

@end
