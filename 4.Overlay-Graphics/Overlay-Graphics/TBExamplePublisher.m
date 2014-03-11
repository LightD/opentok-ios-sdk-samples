//
//  TBPublisher.m
//  Overlay-Graphics
//
//  Copyright (c) 2014 TokBox, Inc. All rights reserved.
//

#import "TBExamplePublisher.h"
#import "TBExampleVideoCapture.h"
#import "TBExampleGLViewRender.h"
#import "TBExampleVideoView.h"
#import "TBExampleVideoCapture.h"

@implementation TBExamplePublisher {
    TBExampleVideoCapture* _myVideoCapture;
    TBExampleVideoView* _myVideoRender;
}

@synthesize view = _myVideoRender;

#pragma mark - Object lifecycle

- (id)init {
    self = [super init];
    if (self) {
        _myVideoCapture = [[TBExampleVideoCapture alloc] init];
        [self setVideoCapture:_myVideoCapture];
        
        _myVideoRender =
        [[TBExampleVideoView alloc] initWithFrame:CGRectMake(0,0,1,1) delegate:self type:OTVideoViewTypePublisher displayName:nil];
        
        [self setVideoRender:_myVideoRender];

    }
    return self;
}

- (id)initWithDelegate:(id<OTPublisherDelegate>)delegate {
    self = [self init];
    if (self) {
        [self setDelegate:delegate];
    }
    return self;
}

- (id)initWithDelegate:(id<OTPublisherDelegate>)delegate
                  name:(NSString*)name
{
    self = [self init];
    if (self) {
        [self setDelegate:delegate];
        [self setName:name];
    }
    return self;
}

- (void)dealloc {
    [self setVideoCapture:nil];
    [self setVideoRender:nil];
    [_myVideoCapture release];
    _myVideoCapture = nil;
    [_myVideoRender release];
    _myVideoRender = nil;
    [super dealloc];
}

#pragma mark - Overrides for public API

/** 
 * Intercept setter for video capture, so that a client override of our default
 * capture implementation does not leak and make a mess.
 */
- (void)setVideoCapture:(id<OTVideoCapture>)videoCapture {
    [super setVideoCapture:videoCapture];
    [_myVideoCapture release];
    _myVideoCapture = nil;
    
    // Save the new instance if it's still compatible with the
    // TBExampleVideoRender contract
    if ([videoCapture isKindOfClass:[TBExampleVideoCapture class]]) {
        _myVideoCapture = (TBExampleVideoCapture*) videoCapture;
        [_myVideoCapture retain];
    }
}

# pragma mark - TBExamplePublisher API extensions

- (void)setCameraPosition:(AVCaptureDevicePosition)cameraPosition
{
    _myVideoCapture.cameraPosition = cameraPosition;
}

- (AVCaptureDevicePosition)cameraPosition {
    return _myVideoCapture.cameraPosition;
}

#pragma mark - OTVideoViewDelegate

- (void)videoViewDidToggleCamera:(OTVideoView*)videoView {
    [_myVideoCapture toggleCameraPosition];
}

- (void)videoView:(OTVideoView*)videoView
publisherWasMuted:(BOOL)publisherMuted
{
    [self setPublishAudio:!publisherMuted];
}

@end
