//
//  MultipleGestPerSideViewController.m
//  TestingIRsensors
//
//  Created by Fuffr1 on 31/05/14.
//  Copyright (c) 2014 Fuffr1. All rights reserved.
//

#import "MultipleGestPerSideViewController.h"

@interface MultipleGestPerSideViewController ()

@end

@implementation MultipleGestPerSideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFuffr];
    [self setupGestureRecognizers];
}

-(void)setupFuffr{
    
    [[FFRTouchManager sharedManager]
     enableSides: FFRSideLeft | FFRSideRight | FFRSideTop | FFRSideBottom
     touchesPerSide: @1];
}

-(void)setupGestureRecognizers{
    FFRTouchManager* manager = [FFRTouchManager sharedManager];
    FFRTapGestureRecognizer* tap = [FFRTapGestureRecognizer new];
    tap.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
    [tap addTarget: self action: @selector(onTap:)];
    [manager addGestureRecognizer: tap];
    
    FFRDoubleTapGestureRecognizer* doubleTap = [FFRDoubleTapGestureRecognizer new];
    doubleTap.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
    doubleTap.maximumDistance = 100.0;
    doubleTap.maximumDuration = 1.0;
    [doubleTap addTarget: self action: @selector(onDoubleTap:)];
    [manager addGestureRecognizer: doubleTap];
    

    FFRLongPressGestureRecognizer* longPress = [FFRLongPressGestureRecognizer new];
    longPress.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
    longPress.maximumDistance = 50.0;
    longPress.minimumDuration = 1.0;
    [longPress addTarget: self action: @selector(onLongPress:)];
    [manager addGestureRecognizer: longPress];
    

    FFRSwipeGestureRecognizer* swipeLeft = [FFRSwipeGestureRecognizer new];
    swipeLeft.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
    swipeLeft.direction = FFRSwipeGestureRecognizerDirectionLeft;
    swipeLeft.minimumDistance = 50.0;
    swipeLeft.maximumDuration = 1.0;
    [swipeLeft addTarget: self action: @selector(onSwipe:)];
    [manager addGestureRecognizer: swipeLeft];
    
    FFRSwipeGestureRecognizer* swipeRight = [FFRSwipeGestureRecognizer new];
    swipeRight.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
    swipeRight.direction = FFRSwipeGestureRecognizerDirectionRight;
    swipeRight.minimumDistance = 50.0;
    swipeRight.maximumDuration = 1.0;
    [swipeRight addTarget: self action: @selector(onSwipe:)];
    [manager addGestureRecognizer: swipeRight];
    
    FFRSwipeGestureRecognizer* swipeUp = [FFRSwipeGestureRecognizer new];
    swipeUp.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
    swipeUp.direction = FFRSwipeGestureRecognizerDirectionUp;
    swipeUp.minimumDistance = 50.0;
    swipeUp.maximumDuration = 1.0;
    [swipeUp addTarget: self action: @selector(onSwipe:)];
    [manager addGestureRecognizer: swipeUp];
    
    FFRSwipeGestureRecognizer* swipeDown = [FFRSwipeGestureRecognizer new];
    swipeDown.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
    swipeDown.direction = FFRSwipeGestureRecognizerDirectionDown;
    swipeDown.minimumDistance = 50.0;
    swipeDown.maximumDuration = 1.0;
    [swipeDown addTarget: self action: @selector(onSwipe:)];
    [manager addGestureRecognizer: swipeDown];
    

    FFRPanGestureRecognizer* pan = [FFRPanGestureRecognizer new];
    pan.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
    [pan addTarget: self action: @selector(onPan:)];
    [manager addGestureRecognizer: pan];
    

    FFRPinchGestureRecognizer* pinch = [FFRPinchGestureRecognizer new];
    pinch.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
    [pinch addTarget: self action: @selector(onPinch:)];
    [manager addGestureRecognizer: pinch];
    

    FFRRotationGestureRecognizer* rotate = [FFRRotationGestureRecognizer new];
    rotate.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
    [rotate addTarget: self action: @selector(onRotate:)];
    [manager addGestureRecognizer: rotate];

}

-(void)onTap:(id)sender{
    NSLog(@"tap");
}
-(void)onDoubleTap:(id)sender{
    NSLog(@"DoubleTap");
}
-(void)onLongPress:(id)sender{
    NSLog(@"LongPress");
}
-(void)onSwipe:(id)sender{
    NSLog(@"Swipe");
}
-(void)onPan:(id)sender{
    NSLog(@"Pan");
}
-(void)onPinch:(id)sender{
    NSLog(@"Pinch");
}
-(void)onRotate:(id)sender{
    NSLog(@"Rotate");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
