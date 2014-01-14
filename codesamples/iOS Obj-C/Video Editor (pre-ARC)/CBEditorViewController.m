//
//  CBEditorViewController.m
//  Color Beast
//
//  Created by Tim Hingston on 6/28/12.
//  Copyright (c) 2012 Shape Massive. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "CBEditorViewController.h"
#import "CBSlider.h"
#import "GifBuilder.h"

/* OUTPUT FRAMERATE TARGET */
#define GIF_FRAMERATE 10

#pragma mark CBEditorViewController Private Category
@interface CBEditorViewController ()

/* Timeline Delegate Methods */
- (void)onLeftBracketHit;
- (void)onRightBracketHit;

/* Private Controls */
@property (nonatomic, retain) IBOutlet UILabel* timeLabel;
@property (nonatomic, retain) IBOutlet CBSlider* speedSlider;
@property (nonatomic, retain) IBOutlet CBSlider* modeSlider;
@property (nonatomic, retain) IBOutlet UIButton* playButton;
@property (nonatomic, retain) IBOutlet UIButton* stopButton;
@property (nonatomic, retain) IBOutlet UIButton* roarButton;
@property (nonatomic, retain) IBOutlet UIButton* closeButton;
@property (nonatomic, retain) IBOutlet UIButton* loopABButton;
@property (nonatomic, retain) IBOutlet UIButton* loopBAButton;
@property (nonatomic, retain) IBOutlet UIButton* loopABAButton;
@property (nonatomic, retain) IBOutlet UIButton* speedFastButton;
@property (nonatomic, retain) IBOutlet UIButton* speedNormalButton;
@property (nonatomic, retain) IBOutlet UIButton* speedSlowButton;
@property (nonatomic, retain) IBOutlet UIButton* tapButton;
@property (nonatomic, retain) IBOutlet UIProgressView* progressView;
@property (nonatomic, retain) IBOutlet CBProgressView* cbProgressView;
@property (nonatomic, retain) IBOutlet UIView* controlsView;
@property (nonatomic, retain) IBOutlet UIView* sizeView;
@property (nonatomic, retain) IBOutlet CBPlayerView *playerView;


/* Private Properties */
@property (nonatomic, retain) CBTimelineView* timeline;
@property (nonatomic, retain) AVPlayerItem* playerItem;
@property (nonatomic, retain) AVPlayer* player;
@property (nonatomic, retain) id timeObserver;
@property (nonatomic, retain) GifBuilder* gifBuilder;

/* UI Actions */
- (IBAction)onPlayClicked:(id)sender;
- (IBAction)onStopClicked:(id)sender;
- (IBAction)onRoarClicked:(id)sender;
- (IBAction)onCloseClicked:(id)sender;
- (IBAction)onSpeedChanged:(id)sender;
- (IBAction)onLoopModeChanged:(id)sender;
- (IBAction)onSmallClicked:(id)sender;
- (IBAction)onMediumClicked:(id)sender;
- (IBAction)onLargeClicked:(id)sender;
- (IBAction)onCancelSizesClicked:(id)sender;
- (IBAction)onPlayerTapped:(id)sender;

@end

#pragma mark CBEditorViewController implementation
@implementation CBEditorViewController

// Define this constant for the key-value AVPlayerItem observation context.
static const NSString *ItemStatusContext;

@synthesize delegate;
@synthesize timeLabel;
@synthesize sourceUrl;
@synthesize playerItem;
@synthesize player;
@synthesize playerView;
@synthesize timeObserver;
@synthesize speedSlider, modeSlider;
@synthesize playButton, stopButton, roarButton, closeButton, loopABButton, loopBAButton, loopABAButton, speedFastButton, speedSlowButton, speedNormalButton, tapButton;
@synthesize gifBuilder;
@synthesize progressView, cbProgressView, controlsView, sizeView, timeline;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cbProgressView = [[[CBProgressView alloc] init] autorelease];
    cbProgressView.frame = CGRectMake(progressView.frame.origin.x, progressView.frame.origin.y, 220, 33);
    cbProgressView.hidden = YES;
    cbProgressView.alpha = 0.0;
    [self.view addSubview:cbProgressView];

    CGAffineTransform makeVertical = CGAffineTransformMakeRotation(M_PI * -0.5);
    CGAffineTransform makeVertical2 = CGAffineTransformMakeRotation(M_PI * 0.5);
    CGAffineTransform rotate180 = CGAffineTransformMakeRotation(M_PI);
    
    self.loopBAButton.transform = rotate180;
    
    [self.speedSlider addTick:0 forValue:0.75];
    [self.speedSlider addTick:1 forValue:1.0];
    [self.speedSlider addTick:2 forValue:2.0];
    self.speedSlider.transform = makeVertical;
    self.speedSlider.frame = CGRectMake(self.view.frame.size.width - 78, 50, speedSlider.frame.size.width, speedSlider.frame.size.height);
    
    
    [self.modeSlider addTick:2 forValue:CBLoopModeAB];
    [self.modeSlider addTick:1 forValue:CBLoopModeBA];
    [self.modeSlider addTick:0 forValue:CBLoopModeABA];
    self.modeSlider.transform = makeVertical;
    self.modeSlider.frame = CGRectMake(56, 50, modeSlider.frame.size.width, modeSlider.frame.size.height);
    
    self.speedFastButton.transform = rotate180;
    self.speedNormalButton.transform = makeVertical2;
    
    self.playButton.enabled = NO;
    _playerState = CBPlayerStatePaused;
    _playRate = 1.0;
    _loopMode = CBLoopModeAB;
    
    // Initialize audio growls
    _audioSSIDs = [[NSMutableArray alloc] initWithCapacity:4];
    for(int count = 0; count < 4; count++){
        NSString *roarFile = [NSString stringWithFormat:@"growl%d", count + 1];
        
        NSURL *toneURLRef = [[NSBundle mainBundle] URLForResource:roarFile
                                                    withExtension:@"wav"];
        SystemSoundID toneSSID = 0;
        
        AudioServicesCreateSystemSoundID(
                                         (CFURLRef) toneURLRef,
                                         &toneSSID
                                         );
        [_audioSSIDs insertObject:[NSNumber numberWithUnsignedLong:toneSSID] atIndex:count];
    }
    
    if (self.sourceUrl != nil) {
        [self loadAssetFromFile:self.sourceUrl];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    if (self.gifBuilder != nil) {
        self.gifBuilder.delegate = nil;
        self.gifBuilder.cancel = YES;
    }
    if (self.player != nil) {
        [self.player pause];
        [self.player removeTimeObserver:self.timeObserver];
        self.player = nil;
    }
    self.timeObserver = nil;
    if (self.playerItem != nil) {
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        self.playerItem = nil;
    }
    
    self.playerView = nil;
    self.playButton = nil;
    self.stopButton = nil;
    self.roarButton = nil;
    self.timeLabel = nil;
    self.sourceUrl = nil;
    self.progressView = nil;
    self.closeButton = nil;
    self.speedNormalButton = nil;
    self.speedFastButton = nil;
    self.speedSlowButton = nil;
    self.cbProgressView = nil;
    self.tapButton = nil;
    self.speedSlider = nil;
    self.modeSlider = nil;
    self.sizeView = nil;
    self.timeline = nil;
    [_audioSSIDs release];
}

- (void) dealloc {
    self.delegate = nil;
    self.playerItem = nil;
    self.player = nil;
    self.playerView = nil;
    self.playButton = nil;
    self.stopButton = nil;
    self.roarButton = nil;
    self.timeLabel = nil;
    self.sourceUrl = nil;
    self.progressView = nil;
    self.closeButton = nil;
    self.speedNormalButton = nil;
    self.speedFastButton = nil;
    self.speedSlowButton = nil;
    self.cbProgressView = nil;
    self.tapButton = nil;
    self.speedSlider = nil;
    self.modeSlider = nil;
    self.sizeView = nil;
    self.timeline = nil;
    self.gifBuilder = nil;
    [_audioSSIDs release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (CGSize)getRoarSize {
    switch (_roarSize) {
        case CBRoarSizeSmall:
            return CGSizeMake(240, 180);
            break;
        case CBRoarSizeMedium:
            return CGSizeMake(320, 240);
            break;
        case CBRoarSizeLarge:
            return CGSizeMake(480, 360);
            break;
    }
}

- (void)loadAssetFromFile:(NSURL*)file {

    self.sourceUrl = file;
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];

    if (asset == nil) {
        self.timeLabel.text = [NSString stringWithFormat:@"Error loading video file %@", sourceUrl.absoluteString ];
        
        return;
    }
    
    self.timeline = [[CBTimelineView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40) andAsset:asset];
    self.timeline.delegate = self;
    [self.view addSubview:self.timeline];
    
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    [playerItem addObserver:self forKeyPath:@"status"
                    options:0 context:&ItemStatusContext];
}

- (void)loadPlayer {
    
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30) queue:NULL usingBlock:^(CMTime time) {
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           /*
                           Float64 currentTime = CMTimeGetSeconds(self.player.currentTime);
                           NSString *timeDescription = [NSString stringWithFormat:@"time: %lf s", currentTime];
                           self.timeLabel.text = timeDescription;
                           //NSLog(@"tick %@", timeDescription);
                            */
                           self.timeline.currentTime = player.currentTime;
                           if (_playerState == CBPlayerStatePaused)
                               return;
                           if (CMTIME_COMPARE_INLINE(self.player.currentTime,  >=, self.timeline.rightBracketTime) && _playerState == CBPlayerStatePlaying) {
                               [self onRightBracketHit];
                           }
                           else if (CMTIME_COMPARE_INLINE(self.player.currentTime,  <=, self.timeline.leftBracketTime) && _playerState == CBPlayerStatePlaying) {
                               [self onLeftBracketHit];
                           }
                           else if (_playerState == CBPlayerStateSeeking) {
                               // ignore
                           }
                       });
    }];
    
    [playerView setPlayer:player];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    
    if (context == &ItemStatusContext) {
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self playIfReady];
                       });
        return;
    }
    [super observeValueForKeyPath:keyPath ofObject:object
                           change:change context:context];
    return;
}

- (void)playIfReady {
    if ((player.currentItem != nil) &&
        ([player.currentItem status] == AVPlayerItemStatusReadyToPlay)) {
        [player play];
    }
}

- (void)onTimelineGenerated {
    [self loadPlayer];
    [player seekToTime:self.timeline.leftBracketTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self onPlayClicked:nil];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    if (CMTIME_COMPARE_INLINE(self.player.currentTime,  >=, self.timeline.rightBracketTime) && _playerState == CBPlayerStatePlaying) {
        [self onRightBracketHit];
    }
    else if (CMTIME_COMPARE_INLINE(self.player.currentTime,  <=, self.timeline.leftBracketTime) && _playerState == CBPlayerStatePlaying) {
        [self onLeftBracketHit];
    }
}

- (void)onLeftBracketHit {
    BOOL wasSeeking = _playerState == CBPlayerStateSeeking;
    _playerState = CBPlayerStateSeeking;
    CMTime nextTime;
    switch (_loopMode) {
        case CBLoopModeAB:
        case CBLoopModeABA: 
            if (!wasSeeking) {
                nextTime = CMTimeAdd(self.timeline.leftBracketTime, CMTimeMakeWithSeconds(0.1, 600));
                [player seekToTime:nextTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
                    _playerState = CBPlayerStatePlaying;
                }];

            }
            _playRate = fabs(_playRate);
            break;
        case CBLoopModeBA:
            if (!wasSeeking) {
                nextTime = CMTimeSubtract(self.timeline.rightBracketTime, CMTimeMakeWithSeconds(0.1, 600));
                [player seekToTime:nextTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
                    _playerState = CBPlayerStatePlaying;
                }];

            }
            _playRate = -fabs(_playRate);
            break;
    }
    player.rate = _playRate;
    //NSLog(@"left bracket hit, rate %f", _playRate);
}

- (void)onRightBracketHit {
    BOOL wasSeeking = _playerState == CBPlayerStateSeeking;
    _playerState = CBPlayerStateSeeking;
    CMTime nextTime;
    switch (_loopMode) {
        case CBLoopModeAB:
            if (!wasSeeking) {
                nextTime = CMTimeAdd(self.timeline.leftBracketTime, CMTimeMakeWithSeconds(0.1, 600));
                [player seekToTime:nextTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
                    _playerState = CBPlayerStatePlaying;
                }];

            }
            _playRate = fabs(_playRate);
            break;
        case CBLoopModeBA:
        case CBLoopModeABA:
            if (!wasSeeking) {
                nextTime = CMTimeSubtract(self.timeline.rightBracketTime, CMTimeMakeWithSeconds(0.1, 600));
                [player seekToTime:nextTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
                    _playerState = CBPlayerStatePlaying;
                }];
            }
            _playRate = -fabs(_playRate);
            break;
    }
    player.rate = _playRate;

    //NSLog(@"right bracket hit, rate %f", _playRate);
}

- (IBAction)onPlayClicked:(id)sender {
    if (_playerState == CBPlayerStatePlaying) {
        [self pause];
    }
    else {
        [self play];
    }
}

- (void)pause {
    _playerState = CBPlayerStatePaused;
    self.player.rate = 0;
    self.playButton.hidden = NO;
    self.playButton.enabled = YES;
    [self.stopButton setBackgroundImage:[UIImage imageNamed:@"iPhone-Screen 7-Play Icon"] forState:UIControlStateNormal];    
}

- (void)play {
    _playerState = CBPlayerStatePlaying;
    self.player.rate = _playRate;
    self.playButton.hidden = YES;
    [self.stopButton setBackgroundImage:[UIImage imageNamed:@"iPhone-Screen 7-Stop Icon"] forState:UIControlStateNormal];
}

- (IBAction)onStopClicked:(id)sender {
    [self pause];
    [self.player seekToTime:self.timeline.leftBracketTime];
}

- (IBAction)onPlayerTapped:(id)sender {
    
    [UIView beginAnimations:@"fade" context:nil];
    [UIView setAnimationDuration:0.25];
    self.controlsView.alpha = self.controlsView.alpha == 0.0 ? 1.0 : 0.0;
    self.tapButton.alpha = self.tapButton.alpha == 0.0 ? 0.5 : 0.0;
    [UIView commitAnimations];
}

- (void)playRoarSound {
    int randNum = (int)((double)rand() / ((double)RAND_MAX + 1) * 4); //create the random number.
    SystemSoundID sound = [[_audioSSIDs objectAtIndex:randNum] unsignedLongValue];
    AudioServicesPlaySystemSound(sound);
}

- (IBAction)onRoarClicked:(id)sender {
    [self playRoarSound];
    self.sizeView.transform = CGAffineTransformMakeTranslation(0, 320);
    [UIView beginAnimations:@"slideSizes" context:nil];
    self.sizeView.hidden = NO;
    self.sizeView.transform = CGAffineTransformMakeTranslation(0, 0);
    [UIView commitAnimations];
}

- (void)generateRoar {
    [self pause];
    self.player.rate = 0;
    self.modeSlider.enabled = NO;
    self.speedSlider.enabled = NO;
    self.cbProgressView.hidden = NO;
    self.playButton.hidden = YES;
    self.stopButton.hidden = YES;
    self.roarButton.enabled = NO;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25f];
   
    self.roarButton.alpha = 0.0;
    self.cbProgressView.alpha = 1.0;
    
    [UIView commitAnimations];
    
    AVAsset* asset = self.playerItem.asset;
    self.gifBuilder = [[[GifBuilder alloc] initWithAsset:asset] autorelease];
    gifBuilder.delegate = self;
    gifBuilder.gifSpeed = fabs(_playRate);
    gifBuilder.loopMode = _loopMode;
    gifBuilder.maxGifFramerate = GIF_FRAMERATE;
    gifBuilder.startTime = self.timeline.leftBracketTime;
    gifBuilder.endTime = self.timeline.rightBracketTime;
    gifBuilder.outputFrameSize = [self getRoarSize];
    NSURL* outputFile = [self getOutputFilePath];
    //NSLog(@"saving GIF file... %@", outputFile.absoluteURL);
    [gifBuilder encodeToFile:outputFile];    
}

- (NSURL*)getOutputFilePath {
    NSDate *now = [[NSDate alloc] init];   
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_hhmmss"];
    
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    NSString* stringFromDate = [formatter stringFromDate:now];
    
    stringFromDate = [stringFromDate stringByAppendingString:@".gif"];
    [formatter release];
    [now release];        
    NSURL* outputFileUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), stringFromDate]];
    return outputFileUrl;
}

- (void)onGifProgress:(float)progress {
    int progressPct = progress * 100;
    NSString* progressText = [NSString stringWithFormat:@"%d%%", progressPct];
    //NSLog(@"GIF progress %f", progress);
    self.timeLabel.text = progressText;
    self.cbProgressView.progress = progress;
}

- (void)onGifComplete:(NSURL*)outputFile {
    //NSLog(@"GIF complete at %@", outputFile.path);
    [self doClose:YES withRoar:outputFile];
}

- (void)onGifCanceled:(NSURL *)outputFile {
    //NSLog(@"GIF complete at %@", outputFile.path);

    self.closeButton.enabled = YES;
    self.modeSlider.enabled = YES;
    self.speedSlider.enabled = YES;
    self.playButton.hidden = NO;
    self.stopButton.hidden = NO;
    self.roarButton.enabled = YES;
    self.roarButton.alpha = 1.0;
    self.cbProgressView.alpha = 0.0;
    self.timeLabel.text = @"";
    self.gifBuilder = nil;
    
}

- (void)doClose:(BOOL)share withRoar:(NSURL*)outputFile {
    [self.player pause];
    [self.player removeTimeObserver:self.timeObserver];
    self.timeObserver = nil;
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    
    if (delegate != nil) {
        [delegate onEditorClosed:self forShare:share forRoar:outputFile];
    }
}

- (IBAction)onCloseClicked:(id)sender {
    if (self.gifBuilder != nil) {
        self.gifBuilder.cancel = YES;
        self.closeButton.enabled = NO;
    }
    else {
        [self doClose:NO withRoar:nil];
    }
}

- (IBAction)onLoopModeChanged:(id)sender {
    UIView* control = (UIView*)sender;
    CBLoopMode loopMode = _loopMode;
    float pos = self.modeSlider.value;
    float val;
    
    if (control.class == [CBSlider class]) {
        CBSlider* slider = (CBSlider*)sender;
        
        [slider getTickValue:slider.value :&pos :&val];
        loopMode = (CBLoopMode)val;        
    }
    else {
        UIButton* button = (UIButton*)sender;
        if (button == self.loopABButton) {
            loopMode = CBLoopModeAB;
            pos = 2;
        }
        if (button == self.loopBAButton) {
            loopMode = CBLoopModeBA;
            pos = 1;
        }
        if (button == self.loopABAButton) {
            loopMode = CBLoopModeABA;
            pos = 0;
        }
    }

    self.modeSlider.value = pos;
    if (loopMode != _loopMode) {
        _loopMode = loopMode;
    }
    
    //NSLog(@"loop mode changed to %d", _loopMode);
}

- (IBAction)onSpeedChanged:(id)sender {
    UIView* control = (UIView*)sender;
    float pos = self.speedSlider.value;
    float val = _playRate;
    if (control.class == [CBSlider class]) {
        CBSlider* slider = (CBSlider*)sender;
        [slider getTickValue:slider.value :&pos :&val];
    }
    else {
        UIButton* button = (UIButton*)sender;
        if (button == self.speedFastButton) {
            val = 2.0;
            pos = 2.0;
        }
        if (button == self.speedNormalButton) {
            val = 1.0;
            pos = 1.0;
        }
        if (button == self.speedSlowButton) {
            val = 0.75;
            pos = 0.0;
        }

    }
    _playRate = (self.player.rate >= 0 ? val : -val);

    if (_playerState == CBPlayerStatePlaying)
        player.rate = _playRate;
    self.speedSlider.value = pos;
    
    //NSLog(@"loop speed changed to %f", _playRate);
}

- (IBAction)onSmallClicked:(id)sender {
    _roarSize = CBRoarSizeSmall;
    [self generateRoar];
    [self onCancelSizesClicked:sender];
}

- (IBAction)onMediumClicked:(id)sender {
    _roarSize = CBRoarSizeMedium;
    [self generateRoar];
    [self onCancelSizesClicked:sender];
}

- (IBAction)onLargeClicked:(id)sender {
    _roarSize = CBRoarSizeLarge;
    [self generateRoar];
    [self onCancelSizesClicked:sender];
}

- (IBAction)onCancelSizesClicked:(id)sender {
    [UIView animateWithDuration:0.25 animations:^ {
        self.sizeView.transform = CGAffineTransformMakeTranslation(0, 320);
    }
    completion:^(BOOL finished) {
        self.sizeView.hidden = YES;
    }];
}

@end
