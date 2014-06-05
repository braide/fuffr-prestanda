//
//  GestureRecognitionViewController.m
//  TestingIRsensors
//
//  Created by Fuffr1 on 31/05/14.
//  Copyright (c) 2014 Fuffr1. All rights reserved.
//

#import "GestureRecognitionViewController.h"

@interface GestureRecognitionViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *swipeDirectionView;
@property (strong, nonatomic) NSArray *directionArray;
@property int currentSwipeDirection;
@property int currentGestureCounter;
@property int numOfGesturesSuggested;
@property (weak, nonatomic) IBOutlet UITextField *numOfGestureField;

@end

@implementation GestureRecognitionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFuffr];
    self.directionArray = [[NSArray alloc] initWithObjects:@"Up",@"Down",@"Right",@"Left", nil];
    self.currentSwipeDirection = FFRSwipeGestureRecognizerDirectionUp;
    self.currentGestureCounter = 1;
    [self.numOfGestureField setDelegate:self];
}

-(void)setupFuffr{
    
    [[FFRTouchManager sharedManager]
     enableSides: FFRSideLeft | FFRSideRight | FFRSideTop | FFRSideBottom
     touchesPerSide: @2];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.numOfGestureField resignFirstResponder];
    return YES;
}

  //Change all gestures
- (IBAction)buttonPressed:(UIButton *)sender {
    NSString *numOfGestures = self.numOfGestureField.text;
    self.numOfGesturesSuggested = [numOfGestures intValue];
    NSLog(@"%d",self.numOfGesturesSuggested);
    self.currentGestureCounter = 0;
    NSString *title = sender.titleLabel.text;
    FFRTouchManager* manager = [FFRTouchManager sharedManager];
    [manager removeAllGestureRecognizers];
    
    if([title isEqualToString:@"Tap"]){
        FFRTapGestureRecognizer* tap = [FFRTapGestureRecognizer new];
        tap.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
        [tap addTarget: self action: @selector(onTap:)];
        [manager addGestureRecognizer: tap];
        
    }else if([title isEqualToString:@"DoubleTap"]){
        FFRDoubleTapGestureRecognizer* doubleTap = [FFRDoubleTapGestureRecognizer new];
        doubleTap.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
        doubleTap.maximumDistance = 100.0;
        doubleTap.maximumDuration = 1.0;
        [doubleTap addTarget: self action: @selector(onDoubleTap:)];
        [manager addGestureRecognizer: doubleTap];
        
    }else if([title isEqualToString:@"LongPress"]){
        FFRLongPressGestureRecognizer* longPress = [FFRLongPressGestureRecognizer new];
        longPress.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
        longPress.maximumDistance = 50.0;
        longPress.minimumDuration = 1.0;
        [longPress addTarget: self action: @selector(onLongPress:)];
        [manager addGestureRecognizer: longPress];
    
    }else if([title isEqualToString:@"Swipe"]){
        FFRSwipeGestureRecognizer *swipe = [FFRSwipeGestureRecognizer new];
        swipe.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
        swipe.minimumDistance = 50.0;
        swipe.direction = self.currentSwipeDirection;
        swipe.maximumDuration = 1.0;
        [swipe addTarget:self action:@selector(onSwipe:)];
        [manager addGestureRecognizer:swipe];
        
    }else if([title isEqualToString:@"Pan"]){
        FFRPanGestureRecognizer* pan = [FFRPanGestureRecognizer new];
        pan.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
        [pan addTarget: self action: @selector(onPan:)];
        [manager addGestureRecognizer: pan];
        
    }else if([title isEqualToString:@"Pinch"]){
        FFRPinchGestureRecognizer* pinch = [FFRPinchGestureRecognizer new];
        pinch.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
        [pinch addTarget: self action: @selector(onPinch:)];
        [manager addGestureRecognizer: pinch];
        
    }else if([title isEqualToString:@"Rotate"]){
        FFRRotationGestureRecognizer* rotate = [FFRRotationGestureRecognizer new];
        rotate.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
        [rotate addTarget: self action: @selector(onRotate:)];
        [manager addGestureRecognizer: rotate];
    }
}

- (IBAction)doneButtonPressed:(UIButton *)sender {
    NSLog(@"%d %d", self.currentGestureCounter, self.numOfGesturesSuggested);
    double accuracy = self.currentGestureCounter / self.numOfGesturesSuggested;
    NSLog(@"accuracy = %f", accuracy);
}

-(void)onTap:(id)sender{
    self.currentGestureCounter++;
    NSLog(@"Tap %d", self.currentGestureCounter);
}
-(void)onDoubleTap:(id)sender{
    self.currentGestureCounter++;
    NSLog(@"DoubleTap %d", self.currentGestureCounter);
}
-(void)onLongPress:(id)sender{
    self.currentGestureCounter++;
    NSLog(@"Longpress %d", self.currentGestureCounter);
}
- (void)onSwipe:(FFRSwipeGestureRecognizer *)gesture
{
    self.currentGestureCounter++;
     NSLog(@"Swipe %d", self.currentGestureCounter);
}
-(void)onPan:(id)sender{
    self.currentGestureCounter++;
    NSLog(@"Pan %d", self.currentGestureCounter);
}
-(void)onPinch:(id)sender{
    self.currentGestureCounter++;
    NSLog(@"Pinch %d", self.currentGestureCounter);
}
-(void)onRotate:(id)sender{
    self.currentGestureCounter++;
    NSLog(@"Rotate %d", self.currentGestureCounter);
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 4;
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [self.directionArray objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    NSLog(@"current row: %ld",(long)row);
    // logic here. What to do when one row is selected
    switch (row) {
        case 0:
            self.currentSwipeDirection = FFRSwipeGestureRecognizerDirectionUp;
            break;
        case 1:
            self.currentSwipeDirection = FFRSwipeGestureRecognizerDirectionDown;
            break;
        case 2:
            self.currentSwipeDirection = FFRSwipeGestureRecognizerDirectionRight;
            break;
        case 3:
            self.currentSwipeDirection = FFRSwipeGestureRecognizerDirectionLeft;
            break;
            
        default:
            break;
    }
}

- (CGFloat)distanceBetween:(CGPoint) p1 to: (CGPoint) p2
{
    CGFloat xDist = (p2.x - p1.x);
    CGFloat yDist = (p2.y - p1.y);
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
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
