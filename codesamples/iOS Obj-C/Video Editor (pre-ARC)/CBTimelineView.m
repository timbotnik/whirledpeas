//
//  CBTimelineView.m
//  Color Beast
//
//  Created by Tim Hingston on 7/9/12.
//  Copyright (c) 2012 Shape Massive. All rights reserved.
//

#import "CBTimelineView.h"
#import <QuartzCore/QuartzCore.h>

#define IMAGE_WIDTH 48.0
#define IMAGE_HEIGHT 36.0
#define MAX_DURATION 2.5

@interface CBTimelineView ()

/* UI Handlers */
- (IBAction)onLeftBracketMoved:(id)sender;
- (IBAction)onRightBracketMoved:(id)sender;
- (IBAction)onBracketsMoved:(id)sender;
- (IBAction)onBracketsPinched:(id)sender;

@end

@implementation CBTimelineView
@synthesize currentTime, leftBracketTime, rightBracketTime, delegate;

- (id)initWithFrame:(CGRect)frame andAsset:(AVAsset *)videoAsset
{
    self = [super initWithFrame:frame];
    if (self) {

        // Retain the video asset while we are working on the timeline
        _asset = [videoAsset retain];
        
        _generator = [[AVAssetImageGenerator alloc] initWithAsset:_asset];
        _generator.requestedTimeToleranceBefore = kCMTimeZero;
        _generator.requestedTimeToleranceAfter = kCMTimeZero;
        _generator.appliesPreferredTrackTransform = YES;
        
        _cursor = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iPhone-Screen 7-Progress Stick.png"]];
        _cursor.frame = CGRectMake(0, 0, 8, 40);
        
        _leftBracket = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iPhone-Screen 12-Bracket Left.png"]];
        _leftBracket.frame = CGRectMake(0, 0, 30, 40);
        _leftBracket.layer.anchorPoint = CGPointMake(0.5, 0.5);
        _leftBracket.userInteractionEnabled = YES;
        UIPanGestureRecognizer* lPan = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onLeftBracketMoved:)] autorelease];
        [_leftBracket addGestureRecognizer:lPan];
        
        _rightBracket = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iPhone-Screen 12-Bracket Right.png"]];
        _rightBracket.frame = CGRectMake(0, 0, 30, 40);
        _rightBracket.layer.anchorPoint = CGPointMake(0.5, 0.5);
        _rightBracket.userInteractionEnabled = YES;
        UIPanGestureRecognizer* rPan = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onRightBracketMoved:)] autorelease];
        [_rightBracket addGestureRecognizer:rPan];

        
        UIPanGestureRecognizer* pan = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onBracketsMoved:)] autorelease];
        [self addGestureRecognizer:pan];

        UIPinchGestureRecognizer* pinch = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onBracketsPinched:)] autorelease];
        [self addGestureRecognizer:pinch];

        
        _leftScreen = [[UIView alloc] initWithFrame:CGRectMake(0, 2, self.frame.size.width, IMAGE_HEIGHT)];
        _leftScreen.backgroundColor = [UIColor blackColor];
        _leftScreen.alpha = 0.5;
        _rightScreen = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, 2, 0, IMAGE_HEIGHT)];
        _rightScreen.backgroundColor = [UIColor blackColor];
        _rightScreen.alpha = 0.5;
         
        [self addSubview:_leftScreen];
        [self addSubview:_rightScreen];
        
        Float64 durationSeconds = CMTimeGetSeconds([_asset duration]);
        Float64 leftStartTime = MAX(0.0, durationSeconds - MAX_DURATION);
        Float64 rightEndTime = MIN(durationSeconds, leftStartTime + MAX_DURATION);
        
        self.leftBracketTime = CMTimeMakeWithSeconds(leftStartTime, 600);
        self.rightBracketTime = CMTimeMakeWithSeconds(rightEndTime, 600); 
        self.currentTime = leftBracketTime;
        _maxBracketDistance = (MAX_DURATION / durationSeconds) * self.frame.size.width;
        
        
        [self insertSubview:_cursor belowSubview:_leftScreen];
        [self insertSubview:_leftBracket belowSubview:_leftScreen];
        [self insertSubview:_rightBracket belowSubview:_leftScreen];
        
        // Detach a new thread to generate thumbnails from the video asset
        [NSThread detachNewThreadSelector:@selector(displayImages:) toTarget:self withObject:nil];

    }
    return self;
}

- (void) dealloc {
    [_cursor release];
    [_leftBracket release];
    [_rightBracket release];
    [_leftScreen release];
    [_rightScreen release];

    [_generator release];
    [_asset release];
    [super dealloc];
}

- (void) setCurrentTime:(CMTime)time {
    currentTime = time;
    [self updatePosition:_cursor withTime:time];
}

- (void) setLeftBracketTime:(CMTime)time {
    leftBracketTime = time;
    [self updatePosition:_leftBracket withTime:time];
    [self updateScreens];
}

- (void) setRightBracketTime:(CMTime)time {
    rightBracketTime = time;
    [self updatePosition:_rightBracket withTime:time];
    [self updateScreens];
}

- (void) updatePosition:(UIImageView*)image withTime:(CMTime)time {
    float posX = [self mapTimeToPos:time];
    CGPoint pos = CGPointMake(posX, image.center.y);
    image.center = pos;
}

- (void) updateScreens {
    _leftScreen.frame = CGRectMake(0, 2, _leftBracket.center.x, IMAGE_HEIGHT);
    _rightScreen.frame = CGRectMake(_rightBracket.center.x, 2, self.frame.size.width - _rightBracket.center.x, IMAGE_HEIGHT);
}

- (float) mapTimeToPos:(CMTime)time {
    Float64 timeS = CMTimeGetSeconds(time);
    Float64 durationS = CMTimeGetSeconds(_asset.duration);
    return MIN(MAX(0, (timeS / durationS) * self.frame.size.width), self.frame.size.width);
}

- (CMTime) mapPosToTime:(float)pos {
    Float64 durationS = CMTimeGetSeconds(_asset.duration);
    float actualTimeS = (pos / self.frame.size.width) * durationS;
    return CMTimeMakeWithSeconds(actualTimeS, 600);
}

- (void) displayImages:(id)obj {
    @autoreleasepool {
        int imagesToShow = self.frame.size.width / IMAGE_WIDTH;
        Float64 avgFrameSpacing = CMTimeGetSeconds(_asset.duration) / imagesToShow;
        CMTime actualTime;
        NSError* error;
        
        for (int i = 0; i < imagesToShow; i++) {
            CMTime offsetTime = CMTimeMakeWithSeconds(i * avgFrameSpacing, 600);
            CGImageRef imgRef = [_generator copyCGImageAtTime:offsetTime actualTime:&actualTime error:&error];
            
            UIImage* image = [[[UIImage alloc] initWithCGImage:imgRef] autorelease];
            UIImageView* imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
            CGImageRelease(imgRef);
            imageView.frame = CGRectMake(i * IMAGE_WIDTH, 2, IMAGE_WIDTH, IMAGE_HEIGHT);
            [self performSelectorOnMainThread:@selector(addThumbnail:) withObject:imageView waitUntilDone:NO];
        }
        [self performSelectorOnMainThread:@selector(onThumbnailsGenerated:) withObject:nil waitUntilDone:NO];
        
    }
}

- (IBAction)addThumbnail:(UIImageView*)imageView {
    [self insertSubview:imageView belowSubview:_cursor];
}

- (void) onThumbnailsGenerated:(id)obj {
    if (self.delegate != nil) 
        [self.delegate onTimelineGenerated];
}

- (IBAction)onLeftBracketMoved:(id)sender {
    UIPanGestureRecognizer* gesture = (UIPanGestureRecognizer*)sender;
    CGPoint newPos = [gesture translationInView:self];
    newPos.x += _leftBracket.center.x;
    newPos.y = _leftBracket.center.y;
    newPos.x = MIN(MAX(0, newPos.x), _rightBracket.frame.origin.x);
    leftBracketTime = [self mapPosToTime:newPos.x];
    
    //NSLog(@"left bracket moved: x = %f  time = %lf", newPos.x, CMTimeGetSeconds(leftBracketTime));
    _leftBracket.center = newPos;
    [gesture setTranslation:CGPointZero inView:self];
    
    if (CMTIME_COMPARE_INLINE(CMTimeSubtract(rightBracketTime, leftBracketTime), >, CMTimeMakeWithSeconds(MAX_DURATION, 600))) {
        [self setRightBracketTime:CMTimeAdd(leftBracketTime, CMTimeMakeWithSeconds(MAX_DURATION, 600))];
    }
    [self updateScreens];
}

- (IBAction)onRightBracketMoved:(id)sender {
    UIPanGestureRecognizer* gesture = (UIPanGestureRecognizer*)sender;    
    CGPoint newPos = [gesture translationInView:self];
    newPos.x += _rightBracket.center.x;
    newPos.y = _rightBracket.center.y;
    newPos.x = MIN(MAX(_leftBracket.frame.origin.x + _leftBracket.frame.size.width, newPos.x), self.frame.size.width);
    rightBracketTime = [self mapPosToTime:newPos.x];
    //NSLog(@"left bracket moved: x = %f  time = %lf", newPos.x, CMTimeGetSeconds(rightBracketTime));
    _rightBracket.center = newPos;
    [gesture setTranslation:CGPointZero inView:self];
    
    if (CMTIME_COMPARE_INLINE(CMTimeSubtract(rightBracketTime, leftBracketTime), >, CMTimeMakeWithSeconds(MAX_DURATION, 600))) {
        [self setLeftBracketTime:CMTimeSubtract(rightBracketTime, CMTimeMakeWithSeconds(MAX_DURATION, 600))];
    }
    [self updateScreens];
}

- (IBAction)onBracketsMoved:(id)sender {
    UIPanGestureRecognizer* gesture = (UIPanGestureRecognizer*)sender;
    CGPoint newPos = [gesture translationInView:self];
    float bracketWidth = _rightBracket.center.x - _leftBracket.center.x;

    CGPoint leftPos = CGPointMake(_leftBracket.center.x + newPos.x, _leftBracket.center.y);
    leftPos.x = MIN(MAX(0, leftPos.x), self.frame.size.width - bracketWidth);
    leftBracketTime = [self mapPosToTime:leftPos.x];
    
    CGPoint rightPos = CGPointMake(leftPos.x + bracketWidth, _rightBracket.center.y);
    rightBracketTime = [self mapPosToTime:rightPos.x];
    
    //NSLog(@"left bracket moved: x = %f  time = %lf", newPos.x, CMTimeGetSeconds(leftBracketTime));
    _leftBracket.center = leftPos;
    _rightBracket.center = rightPos;
    
    [gesture setTranslation:CGPointZero inView:self];
    [self updateScreens];
}

- (IBAction)onBracketsPinched:(id)sender {
    UIPinchGestureRecognizer* pinch = (UIPinchGestureRecognizer*)sender;
    
    float bracketSpan = (_rightBracket.center.x - _leftBracket.center.x) / 2;
    float bracketCenter = _leftBracket.center.x + bracketSpan;
    float pinchVector = bracketSpan * pinch.scale;
    CGPoint leftPos = CGPointMake(bracketCenter - pinchVector, _leftBracket.center.y);
    leftPos.x = MAX(0, leftPos.x);
    leftBracketTime = [self mapPosToTime:leftPos.x];
    
    CGPoint rightPos = CGPointMake(bracketCenter + pinchVector, _rightBracket.center.y);
    rightPos.x = MIN(MIN(rightPos.x, self.frame.size.width), leftPos.x + _maxBracketDistance);
    rightBracketTime = [self mapPosToTime:rightPos.x];
    
    //NSLog(@"left bracket moved: x = %f  time = %lf", newPos.x, CMTimeGetSeconds(leftBracketTime));
    _leftBracket.center = leftPos;
    _rightBracket.center = rightPos;
    pinch.scale = 1.0;
    [self updateScreens];
}

@end
