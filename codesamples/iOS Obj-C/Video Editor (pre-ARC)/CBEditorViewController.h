//
//  CBEditorViewController.h
//  Color Beast
//
//  Created by Tim Hingston on 6/28/12.
//  Copyright (c) 2012 Shape Massive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GifBuilder.h"
#import "CBTimelineView.h"
#import "CBProgressView.h"

@protocol CBEditorViewControllerDelegate <NSObject>

@optional
/** 
 * Fired when the user closes the editor view.
 * @param editor: a reference to the editor object
 * @param forShare: true if the editor was closed with share option, false if not
 * @param forRoar: the output file from the edit process if sharing, otherwise nil
 */
- (void)onEditorClosed:(id)editor forShare:(BOOL)share forRoar:(NSURL*)outputFile;

@end

@class CBPlayerView;
@class CBSlider;

/**
 * Player states - playing, paused, seeking (user can initiate seek through moving the trimmer)
 */
typedef enum {
    CBPlayerStatePlaying,
    CBPlayerStatePaused,
    CBPlayerStateSeeking
} CBPlayerState;

/**
 * Roar sizes - user's choice of output GIF size
 */
typedef enum {
    CBRoarSizeSmall,
    CBRoarSizeMedium,
    CBRoarSizeLarge
} CBRoarSize;


/**
 * A stateful video editor object that supports different play rates, loop modes, 
 * and a trimming window.  
 */
@interface CBEditorViewController : UIViewController <GifBuilderDelegate, CBTimelineViewDelegate> {
    @protected
        float _playRate;
        CBLoopMode _loopMode;
        CBPlayerState _playerState;
        CBRoarSize _roarSize;
        NSMutableArray* _audioSSIDs;
}

#pragma mark Properties
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSURL* sourceUrl;


/** 
 * Loads a video asset into the editor.
 * @param file: NSURL that points to the video file.
 */
- (void)loadAssetFromFile:(NSURL*)file;

@end
