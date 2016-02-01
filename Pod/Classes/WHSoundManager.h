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
/**
 * Called when an audio clip stops playing
 * @author Will Hannah
 *
 * @param successfully Indicates whether the audio file played through to the end or 
 *                     was interrupted.
 */
-(void)audioPlayerDidFinishPlaying:(BOOL)successfully;

/**
 * Called when the manager could not play the requested audio clip.
 * @author Will Hannah
 *
 * @param WHSoundManagerError The particular error encountered
 */
-(void)audioPlayerDidFailToStartAudio:(WHSoundManagerError)error;
@end

@interface WHSoundManager : NSObject <AVAudioPlayerDelegate>

/**
 * Singleton object.  All requests should be made to the sharedManager: 
 * [WHSoundManager sharedManager]
 * @author Will Hannah
 */
+ (WHSoundManager *)sharedManager;

/**
 * Play a local audio file, represented by an NSURL. Audio Session will be set to use
 * Bluetooth if available and default to the speaker.
 * @author Will Hannah
 *
 * @param url Source NSURL of the audio file
 */
-(void)playAudioWithURL:(NSURL *)url;

/**
 * Pause the current Audio Session
 * @author Will Hannah
 */
-(void)pause;

/**
 * Restart the current audio file from the beginning
 * @author Will Hannah
 */
-(void)restart;

/**
 * Set the Audio session's current volume
 * @author Will Hannah
 */
-(void)setVolume:(CGFloat)volume;

@end
