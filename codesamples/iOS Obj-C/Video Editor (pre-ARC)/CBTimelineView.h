//
//  CBTimelineView.h
//  Color Beast
//
//  Created by Tim Hingston on 7/9/12.
//  Copyright (c) 2012 Shape Massive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol CBTimelineViewDelegate <NSObject>

/* Called when the timeline is finished generating from an asset */
- (void) onTimelineGenerated;

@end

@interface CBTimelineView : UIView {
    @protected
        AVAsset* _asset;
        AVAssetImageGenerator* _generator;
        UIImageView* _cursor;
        UIImageView* _leftBracket;
        UIImageView* _rightBracket;
        UIView* _leftScreen;
        UIView* _rightScreen;
        float _maxBracketDistance;
}

/** 
 * Initialize the view with a frame size and video asset
 */
- (id)initWithFrame:(CGRect)frame andAsset:(AVAsset *)videoAsset;

/* The current time position of the cursor */
@property (nonatomic, assign) CMTime currentTime;

/* The current left bracket time position */
@property (nonatomic, assign) CMTime leftBracketTime;

/* The current right bracket time position */
@property (nonatomic, assign) CMTime rightBracketTime;

/* Delegate to receive CBTimelineViewDelegate callbacks */
@property (nonatomic, assign) id delegate;

@end
