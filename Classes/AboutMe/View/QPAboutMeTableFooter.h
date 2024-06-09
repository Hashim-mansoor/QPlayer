//
//  QPAboutMeTableFooter.h
//
//  Created by Tenfay on 2017/6/28.
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import "BaseView.h"

typedef NS_ENUM(NSUInteger, AMFooterActionType)
{
    AMFooterActionTypeJianShu = 1,
    AMFooterActionTypeBlog    = 2
};

typedef void (^AMFooterActionHandler)(AMFooterActionType type);

@interface QPAboutMeTableFooter : BaseView
@property (weak, nonatomic) IBOutlet UIButton *jshuButton;
@property (weak, nonatomic) IBOutlet UIButton *blogButton;
@property (weak, nonatomic) IBOutlet UILabel  *disclaimerLabel;
@property (weak, nonatomic) IBOutlet UILabel  *copyrightLabel;

- (void)onAct:(AMFooterActionHandler)handler;

@end
