//
//  AppDelegate.m
//
//  Created by Tenfay on 2017/6/29. ( https://github.com/itenfay/QPlayer )
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import "AppDelegate.h"
#import <ZFPlayer/ZFPlayer.h>

@interface AppDelegate ()
@property (nonatomic, assign) UIBackgroundTaskIdentifier taskIdentifier;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self onDisplaySplash];
    [self controlLog];
    [self configure];
    [self startSniffingNetworkStatus];
    return YES;
}

- (void)onDisplaySplash
{
    // sleep 1 seconds.
    [NSThread sleepForTimeInterval:1.0];
}

- (void)controlLog
{
    #ifdef DEBUG
    [ZFPlayerLogManager setLogEnable:YES];
    #else
    [ZFPlayerLogManager setLogEnable:NO];
    #endif
}

- (void)configure
{
    QPPlayerSavePlaying(NO);
    BOOL result = [QPExtractValue(kExecAppConfigOnlyOnce) boolValue];
    if (!result) {
        QPStoreValue(kExecAppConfigOnlyOnce, [NSNumber numberWithBool:YES]);
        QPStoreValue(kThemeStyleOnOff, [NSNumber numberWithBool:YES]);
        QPPlayerSetParingWebVideo(YES);
        QPPlayerSetUsingIJKPlayer(NO);
        QPSaveSkipTitlesSeconds(120);
    }
}

- (void)startSniffingNetworkStatus
{
    if (!DYFNetworkSniffer.sharedSniffer.isStarted) {
        [DYFNetworkSniffer.sharedSniffer start];
    }
}

- (void)stopSniffingNetworkStatus
{
    if (DYFNetworkSniffer.sharedSniffer.isStarted) {
        [DYFNetworkSniffer.sharedSniffer stop];
    }
}

- (QPPictureInPictureContext *)pipContext
{
    if (!_pipContext) {
        _pipContext = QPPictureInPictureContext.alloc.init;
    }
    return _pipContext;
}

//*---------------------------------------------------------------------------------------
//* ZFInterfaceOrientationMask orientationMask = ZFInterfaceOrientationMaskUnknow;
//* if (@available(iOS 16.0, *)) {
//*    orientationMask = [ZFLandscapeRotationManager_iOS16 supportedInterfaceOrientationsForWindow:window];
//* } else if (@available(iOS 15.0, *)) {
//*     orientationMask = [ZFLandscapeRotationManager_iOS15 supportedInterfaceOrientationsForWindow:window];
//* } else {
//*     orientationMask = [ZFLandscapeRotationManager supportedInterfaceOrientationsForWindow:window];
//* }
//*---------------------------------------------------------------------------------------
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (_allowOrentitaionRotation) {
        ZFInterfaceOrientationMask orientationMask = [ZFLandscapeRotationManager supportedInterfaceOrientationsForWindow:window];
        if (orientationMask != ZFInterfaceOrientationMaskUnknow) {
            return (UIInterfaceOrientationMask)orientationMask;
        }
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self startSniffingNetworkStatus];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (!QPPlayerPictureInPictureEnabledWhenBackgound()) {
        //if ([_pipContext isPictureInPictureValid]) {
        //    [_pipContext stopPictureInPicture];
        //}
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    QPPlayerSavePlaying(NO);
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self stopSniffingNetworkStatus];
    if (QPPlayerPictureInPictureEnabledWhenBackgound()) {
        [self applyForMoreTimeFromSystem];
        /*if (![self.pipContext isPictureInPictureValid]) {
         [self.pipContext startPictureInPicture];
         }*/
    } else {
        /*if ([self.pipContext isPictureInPictureValid]) {
         [self.pipContext stopPictureInPicture];
         }*/
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    QPPlayerSavePlaying(NO);
    [self stopSniffingNetworkStatus];
}

- (void)applyForMoreTimeFromSystem
{
    // 向系统申请10s
    _taskIdentifier = [UIApplication.sharedApplication beginBackgroundTaskWithName:@"QPlayer.pip.handle" expirationHandler:^{
        [self endAndInvalidateBackgroundTask];
    }];
}

- (void)endAndInvalidateBackgroundTask
{
    [UIApplication.sharedApplication endBackgroundTask:_taskIdentifier];
    _taskIdentifier = UIBackgroundTaskInvalid;
}

@end
