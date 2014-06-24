//
//  MultipleGestPerSideViewController.m
//  TestingIRsensors
//
//  Created by Fuffr1 on 31/05/14.
//  Copyright (c) 2014 Fuffr1. All rights reserved.
//

#import "MultipleGestPerSideViewController.h"
#import "MultipleGestureModel.h"
#import "AppDelegate.h"

@interface MultipleGestPerSideViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic) NSMutableArray *gestureRecognizedArray;
@property int tap, dtap, lpress, swipeL, swipeR, swipeU, swipeD, pan, pinch, rotate, counter;
@property (nonatomic) NSString *side;
@property (nonatomic) NSMutableArray *gesturetypesRecognized;
@property (nonatomic) NSMutableArray *stringArray;
@property (weak, nonatomic) IBOutlet UILabel *DebugLabel;
@property (nonatomic) AppDelegate *delegate;
@end

@implementation MultipleGestPerSideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFuffr];
    [self setupGestureRecognizers];
    [self.textField setDelegate:self];
    [self setupVariables];
    self.DebugLabel.text = @"";
    self.delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
}

-(void)setupVariables{
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
    [self fillArray];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}
- (IBAction)sendToServerButton:(UIButton *)sender {
    [self sendToServer];
    self.stringArray = nil;
}

-(NSMutableArray *)gestureRecognizedArray{
    if(!_gestureRecognizedArray){
        _gestureRecognizedArray = [[NSMutableArray alloc]init];
    }
    return _gestureRecognizedArray;
}
-(NSMutableArray *)gesturetypesRecognized{
    if(!_gesturetypesRecognized){
        _gesturetypesRecognized = [[NSMutableArray alloc]init];
    }
    return _gesturetypesRecognized;
}

-(NSMutableArray *)stringArray{
    if(!_stringArray){
        _stringArray = [[NSMutableArray alloc]init];
    }
    return _stringArray;
}

-(void)fillArray{
    MultipleGestureModel *gest;
    for(int i=0; i<10; i++){
        gest = [[MultipleGestureModel alloc]init];
        gest.context = 99;
        [self.gesturetypesRecognized addObject:gest];
    }
}

-(NSString *)giveGesture:(int)gestNum{
    switch (gestNum) {
        case 0:
            return @"Tap";
            break;
        case 1:
            return @"DoubleTap";
            break;
        case 2:
            return @"LongPress";
            break;
        case 3:
            return @"SwipeRight";
            break;
        case 4:
            return @"SwipeLeft";
            break;
        case 5:
            return @"SwipeUp";
            break;
        case 6:
            return @"SwipeDown";
            break;
        case 7:
            return @"Pan";
            break;
        case 8:
            return @"Pinch";
            break;
        case 9:
            return @"Rotate";
            break;
    }
    return @"";
}

-(void)setupFuffr{
    
    [[FFRTouchManager sharedManager]
     enableSides: FFRSideLeft | FFRSideRight | FFRSideTop | FFRSideBottom
     touchesPerSide: @2];
}

-(void)setupGestureRecognizers{
    FFRTouchManager* manager = [FFRTouchManager sharedManager];
    
    FFRTapGestureRecognizer* tap = [FFRTapGestureRecognizer new];
    tap.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
    [tap addTarget: self action: @selector(onTap:)];
    [manager addGestureRecognizer: tap];
    
    FFRDoubleTapGestureRecognizer* doubleTap = [FFRDoubleTapGestureRecognizer new];
    doubleTap.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
    [doubleTap addTarget: self action: @selector(onDoubleTap:)];
    [manager addGestureRecognizer: doubleTap];
    

    FFRLongPressGestureRecognizer* longPress = [FFRLongPressGestureRecognizer new];
    longPress.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
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
    gesture.side = sender.touch.side;
    self.counter++;
    [self.gestureRecognizedArray addObject:gesture];
}
-(void)onDoubleTap:(FFRDoubleTapGestureRecognizer*)sender{
    NSLog(@"DoubleTap");
    MultipleGestureModel *gesture = [[MultipleGestureModel alloc]init];
    gesture.context = self.dtap;
    gesture.side = sender.touch.side;
    self.counter++;
    [self.gestureRecognizedArray addObject:gesture];
}
-(void)onLongPress:(FFRLongPressGestureRecognizer*)sender{
    NSLog(@"LongPress");
    MultipleGestureModel *gesture = [[MultipleGestureModel alloc]init];
    gesture.context = self.lpress;
    gesture.side = sender.touch.side;
    self.counter++;
    [self.gestureRecognizedArray addObject:gesture];
}
-(void)onSwipeL:(FFRSwipeGestureRecognizer*)sender{
    NSLog(@"SwipeL");
    MultipleGestureModel *gesture = [[MultipleGestureModel alloc]init];
    gesture.context = self.swipeL;
    gesture.side = sender.touch.side;
    self.counter++;
    [self.gestureRecognizedArray addObject:gesture];
}
-(void)onSwipeR:(FFRSwipeGestureRecognizer*)sender{
    NSLog(@"SwipeR");
    MultipleGestureModel *gesture = [[MultipleGestureModel alloc]init];
    gesture.context = self.swipeR;
    gesture.side = sender.touch.side;
    self.counter++;
    [self.gestureRecognizedArray addObject:gesture];
}
-(void)onSwipeU:(FFRSwipeGestureRecognizer*)sender{
    NSLog(@"SwipeU");
    MultipleGestureModel *gesture = [[MultipleGestureModel alloc]init];
    gesture.context = self.swipeU;
    gesture.side = sender.touch.side;
    self.counter++;
    [self.gestureRecognizedArray addObject:gesture];
}
-(void)onSwipeD:(FFRSwipeGestureRecognizer*)sender{
    NSLog(@"SwipeD");
    MultipleGestureModel *gesture = [[MultipleGestureModel alloc]init];
    gesture.context = self.swipeD;
    gesture.side = sender.touch.side;
    self.counter++;
    [self.gestureRecognizedArray addObject:gesture];
}
-(void)onPan:(FFRPanGestureRecognizer*)sender{
    if(sender.state == FFRGestureRecognizerStateBegan){
        NSLog(@"Pan");
        MultipleGestureModel *gesture = [[MultipleGestureModel alloc]init];
        gesture.context = self.pan;
        gesture.side = sender.touch.side;
        self.counter++;
        [self.gestureRecognizedArray addObject:gesture];
    }
    
}
-(void)onPinch:(FFRPinchGestureRecognizer*)sender{
    if(sender.state == FFRGestureRecognizerStateBegan){
        NSLog(@"Pinch");
        MultipleGestureModel *gesture = [[MultipleGestureModel alloc]init];
        gesture.context = self.pinch;
        gesture.side = sender.touch1.side;
        self.counter++;
        [self.gestureRecognizedArray addObject:gesture];
    }
}
-(void)onRotate:(FFRRotationGestureRecognizer*)sender{
    if(sender.state == FFRGestureRecognizerStateBegan){
        NSLog(@"Rotate");
        MultipleGestureModel *gesture = [[MultipleGestureModel alloc]init];
        gesture.context = self.rotate;
        gesture.side = sender.touch1.side;
        self.counter++;
        [self.gestureRecognizedArray addObject:gesture];
    }
}

//----------------------------BUTTONS---------------------------

- (IBAction)tapButton:(UIButton *)sender {
    [self calculateAccuracy:self.tap];
    self.DebugLabel.text = @"Tap";
}
- (IBAction)doubleTapButton:(UIButton *)sender {
    [self calculateAccuracy:self.dtap];
    self.DebugLabel.text = @"DTap";
}
- (IBAction)longPressButton:(UIButton *)sender {
    [self calculateAccuracy:self.lpress];
    self.DebugLabel.text = @"LongPress";
}
- (IBAction)rotateButton:(UIButton *)sender {
    [self calculateAccuracy:self.rotate];
    self.DebugLabel.text = @"Rotate";
}
- (IBAction)panButton:(UIButton *)sender {
    [self calculateAccuracy:self.pan];
    self.DebugLabel.text = @"Pan";
}
- (IBAction)pinchButton:(UIButton *)sender {
    [self calculateAccuracy:self.pinch];
    self.DebugLabel.text = @"Pinch";
}
- (IBAction)swipeLeftButton:(UIButton *)sender {
    [self calculateAccuracy:self.swipeL];
    self.DebugLabel.text = @"Swipe L";
}
- (IBAction)swipeRightButton:(UIButton *)sender {
    [self calculateAccuracy:self.swipeR];
    self.DebugLabel.text = @"Swipe R";
}
- (IBAction)swipeUpButton:(UIButton *)sender {
    [self calculateAccuracy:self.swipeU];
    self.DebugLabel.text = @"Swipe U";
}
- (IBAction)swipeDownButon:(UIButton *)sender {
    [self calculateAccuracy:self.swipeD];
    self.DebugLabel.text = @"Swipe D";
}

-(void)calculateAccuracy:(int)gesture{
    int numberOfGestures = [self.textField.text intValue];
    int correctGesture = 0;
    int extraGestures = 0;
    NSMutableString *writeString = [NSMutableString stringWithCapacity:0];
    MultipleGestureModel *gest;
    for (int i=0; i<[self.gestureRecognizedArray count]; i++) {
        gest = [self.gestureRecognizedArray objectAtIndex:i];
        if(gest.context == gesture){
            correctGesture++;
        }
    }
    switch (gest.side) {
        case FFRSideNotSet:
            self.side = @"NoSide";
            break;
        case FFRSideTop:
            self.side = @"Top";
            break;
        case FFRSideBottom:
            self.side = @"Bottom";
            break;
        case FFRSideLeft:
            self.side = @"Left";
            break;
        case FFRSideRight:
            self.side = @"Right";
            break;
    }
    extraGestures = (int)[self.gestureRecognizedArray count]-correctGesture;
    float accuracy = (float)correctGesture/numberOfGestures;
    accuracy = (float)accuracy*100;
    [writeString appendString:[NSString stringWithFormat:@"%@, %d, %d, %f, %@, %d, ", self.side, numberOfGestures, (int)[self.gestureRecognizedArray count], accuracy, [self giveGesture:gesture], extraGestures]];
    for(int i=0; i<[self.gestureRecognizedArray count]; i++){
        gest = [self.gestureRecognizedArray objectAtIndex:i];
        [self.gesturetypesRecognized replaceObjectAtIndex:gest.context withObject:gest];
    }
    for(int i=0; i<10; i++){
        gest = [self.gesturetypesRecognized objectAtIndex:i];
        if(gest.context != 99){
            [writeString appendString:[NSString stringWithFormat:@"%@, ", [self giveGesture:gest.context]]];
        }
    }
    [writeString appendString:[NSString stringWithFormat:@"\n"]];
    NSLog(@"%@", writeString);
    [self.stringArray addObject:writeString];
    
    //Resettar testet
    self.textField = 0;
    self.gestureRecognizedArray = nil;
    self.gesturetypesRecognized = nil;
    self.counter = 0;
}

-(void)sendToServer{
    
    NSString *aHostName;
    if(self.delegate.serverIP) {
        aHostName = self.delegate.serverIP;
    }
    else {
        aHostName = @"nope";
    }
    self.DebugLabel.text = aHostName;
    unsigned int aPort = 1337;
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)aHostName, aPort, &readStream, &writeStream);
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
    
    NSMutableString *writeString = [NSMutableString stringWithCapacity:0];
    for(int i=0; i<[self.stringArray count]; i++){
        [writeString appendString:[NSString stringWithFormat:@"%@",[self.stringArray objectAtIndex:i]]];
    }
    
    NSData *data = [[NSData alloc] initWithData:[writeString dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
    
    [inputStream close];
    [outputStream close];
    
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
