//
//  UIView+QPAdditions.m
//
//  Created by Tenfay on 2016/8/9. ( https://github.com/itenfay/QPlayer )
//  Copyright © 2016 Tenfay. All rights reserved.
//

#import "UIView+QPAdditions.h"

@implementation UIView (QPAdditions)

@dynamic top;
@dynamic left;
@dynamic bottom;
@dynamic right;
@dynamic x;
@dynamic y;
@dynamic width;
@dynamic height;
@dynamic origin;
@dynamic size;
@dynamic centerX;
@dynamic centerY;

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.size.height + self.frame.origin.y;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.size.width + self.frame.origin.x;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)value
{
    CGRect frame = self.frame;
    frame.origin.x = value;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)value
{
    CGRect frame = self.frame;
    frame.origin.y = value;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (void)removeAllSubviews
{
    UIView *view = self;
    if ([view isKindOfClass:UITableViewCell.class]) {
        UITableViewCell *cell = (UITableViewCell *)view;
        while (cell.contentView.subviews.lastObject != nil) {
            [(UIView *)cell.contentView.subviews.lastObject removeFromSuperview];
        }
    } else {
        for (UIView *subview in view.subviews) {
            [subview removeFromSuperview];
        }
    }
}

- (void)autoresizing
{
    self.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                             UIViewAutoresizingFlexibleWidth      |
                             UIViewAutoresizingFlexibleTopMargin  |
                             UIViewAutoresizingFlexibleHeight);
}

- (void)autoresizing:(UIViewAutoresizing)mask
{
    self.autoresizingMask = mask;
}

- (void)tf_addKeyboardObserver {
    [self tf_addKeyboardObserver:nil];
}

- (void)tf_addKeyboardObserver:(UIView *)view {
    NSNotificationCenter *center = NSNotificationCenter.defaultCenter;
    [center addObserver:self selector:@selector(_keyboardWillShow:) name:UIKeyboardWillShowNotification object:view];
    [center addObserver:self selector:@selector(_keyboardWillHide:) name:UIKeyboardWillHideNotification object:view];
}

- (void)tf_removeKeyboardObserver {
    NSNotificationCenter *center = NSNotificationCenter.defaultCenter;
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)_keyboardWillShow:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    if (!userInfo) return;
    CGRect keyboardBounds = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGAffineTransform t = CGAffineTransformIdentity;
    id obj = noti.object;
    UIView *view;
    if (obj && [obj isKindOfClass:UIView.class]) {
        view = (UIView *)obj;
    } else {
        view = self;
    }
    CGFloat viewOffsetY = self.tf_viewOffsetY;
    QPLog(@"viewOffsetY: %.2f", viewOffsetY);
    CGFloat offsetY = viewOffsetY > 0 ? viewOffsetY : view.frame.size.height;
    [UIView animateWithDuration:animationDuration animations:^{
        view.transform = CGAffineTransformTranslate(t, 0, keyboardBounds.origin.y - offsetY);
    }];
}

- (void)_keyboardWillHide:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    if (!userInfo) return;
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    id obj = noti.object;
    UIView *view;
    if (obj && [obj isKindOfClass:UIView.class]) {
        view = (UIView *)obj;
    } else {
        view = self;
    }
    [UIView animateWithDuration:animationDuration animations:^{
        view.transform = CGAffineTransformIdentity;
    }];
}

- (CGFloat)tf_viewOffsetY {
    return 0;
}

@end
