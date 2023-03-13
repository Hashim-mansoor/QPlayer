//
//  QPGlobalDef.h
//
//  Created by chenxing on 2017/6/27. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QPAppConst.h"
#import "QPHudUtils.h"
#import "DYFNetworkSniffer.h"
#import "QPBaseModel.h"

#ifndef QPGlobalDef_h
#define QPGlobalDef_h

#ifndef QP_STATIC
#define QP_STATIC static
#endif

#ifndef QP_STATIC_INLINE
#define QP_STATIC_INLINE static inline
#endif

// Video searching history cache path.
#ifndef VIDEO_SEARCH_HISTORY_CACHE_PATH
#define VIDEO_SEARCH_HISTORY_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"VideoSearchHistories.plist"]
#endif

// Live searching history cache path.
#ifndef LIVE_SEARCH_HISTORY_CACHE_PATH
#define LIVE_SEARCH_HISTORY_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"LiveSearchHistories.plist"]
#endif

QP_STATIC NSString *const QPCharactersGeneralDelimitersToEncode = @":#[]@";
QP_STATIC NSString *const QPCharactersSubDelimitersToEncode = @"!$&'()*+,;=";

QP_STATIC_INLINE NSString *QPStringByAddingPercentEncodingFromString(NSString *str)
{
    //does not include "?" or "/" due to RFC 3986 - Section 3.4
    NSMutableCharacterSet *allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[QPCharactersGeneralDelimitersToEncode stringByAppendingString:QPCharactersSubDelimitersToEncode]];
    
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < str.length) {
        NSUInteger length = MIN(str.length - index, batchSize);
        NSRange range = NSMakeRange(index, length);
        
        //To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [str rangeOfComposedCharacterSequencesForRange:range];
        
        NSString *substring = [str substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        
        index += range.length;
    }
    
    return escaped;
}

QP_STATIC_INLINE NSString *QPUrlEncode(NSString *str)
{
    return QPStringByAddingPercentEncodingFromString(str);
}

QP_STATIC_INLINE NSString *QPUrlDecode(NSString *str)
{
    NSString *_str = [str stringByRemovingPercentEncoding];
    if (_str) { return _str; }
    return [str copy];
}

QP_STATIC_INLINE void QPStoreValue(NSString *key, id value)
{
    [NSUserDefaults.standardUserDefaults setObject:value forKey:key];
    [NSUserDefaults.standardUserDefaults synchronize];
}

QP_STATIC_INLINE id QPExtractValue(NSString *key)
{
    return [NSUserDefaults.standardUserDefaults objectForKey:key];
}

QP_STATIC_INLINE void QPPlayerSavePlaying(BOOL value)
{
    QPStoreValue(kQPPlayerIsPlaying, [NSNumber numberWithBool:value]);
}

QP_STATIC_INLINE BOOL QPPlayerIsPlaying() {
    return [QPExtractValue(kQPPlayerIsPlaying) boolValue];
}

QP_STATIC_INLINE void QPSetCarrierNetworkAllowed(BOOL value)
{
    QPStoreValue(kCarrierNetworkAllowed, [NSNumber numberWithBool:value]);
}

QP_STATIC_INLINE BOOL QPCarrierNetworkAllowed()
{
    return [QPExtractValue(kCarrierNetworkAllowed) boolValue];
}

QP_STATIC_INLINE void QPPlayerSetPictureInPictureEnabled(BOOL value)
{
    QPStoreValue(kPlayerPictureInPictureEnabled, [NSNumber numberWithBool:value]);
}

QP_STATIC_INLINE BOOL QPPlayerPictureInPictureEnabled()
{
    return [QPExtractValue(kPlayerPictureInPictureEnabled) boolValue];
}

QP_STATIC_INLINE NSString *QPMatchingIconName(NSString *ext)
{
    NSString *iconName = nil;
    if ([ext isEqualToString:@"avi"]) {
        iconName = [NSString stringWithFormat:@"icon_avi"];
    } else if ([ext isEqualToString:@"flv"]) {
        iconName = [NSString stringWithFormat:@"icon_flv"];
    } else if ([ext isEqualToString:@"mkv"]) {
        iconName = [NSString stringWithFormat:@"icon_mkv"];
    } else if ([ext isEqualToString:@"mov"]) {
        iconName = [NSString stringWithFormat:@"icon_mov"];
    } else if ([ext isEqualToString:@"mp4"]) {
        iconName = [NSString stringWithFormat:@"icon_mp4"];
    } else if ([ext isEqualToString:@"mpg"]) {
        iconName = [NSString stringWithFormat:@"icon_mpg"];
    } else if ([ext isEqualToString:@"rm"]) {
        iconName = [NSString stringWithFormat:@"icon_rm"];
    } else if ([ext isEqualToString:@"rmvb"]) {
        iconName = [NSString stringWithFormat:@"icon_rmvb"];
    } else if ([ext isEqualToString:@"swf"]) {
        iconName = [NSString stringWithFormat:@"icon_swf"];
    } else if ([ext isEqualToString:@"wmv"]) {
        iconName = [NSString stringWithFormat:@"icon_wmv"];
    } else if ([ext isEqualToString:@"mp3"]) {
        iconName = [NSString stringWithFormat:@"icon_mp3"];
    } else if ([ext isEqualToString:@"wma"]) {
        iconName = [NSString stringWithFormat:@"icon_wma"];
    } else if ([ext isEqualToString:@"wav"]) {
        iconName = [NSString stringWithFormat:@"icon_wav"];
    } else {
        iconName = [NSString stringWithFormat:@"icon_jpg"];
    }
    return iconName;
}

QP_STATIC_INLINE BOOL QPPlayerCanSupportAVFormat(NSString *url)
{
    BOOL canSupport = NO;
    if ([url hasSuffix:@".m3u8"]) {
        canSupport = YES;
    } else if ([url hasSuffix:@".avi"]) {
        canSupport = YES;
    } else if ([url hasSuffix:@".flv"]) {
        canSupport = YES;
    } else if ([url hasSuffix:@".mkv"]) {
        canSupport = YES;
    } else if ([url hasSuffix:@".mov"]) {
        canSupport = YES;
    } else if ([url hasSuffix:@".mp4"]) {
        canSupport = YES;
    } else if ([url hasSuffix:@".rm"]) {
        canSupport = YES;
    } else if ([url hasSuffix:@".rmvb"]) {
        canSupport = YES;
    } else if ([url hasSuffix:@".swf"]) {
        canSupport = YES;
    } else if ([url hasSuffix:@".wmv"]) {
        canSupport = YES;
    } else if ([url hasSuffix:@".mp3"]) {
        canSupport = YES;
    } else if ([url hasSuffix:@".wav"]) {
        canSupport = YES;
    } else if ([url hasSuffix:@".wma"]) {
        canSupport = YES;
    }
    return canSupport;
}

QP_STATIC_INLINE BOOL QPDetermineWhetherToPlay()
{
    if ([DYFNetworkSniffer.sharedSniffer isConnectedViaWiFi]) {
        return YES;
    } else if ([DYFNetworkSniffer.sharedSniffer isConnectedViaWWAN]) {
        if (QPCarrierNetworkAllowed()) {
            return YES;
        }
        [QPHudUtils showWarnMessage:@"请在设置中允许流量播放"];
        return NO;
    } else {
        [QPHudUtils showWarnMessage:@"无法连接，请检查网络"];
        return NO;
    }
}

/// Transforms two objects's title to pinying and sorts them.
QP_STATIC_INLINE NSInteger QPSortObjects(QPBaseModel *m1, QPBaseModel *m2, void *context)
{
    NSMutableString *str1 = [[NSMutableString alloc] initWithString:m1.sortName];
    if (CFStringTransform((__bridge CFMutableStringRef)str1,
                          0,
                          kCFStringTransformMandarinLatin, NO)) {
    }
    NSMutableString *str2 = [[NSMutableString alloc] initWithString:m2.sortName];
    if (CFStringTransform((__bridge CFMutableStringRef)str2,
                          0,
                          kCFStringTransformMandarinLatin, NO)) {
    }
    return [str1 localizedCompare:str2];
}

#endif /* QPGlobalDef_h */
