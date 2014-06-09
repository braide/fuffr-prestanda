//
//  MultipleGestPerSideViewController.m
//  TestingIRsensors
//
//  Created by Fuffr1 on 31/05/14.
//  Copyright (c) 2014 Fuffr1. All rights reserved.
//

#import "MultipleGestPerSideViewController.h"
#import "MultipleGestureModel.h"

@interface MultipleGestPerSideViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic) NSMutableArray *gestureRecognizedArray;
@property int tap, dtap, lpress, swipeL, swipeR, swipeU, swipeD, pan, pinch, rotate, counter;
@end

@implementation MultipleGestPerSideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFuffr];
    [self setupGestureRecognizers];
    [self.textField setDelegate:self];
    self.tap = 0;
    self.dtap = 1;
    self.lpress= 2;
    self.swipeR = 3;
    self.swipeL = 4;
    self.swipeU = 5;
    self.swipeD = 6;
    self.pan = 7;
    self.pinch = 8;
    self.rotate = 9;
    self.counter = 0;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}
- (IBAction)resetButton:(UIButton *)sender {
    self.textField = 0;
    self.gestureRecognizedArray = nil;
    self.counter = 0;
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

//---------------------------Gesturefunctions---------------------------------

-(void)onTap:(FFRTapGestureRecognizer *)sender{
    NSLog(@"tap");
    MultipleGestureModel *gesture = [[MultipleGestureModel alloc]init];
    gesture.context = self.tap;
    self.counter++;
    [self.gestureRecognizedArray addObject:gesture];
}
-(void)onDoubleTap:(FFRDoubleTapGestureRecognizer*)sender{
    NSLog(@"DoubleTap");
    MultipleGestureModel *gesture = [[MultipleGestureModel alloc]init];
    gesture.context = self.dtap;
    self.counter++;
    [self.gestureRecognizedArray addObject:gesture];
}
-(void)onLongPress:(FFRLongPressGestureRecognizer*)sender{
    NSLog(@"LongPress");
    MultipleGestureModel *gesture = [[MultipleGestureModel alloc]init];
    gesture.context = self.lpress;
    self.counter++;
    [self.gestureRecognizedArray addObject:gesture];
}
-(void)onSwipeL:(FFRSwipeGestureRecognizer*)sender{
    NSLog(@"SwipeL");
    MultipleGestureModel *gesture = [[MultipleGestureModel alloc]init];
    gesture.context = self.swipeL;
    self.counter++;
    [self.gestureRecognizedArray addObject:gesture];
}
-(void)onSwipeR:(FFRSwipeGestureRecognizer*)sender{
    NSLog(@"SwipeR");
    MultipleGestureModel *gesture = [[MultipleGestureModel alloc]init];
    gesture.context = self.swipeR;
    self.counter++;
    [self.gestureRecognizedArray addObject:gesture];
}
-(void)onSwipeU:(FFRSwipeGestureRecognizer*)sender{
    NSLog(@"SwipeU");
    MultipleGestureModel *gesture = [[MultipleGestureModel alloc]init];
    gesture.context = self.swipeU;
    self.counter++;
    [self.gestureRecognizedArray addObject:gesture];
}
-(void)onSwipeD:(FFRSwipeGestureRecognizer*)sender{
    NSLog(@"SwipeD");
    MultipleGestureModel *gesture = [[MultipleGestureModel alloc]init];
    gesture.context = self.swipeD;
    self.counter++;
    [self.gestureRecognizedArray addObject:gesture];
}
-(void)onPan:(FFRPanGestureRecognizer*)sender{
    if(sender.state == FFRGestureRecognizerStateBegan){
        NSLog(@"Pan");
        MultipleGestureModel *gesture = [[MultipleGestureModel alloc]init];
        gesture.context = self.pan;
        self.counter++;
        [self.gestureRecognizedArray addObject:gesture];
    }
    
}
-(void)onPinch:(FFRPinchGestureRecognizer*)sender{
    if(sender.state == FFRGestureRecognizerStateBegan){
        NSLog(@"Pinch");
        MultipleGestureModel *gesture = [[MultipleGestureModel alloc]init];
        gesture.context = self.pinch;
        self.counter++;
        [self.gestureRecognizedArray addObject:gesture];
    }
}
-(void)onRotate:(FFRRotationGestureRecognizer*)sender{
    if(sender.state == FFRGestureRecognizerStateBegan){
        NSLog(@"Rotate");
        MultipleGestureModel *gesture = [[MultipleGestureModel alloc]init];
        gesture.context = self.rotate;
        self.counter++;
        [self.gestureRecognizedArray addObject:gesture];
    }
}

//----------------------------BUTTONS---------------------------

-(void)calculateAccuracy:(int)gesture{
    int numberOfGestures = [self.textField.text intValue];
    int correctGesture = 0;
    int extra = 0;
    MultipleGestureModel *gest;
    for (int i=0; i<[self.gestureRecognizedArray count]; i++) {
        gest = [self.gestureRecognizedArray objectAtIndex:i];
        if(gest.context == gesture){
            correctGesture++;
        }
    }
    extra = (int)[self.gestureRecognizedArray count]-correctGesture;
    float accuracy = (float)correctGesture/numberOfGestures;
    NSLog(@"Accuracy: %f", accuracy);
    NSLog(@"TotalGesturesRecognized: %d\nNumOfCorrectGestures: %d\nExtraGesturesRecognized: %d", numberOfGestures, correctGesture, extra);
}

- (IBAction)tapButton:(UIButton *)sender {
    [self calculateAccuracy:self.tap];
}

- (IBAction)doubleTapButton:(UIButton *)sender {
    [self calculateAccuracy:self.dtap];

}

- (IBAction)longPressButton:(UIButton *)sender {
    [self calculateAccuracy:self.lpress];

}

- (IBAction)rotateButton:(UIButton *)sender {
    [self calculateAccuracy:self.rotate];

}

- (IBAction)panButton:(UIButton *)sender {
    [self calculateAccuracy:self.pan];

}

- (IBAction)pinchButton:(UIButton *)sender {
    [self calculateAccuracy:self.pinch];

}

- (IBAction)swipeLeftButton:(UIButton *)sender {
    [self calculateAccuracy:self.swipeL];
}

- (IBAction)swipeRightButton:(UIButton *)sender {
    [self calculateAccuracy:self.swipeR];
}

- (IBAction)swipeUpButton:(UIButton *)sender {
    [self calculateAccuracy:self.swipeU];

}

- (IBAction)swipeDownButon:(UIButton *)sender {
    [self calculateAccuracy:self.swipeD];

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
