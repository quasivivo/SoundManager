//
//  WHSoundManager.m
//  Pods
//
//  Created by William Hannah on 1/31/16.
//
//

#import "WHSoundManager.h"

static WHSoundManager *sWHSoundManager = nil;

@interface WHSoundManager ()
{
    id delegate;
}

@property (nonatomic) AVAudioPlayer *player;

@end

@implementation WHSoundManager

+ (WHSoundManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sWHSoundManager = [WHSoundManager new];
    });
    return sWHSoundManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        _player = [AVAudioPlayer new];
        [self initializeAudioSession];
    }
    return self;
}

#pragma mark - Public Interface

- (void)playAudioWithURL:(NSURL *)url {
    [self logStatus:[NSString stringWithFormat:@"Playing URL: %@", url] fromMethod:__PRETTY_FUNCTION__];
    NSData *audioData = [NSData dataWithContentsOfURL:url];
    
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
    self.player.numberOfLoops = 0;
    
    if (self.player == nil) {
        [self logError:error fromMethod:__PRETTY_FUNCTION__];
    }
    else {
        [self playAudioWithData:audioData];
    }
}

- (void)pause {
    if (self.player && [self.player isPlaying]) {
        [self.player pause];
    }
}

- (void)restart {
    if (self.player) {
        [self.player pause];
        [self.player setCurrentTime:0];
    }
}

- (void)setVolume:(CGFloat)volume {
    if (self.player) {
        [self.player setVolume:volume];
    }
}

#pragma mark - Private Interface

- (void)playAudioWithData:(NSData *)data {
    AVAudioSession *av = [AVAudioSession sharedInstance];
    NSError *error;
    [av setActive:YES error:&error];
    if (error) {
        [self logError:error fromMethod:__PRETTY_FUNCTION__];
        if ([delegate respondsToSelector:@selector(audioPlayerDidFailToStartAudio:)]) {
#warning TODO: Detailed error handling
            [delegate audioPlayerDidFailToStartAudio:WHSoundManagerErrorUnknown];
        }
    }
    else {
        [self.player prepareToPlay];
        [self.player play];
    }
}

- (BOOL)initializeAudioSession {
    AVAudioSession * session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth | AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
    
    if (error) {
        [self logError:error fromMethod:__PRETTY_FUNCTION__];
        return NO;
    }
    
    return YES;
}

-(void)logStatus:(NSString *)status fromMethod:(const char *)method {
    NSLog(@"[%s] Status: %@", method, status);
}

- (void)logError:(NSError *)error fromMethod:(const char *)method {
    NSLog(@"[%s] Error: %@", method, error);
}

#pragma mark - AVAudioSessionDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if ([delegate respondsToSelector:@selector(audioPlayerDidFinishPlaying:)]) {
        [delegate audioPlayerDidFinishPlaying:flag];
    }
}

@end