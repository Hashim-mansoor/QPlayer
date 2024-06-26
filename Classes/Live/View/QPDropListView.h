//
//  QPDropListView.h
//
//  Created by Tenfay on 2017/6/28. ( https://github.com/itenfay/QPlayer )
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import "BaseView.h"
#import "QPDropListViewPresenter.h"
#import "QPDropListViewAdapter.h"

@interface QPDropListView : BaseView

// It provides a simple abstraction over complex visual effects.
@property (weak, nonatomic) IBOutlet UIVisualEffectView *m_visualEffectView;

// A view that presents data using rows arranged in a single column.
@property (weak, nonatomic) IBOutlet UITableView *m_tableView;

// A control that executes your custom code in response to user interactions.
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (nonatomic, assign, readonly) BOOL isDarkMode;
@property (nonatomic, strong) QPDropListViewAdapter *adapter;

- (QPDropListViewPresenter *)presenter;

// Carries out a action for closing with a `DLVOnCloseHandler` handler.
- (void)onCloseAction:(DropListViewOnCloseHandler)completionHandler;

// Carries out a action for selecting row with a `DLVOnSelectRowHandler` handler.
- (void)onSelectRow:(DropListViewOnSelectRowHandler)completionHandler;

- (void)refreshUI;

@end
