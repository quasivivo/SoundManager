//
//  WHSoundManager.h
//  Pods
//
//  Created by William Hannah on 1/31/16.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, WHSoundManagerError)
{
    WHSoundManagerErrorUnknown = 0,    // Unknown Error
    WHSoundManagerErrorFileNotFound = 1 // File not found
};

@protocol WHSoundManagerDelegate
@optional
-(void)audioPlayerDidFinishPlaying:(BOOL)successfully;
-(void)audioPlayerDidFailToStartAudio:(WHSoundManagerError)error;
@end

@interface WHSoundManager : NSObject <AVAudioPlayerDelegate>

+ (WHSoundManager *)sharedManager;

-(void)playAudioWithURL:(NSURL *)url;
-(void)pause;
-(void)restart;
-(void)setVolume:(CGFloat)volume;

@end
