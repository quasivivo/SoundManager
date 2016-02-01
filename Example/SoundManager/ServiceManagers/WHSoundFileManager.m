//
//  WHSoundFileManager.m
//  SoundManager
//
//  Created by William Hannah on 1/31/16.
//  Copyright © 2016 William Hannah. All rights reserved.
//

#import "WHSoundFileManager.h"
#import "WHSoundFile.h"

static WHSoundFileManager *sSoundsManager = nil;

@interface WHSoundFileManager()

@property (nonatomic) NSArray *sounds;
@property (nonatomic) NSDictionary *particles;

@end

@implementation WHSoundFileManager

+ (WHSoundFileManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sSoundsManager = [WHSoundFileManager new];
    });
    return sSoundsManager;
}

-(instancetype)init {
    if (self = [super init]) {
        [self loadSoundsWithCompletion:nil];
    }
    return self;
}

#pragma mark - Sound file detection

-(void)loadSoundsWithCompletion:(void (^)(BOOL success))completion
{
    [self loadParticles];
    
    NSString *mediaPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Sounds"];
    [self loadMediaFromBundle:mediaPath];
    
    if (completion){
        completion(YES);
    }
}

- (void)loadParticles {
    NSString *mediaPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Particles"];

    NSMutableDictionary * media = [@{} mutableCopy];
    
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:mediaPath error:NULL];
    
    for (NSString *fileName in files) {
        NSURL *url = [NSURL fileURLWithPath:[mediaPath stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]]];
        [media setValue:url forKey:fileName];
    }
    
    self.particles = media;
}

- (void)loadMediaFromBundle:(NSString *)path {
    NSMutableArray * media = [@[] mutableCopy];
    
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    
    for (NSString *fileName in files) {
        NSURL *url = [NSURL fileURLWithPath:[path stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]]];
        
        WHSoundFile *sound = [WHSoundFile new];
        sound.name = [self cleanupFileName:fileName];
        sound.sound = url;
        sound.image = [self particleForSound:url];
        [media addObject:sound];
    }
    
    self.sounds = media;
}

- (NSString *)cleanupFileName:(NSString *)url
{
    NSString *name = [[url stringByDeletingPathExtension] capitalizedString];
    
    name = [name stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    name = [name stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    
    return name;
}

- (NSURL *)particleForSound:(NSURL *)sound {
    NSString *file = [[[sound path] lastPathComponent] stringByDeletingPathExtension];
    
    NSURL *image = [self.particles objectForKey:[NSString stringWithFormat:@"%@.png",file]];
    
    if (image) {
        return image;
    }
    
    if ([file rangeOfString:@"ninja"].location != NSNotFound) {
        return [self.particles objectForKey:@"ninja.png"];
    }
    else if ([file rangeOfString:@"bubble"].location != NSNotFound) {
        return [self.particles objectForKey:@"bubble.png"];
    }
    else if ([file rangeOfString:@"laser"].location != NSNotFound) {
        return [self.particles objectForKey:@"laser.png"];
    }
    else if ([file rangeOfString:@"click"].location != NSNotFound) {
        return [self.particles objectForKey:@"click.png"];
    }
    
    return [self.particles objectForKey:@"spark.png"];
}

- (UIImage *)defaultParticleImage {
    NSData *imageData = [NSData dataWithContentsOfURL:[self.particles objectForKey:@"spark.png"]];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}

@end
