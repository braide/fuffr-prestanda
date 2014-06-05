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
    [self.textField setDelegate:self];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
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

//----------------------------BUTTONS---------------------------

- (IBAction)tapButton:(UIButton *)sender {
    int numberOfGestures = [self.textField.text intValue];
    int counter = 0;
    FFRTapGestureRecognizer *tap;
    for (int i=0; i<[self.gestureRecognizedArray count]; i++) {
        if(tap == [self.gestureRecognizedArray objectAtIndex:i])
            counter++;
    }
    float accuracy = (float)counter/numberOfGestures;
    NSLog(@"Accuracy: %f", accuracy);
    NSLog(@"NumOfGestures: %d\nNumOfTaps: %d", numberOfGestures, counter);
}

- (IBAction)doubleTapButton:(UIButton *)sender {
    int numberOfGestures = [self.textField.text intValue];
    int counter = 0;
    FFRDoubleTapGestureRecognizer *dtap;
    for (int i=0; i<[self.gestureRecognizedArray count]; i++) {
        if(dtap == [self.gestureRecognizedArray objectAtIndex:i])
            counter++;
    }
    float accuracy = (float)counter/numberOfGestures;
    NSLog(@"Accuracy: %f", accuracy);
    NSLog(@"NumOfGestures: %d\nNumOfDoubleTaps: %d", numberOfGestures, counter);

}

- (IBAction)longPressButton:(UIButton *)sender {
    int numberOfGestures = [self.textField.text intValue];
    int counter = 0;
    FFRLongPressGestureRecognizer *longPress;
    for (int i=0; i<[self.gestureRecognizedArray count]; i++) {
        if(longPress == [self.gestureRecognizedArray objectAtIndex:i])
            counter++;
    }
    float accuracy = (float)counter/numberOfGestures;
    NSLog(@"Accuracy: %f", accuracy);
    NSLog(@"NumOfGestures: %d\nNumOfLongPresses: %d", numberOfGestures, counter);

}

- (IBAction)rotateButton:(UIButton *)sender {
    int numberOfGestures = [self.textField.text intValue];
    int counter = 0;
    FFRRotationGestureRecognizer *rotate;
    for (int i=0; i<[self.gestureRecognizedArray count]; i++) {
        if(rotate == [self.gestureRecognizedArray objectAtIndex:i])
            counter++;
    }
    float accuracy = (float)counter/numberOfGestures;
    NSLog(@"Accuracy: %f", accuracy);
    NSLog(@"NumOfGestures: %d\nNumOfRotates: %d", numberOfGestures, counter);

}

- (IBAction)panButton:(UIButton *)sender {
    int numberOfGestures = [self.textField.text intValue];
    int counter = 0;
    FFRPanGestureRecognizer *pan;
    for (int i=0; i<[self.gestureRecognizedArray count]; i++) {
        if(pan == [self.gestureRecognizedArray objectAtIndex:i])
            counter++;
    }
    float accuracy = (float)counter/numberOfGestures;
    NSLog(@"Accuracy: %f", accuracy);
    NSLog(@"NumOfGestures: %d\nNumOfPans: %d", numberOfGestures, counter);

}

- (IBAction)pinchButton:(UIButton *)sender {
    int numberOfGestures = [self.textField.text intValue];
    int counter = 0;
    FFRPinchGestureRecognizer *pinch;
    for (int i=0; i<[self.gestureRecognizedArray count]; i++) {
        if(pinch == [self.gestureRecognizedArray objectAtIndex:i])
            counter++;
    }
    float accuracy = (float)counter/numberOfGestures;
    NSLog(@"Accuracy: %f", accuracy);
    NSLog(@"NumOfGestures: %d\nNumOfPinches: %d", numberOfGestures, counter);

}

- (IBAction)swipeLeftButton:(UIButton *)sender {
    int numberOfGestures = [self.textField.text intValue];
    int counter = 0;
    FFRSwipeGestureRecognizer *swipeL = [FFRSwipeGestureRecognizer new];
    swipeL.direction = FFRSwipeGestureRecognizerDirectionLeft;
    FFRSwipeGestureRecognizer *swipeTemp;
    for (int i=0; i<[self.gestureRecognizedArray count]; i++) {
        if(swipeL == [self.gestureRecognizedArray objectAtIndex:i]){
            swipeTemp = [self.gestureRecognizedArray objectAtIndex:i];
            if(swipeL.direction == swipeTemp.direction){
                counter++;
            }
        }
    }
    float accuracy = (float)counter/numberOfGestures;
    NSLog(@"Accuracy: %f", accuracy);
    NSLog(@"NumOfGestures: %d\nNumOfSwipesToTheLeft: %d", numberOfGestures, counter);
}

- (IBAction)swipeRightButton:(UIButton *)sender {
    int numberOfGestures = [self.textField.text intValue];
    int counter = 0;
    FFRSwipeGestureRecognizer *swipeR = [FFRSwipeGestureRecognizer new];
    swipeR.direction = FFRSwipeGestureRecognizerDirectionRight;
    FFRSwipeGestureRecognizer *swipeTemp;
    for (int i=0; i<[self.gestureRecognizedArray count]; i++) {
        if(swipeR == [self.gestureRecognizedArray objectAtIndex:i]){
            swipeTemp = [self.gestureRecognizedArray objectAtIndex:i];
            if(swipeR.direction == swipeTemp.direction){
                counter++;
            }
        }
    }
    float accuracy = (float)counter/numberOfGestures;
    NSLog(@"Accuracy: %f", accuracy);
    NSLog(@"NumOfGestures: %d\nNumOfSwipesToTheRight: %d", numberOfGestures, counter);
}

- (IBAction)swipeUpButton:(UIButton *)sender {
    int numberOfGestures = [self.textField.text intValue];
    int counter = 0;
    FFRSwipeGestureRecognizer *swipeU = [FFRSwipeGestureRecognizer new];
    swipeU.direction = FFRSwipeGestureRecognizerDirectionUp;
    FFRSwipeGestureRecognizer *swipeTemp;
    for (int i=0; i<[self.gestureRecognizedArray count]; i++) {
        if(swipeU == [self.gestureRecognizedArray objectAtIndex:i]){
            swipeTemp = [self.gestureRecognizedArray objectAtIndex:i];
            if(swipeU.direction == swipeTemp.direction){
                counter++;
            }
        }
    }
    float accuracy = (float)counter/numberOfGestures;
    NSLog(@"Accuracy: %f", accuracy);
    NSLog(@"NumOfGestures: %d\nNumOfSwipesUp: %d", numberOfGestures, counter);

}

- (IBAction)swipeDownButon:(UIButton *)sender {
    int numberOfGestures = [self.textField.text intValue];
    int counter = 0;
    FFRSwipeGestureRecognizer *swipeD = [FFRSwipeGestureRecognizer new];
    swipeD.direction = FFRSwipeGestureRecognizerDirectionDown;
    FFRSwipeGestureRecognizer *swipeTemp;
    for (int i=0; i<[self.gestureRecognizedArray count]; i++) {
        if(swipeD == [self.gestureRecognizedArray objectAtIndex:i]){
            swipeTemp = [self.gestureRecognizedArray objectAtIndex:i];
            if(swipeD.direction == swipeTemp.direction){
                counter++;
            }
        }
    }
    float accuracy = (float)counter/numberOfGestures;
    NSLog(@"Accuracy: %f", accuracy);
    NSLog(@"NumOfGestures: %d\nNumOfSwipesDown: %d", numberOfGestures, counter);

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
