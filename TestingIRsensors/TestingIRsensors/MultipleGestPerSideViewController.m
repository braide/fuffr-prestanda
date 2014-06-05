//
//  MultipleGestPerSideViewController.m
//  TestingIRsensors
//
//  Created by Fuffr1 on 31/05/14.
//  Copyright (c) 2014 Fuffr1. All rights reserved.
//

#import "MultipleGestPerSideViewController.h"

@interface MultipleGestPerSideViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic) NSMutableArray *gestureRecognizedArray;

@end

@implementation MultipleGestPerSideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFuffr];
    [self setupGestureRecognizers];
}

-(NSMutableArray *)gestureRecognizedArray{
    if(!_gestureRecognizedArray){
        _gestureRecognizedArray = [[NSMutableArray alloc]init];
    }
    return _gestureRecognizedArray;
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
    [swipeLeft addTarget: self action: @selector(onSwipeL:)];
    [manager addGestureRecognizer: swipeLeft];
    
    FFRSwipeGestureRecognizer* swipeRight = [FFRSwipeGestureRecognizer new];
    swipeRight.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
    swipeRight.direction = FFRSwipeGestureRecognizerDirectionRight;
    swipeRight.minimumDistance = 50.0;
    swipeRight.maximumDuration = 1.0;
    [swipeRight addTarget: self action: @selector(onSwipeR:)];
    [manager addGestureRecognizer: swipeRight];
    
    FFRSwipeGestureRecognizer* swipeUp = [FFRSwipeGestureRecognizer new];
    swipeUp.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
    swipeUp.direction = FFRSwipeGestureRecognizerDirectionUp;
    swipeUp.minimumDistance = 50.0;
    swipeUp.maximumDuration = 1.0;
    [swipeUp addTarget: self action: @selector(onSwipeU:)];
    [manager addGestureRecognizer: swipeUp];
    
    FFRSwipeGestureRecognizer* swipeDown = [FFRSwipeGestureRecognizer new];
    swipeDown.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
    swipeDown.direction = FFRSwipeGestureRecognizerDirectionDown;
    swipeDown.minimumDistance = 50.0;
    swipeDown.maximumDuration = 1.0;
    [swipeDown addTarget: self action: @selector(onSwipeD:)];
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

-(void)onTap:(FFRTapGestureRecognizer *)sender{
    NSLog(@"tap");
    [self.gestureRecognizedArray addObject:sender];
}
-(void)onDoubleTap:(FFRDoubleTapGestureRecognizer*)sender{
    NSLog(@"DoubleTap");
    [self.gestureRecognizedArray addObject:sender];
}
-(void)onLongPress:(FFRLongPressGestureRecognizer*)sender{
    NSLog(@"LongPress");
    [self.gestureRecognizedArray addObject:sender];
}
-(void)onSwipeL:(FFRSwipeGestureRecognizer*)sender{
    NSLog(@"SwipeL");
    [self.gestureRecognizedArray addObject:sender];
}
-(void)onSwipeR:(FFRSwipeGestureRecognizer*)sender{
    NSLog(@"SwipeR");
    [self.gestureRecognizedArray addObject:sender];
}
-(void)onSwipeU:(FFRSwipeGestureRecognizer*)sender{
    NSLog(@"SwipeU");
    [self.gestureRecognizedArray addObject:sender];
}
-(void)onSwipeD:(FFRSwipeGestureRecognizer*)sender{
    NSLog(@"SwipeD");
    [self.gestureRecognizedArray addObject:sender];
}
-(void)onPan:(FFRPanGestureRecognizer*)sender{
    if(sender.state == FFRGestureRecognizerStateBegan){
        NSLog(@"Pan");
        [self.gestureRecognizedArray addObject:sender];
    }
    
}
-(void)onPinch:(FFRPinchGestureRecognizer*)sender{
    if(sender.state == FFRGestureRecognizerStateBegan){
        NSLog(@"Pinch");
        [self.gestureRecognizedArray addObject:sender];
    }
}
-(void)onRotate:(FFRRotationGestureRecognizer*)sender{
    if(sender.state == FFRGestureRecognizerStateBegan){
        NSLog(@"Rotate");
        [self.gestureRecognizedArray addObject:sender];
    }
}

- (IBAction)tapButton:(UIButton *)sender {
    int numberOfGestures = [self.textField.text integerValue];
    int counter = 0;
    for (FFRTapGestureRecognizer *tap in self.gestureRecognizedArray) {
        counter++;
    }
    
    float accuracy = (float)counter/numberOfGestures;
}

- (IBAction)doubleTapButton:(UIButton *)sender {
}

- (IBAction)longPressButton:(UIButton *)sender {
}

- (IBAction)rotateButton:(UIButton *)sender {
}

- (IBAction)panButton:(UIButton *)sender {
}

- (IBAction)pinchButton:(UIButton *)sender {
}

- (IBAction)swipeLeftButton:(UIButton *)sender {
}

- (IBAction)swipeRightButton:(UIButton *)sender {
}

- (IBAction)swipeUpButton:(UIButton *)sender {
}

- (IBAction)swipeDownButon:(UIButton *)sender {
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
