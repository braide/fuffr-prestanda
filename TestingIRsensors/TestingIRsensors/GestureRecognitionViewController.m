//
//  GestureRecognitionViewController.m
//  TestingIRsensors
//
//  Created by Fuffr1 on 31/05/14.
//  Copyright (c) 2014 Fuffr1. All rights reserved.
//

#import "GestureRecognitionViewController.h"
#import "GestureRecognitionModel.h"

@interface GestureRecognitionViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *swipeDirectionView;
@property (strong, nonatomic) NSArray *directionArray;
@property int currentSwipeDirection;
@property int currentGestureCounter;
@property int numOfGesturesSuggested;
@property (weak, nonatomic) IBOutlet UITextField *numOfGestureField;
@property float accuracy;
@property (nonatomic) NSString *testedGesture;
//@property GestureRecognitionModel *gestureModel;
@property (nonatomic) NSMutableArray *gestureModels;
@property int identifier;
@property (nonatomic) NSMutableArray *writeStringArray1, *writeStringArray2;
@property double startTime, stopTime;

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
    self.identifier = 0;
}

-(void)setupFuffr{
    [[FFRTouchManager sharedManager]
     enableSides: FFRSideLeft | FFRSideRight | FFRSideTop | FFRSideBottom
     touchesPerSide: @2];
}

-(NSMutableArray *)gestureModels{
    if(!_gestureModels){
        _gestureModels = [[NSMutableArray alloc]init];
    }
    return _gestureModels;
}

-(NSMutableArray *)writeStringArray1{
    if(!_writeStringArray1){
        _writeStringArray1 = [[NSMutableArray alloc]init];
    }
    return _writeStringArray1;
}
-(NSMutableArray *)writeStringArray2{
    if(!_writeStringArray2){
        _writeStringArray2 = [[NSMutableArray alloc]init];
    }
    return _writeStringArray2;
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
        self.testedGesture = @"Tap";
        FFRTapGestureRecognizer* tap = [FFRTapGestureRecognizer new];
        tap.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
        [tap addTarget: self action: @selector(onTap:)];
        [manager addGestureRecognizer: tap];
        
    }else if([title isEqualToString:@"DoubleTap"]){
        self.testedGesture = @"DoubleTap";
        FFRDoubleTapGestureRecognizer* doubleTap = [FFRDoubleTapGestureRecognizer new];
        doubleTap.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
        [doubleTap addTarget: self action: @selector(onDoubleTap:)];
        [manager addGestureRecognizer: doubleTap];
        
    }else if([title isEqualToString:@"LongPress"]){
        self.testedGesture = @"LongPress";
        FFRLongPressGestureRecognizer* longPress = [FFRLongPressGestureRecognizer new];
        longPress.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
        [longPress addTarget: self action: @selector(onLongPress:)];
        [manager addGestureRecognizer: longPress];
    
    }else if([title isEqualToString:@"Swipe"]){
        self.testedGesture = @"Swipe";
        FFRSwipeGestureRecognizer *swipe = [FFRSwipeGestureRecognizer new];
        swipe.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
        swipe.minimumDistance = 50.0;
        swipe.direction = self.currentSwipeDirection;
        swipe.maximumDuration = 1.0;
        [swipe addTarget:self action:@selector(onSwipe:)];
        [manager addGestureRecognizer:swipe];
        
    }else if([title isEqualToString:@"Pan"]){
        self.testedGesture = @"Pan";
        FFRPanGestureRecognizer* pan = [FFRPanGestureRecognizer new];
        pan.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
        [pan addTarget: self action: @selector(onPan:)];
        [manager addGestureRecognizer: pan];
        
    }else if([title isEqualToString:@"Pinch"]){
        self.testedGesture = @"Pinch";
        FFRPinchGestureRecognizer* pinch = [FFRPinchGestureRecognizer new];
        pinch.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
        [pinch addTarget: self action: @selector(onPinch:)];
        [manager addGestureRecognizer: pinch];
        
    }else if([title isEqualToString:@"Rotate"]){
        self.testedGesture = @"Rotate";
        FFRRotationGestureRecognizer* rotate = [FFRRotationGestureRecognizer new];
        rotate.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
        rotate.rotationThreshold = 0.001;
        [rotate addTarget: self action: @selector(onRotate:)];
        [manager addGestureRecognizer: rotate];
    }
}

- (IBAction)doneButtonPressed:(UIButton *)sender {
    [self datastring];
}

- (IBAction)sendToServerButton:(UIButton *)sender {
    [self sendToServer:self.writeStringArray1];
    [self sendToServer:self.writeStringArray2];
}


-(void)onTap:(FFRTapGestureRecognizer *)gesture{
    GestureRecognitionModel *gestureModel = [[GestureRecognitionModel alloc]init];
    self.currentGestureCounter++;
    gestureModel.side = [self getGestureSide:gesture.touch.side];
    gestureModel.xPosStart = gesture.touch.normalizedLocation.x * self.view.frame.size.width;
    gestureModel.yPosStart = gesture.touch.normalizedLocation.y * self.view.frame.size.height;
    [self.gestureModels addObject:gestureModel];
    NSLog(@"Tap %d", self.currentGestureCounter);
}
-(void)onDoubleTap:(FFRDoubleTapGestureRecognizer *)gesture{
    GestureRecognitionModel *gestureModel = [[GestureRecognitionModel alloc]init];
    self.currentGestureCounter++;
    gestureModel.side = [self getGestureSide:gesture.touch.side];
    gestureModel.xPosStart = gesture.touch.normalizedLocation.x * self.view.frame.size.width;
    gestureModel.yPosStart = gesture.touch.normalizedLocation.y * self.view.frame.size.height;
    [self.gestureModels addObject:gestureModel];
    NSLog(@"DoubleTap %d", self.currentGestureCounter);
}
-(void)onLongPress:(FFRLongPressGestureRecognizer *)gesture{
    GestureRecognitionModel *gestureModel = [[GestureRecognitionModel alloc]init];
    self.currentGestureCounter++;
    gestureModel.side = [self getGestureSide:gesture.touch.side];
    gestureModel.xPosStart = gesture.touch.normalizedLocation.x * self.view.frame.size.width;
    gestureModel.yPosStart = gesture.touch.normalizedLocation.y * self.view.frame.size.height;
    [self.gestureModels addObject:gestureModel];
    NSLog(@"Longpress %d", self.currentGestureCounter);
}
- (void)onSwipe:(FFRSwipeGestureRecognizer *)gesture{
    NSLog(@"%d", gesture.state);
    GestureRecognitionModel *gestureModel = [[GestureRecognitionModel alloc]init];
    self.currentGestureCounter++;
    gestureModel.side = [self getGestureSide:gesture.touch.side];
    gestureModel.xPosStart = gesture.startPoint.x;
    gestureModel.yPosStart = gesture.startPoint.y;
    gestureModel.xPosEnd = gesture.touch.normalizedLocation.x * self.view.frame.size.width;
    gestureModel.yPosEnd = gesture.touch.normalizedLocation.y * self.view.frame.size.height;
    [self.gestureModels addObject:gestureModel];
     NSLog(@"Swipe %d", self.currentGestureCounter);
}
-(void)onPan:(FFRPanGestureRecognizer *)gesture{
    NSLog(@"%d",gesture.state);
    GestureRecognitionModel *gestureModel;
    if(gesture.state == FFRGestureRecognizerStateBegan){
        gestureModel = [[GestureRecognitionModel alloc]init];
        self.currentGestureCounter++;
        gestureModel.side = [self getGestureSide:gesture.touch.side];
        gestureModel.xPosStart = gesture.touch.normalizedLocation.x * self.view.frame.size.width;
        gestureModel.yPosStart = gesture.touch.normalizedLocation.y * self.view.frame.size.height;
        [self.gestureModels addObject:gestureModel];
    }else if(gesture.state == FFRGestureRecognizerStateEnded){
        gestureModel = [self.gestureModels lastObject];
        gestureModel.xPosEnd = gesture.touch.normalizedLocation.x * self.view.frame.size.width;
        gestureModel.yPosEnd = gesture.touch.normalizedLocation.y * self.view.frame.size.height;
    }
}
-(void)onPinch:(FFRPinchGestureRecognizer *)gesture{
    NSLog(@"%d",gesture.state);
    GestureRecognitionModel *gestureModel = [[GestureRecognitionModel alloc]init];
    if(gesture.state == FFRGestureRecognizerStateBegan){
        self.currentGestureCounter++;
        self.startTime = CACurrentMediaTime();
        gestureModel.side = [self getGestureSide:gesture.touch1.side];
        gestureModel.startdistance = [self distanceBetween:gesture.touch1.location to:gesture.touch2.location];
        [self.gestureModels addObject:gestureModel];
    }else if(gesture.state == FFRGestureRecognizerStateEnded){
        self.stopTime = CACurrentMediaTime();
        gestureModel = [self.gestureModels lastObject];
        gestureModel.enddistance = [self distanceBetween:gesture.touch1.location to:gesture.touch2.location];
        gestureModel.duration = self.stopTime - self.startTime;
    }
}
-(void)onRotate:(FFRRotationGestureRecognizer *)gesture{
    GestureRecognitionModel *gestureModel = [[GestureRecognitionModel alloc]init];
    if(gesture.state == FFRGestureRecognizerStateBegan){
        self.currentGestureCounter++;
        self.startTime = CACurrentMediaTime();
        gestureModel.side = [self getGestureSide:gesture.touch1.side];
        [self.gestureModels addObject:gestureModel];
    }else if(gesture.state == FFRGestureRecognizerStateEnded){
        self.stopTime = CACurrentMediaTime();
        gestureModel = [self.gestureModels lastObject];
        gestureModel.angle = gesture.rotation * 1.5;
        gestureModel.duration = self.stopTime - self.startTime;
    }
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

-(NSString *)getGestureSide:(int)gestSide{
    switch (gestSide) {
        case 1:
            return @"Top";
        case 2:
            return @"Bottom";
        case 4:
            return @"Left";
        case 8:
            return @"Right";
        case 0:
            return @"NoSide";
    }
    return @"";
}

-(void)datastring{
    GestureRecognitionModel *gestureModel = [[GestureRecognitionModel alloc]init];
    self.accuracy = (float)self.currentGestureCounter/self.numOfGesturesSuggested;
    self.accuracy = (float)self.accuracy * 100.0;
    if([self.gestureModels count]>0){
        gestureModel = [self.gestureModels objectAtIndex:0];
        self.identifier++;
        int ident = 0;
        NSMutableString *writeString = [NSMutableString stringWithCapacity:0];
        NSMutableString *writeString2 = [NSMutableString stringWithCapacity:0];
        for(int i = 0; i<self.identifier; i++){ident++;}
        
        //WriteString1
        //antal försök, antalförsök som togs upp, accuracy, side, gest som testats, gestpossitioner, id
        [writeString appendString:[NSString stringWithFormat:@"%d, %d, %f, %@, %@, %d, \n", self.numOfGesturesSuggested, self.currentGestureCounter,
                                   self.accuracy, gestureModel.side, self.testedGesture, self.identifier]];
        //WriteString2
        writeString2 = [self writeDataDependingOnGesture:ident];
        self.gestureModels = nil;
        
        [self.writeStringArray1 addObject:writeString];
        [self.writeStringArray2 addObject:writeString2];
        
        
        for(int i=0; i<[self.writeStringArray1 count]; i++){
            NSLog(@"%@", [self.writeStringArray1 objectAtIndex:i]);
            NSLog(@"%@", [self.writeStringArray2 objectAtIndex:i]);
        }
    }else{
        NSLog(@"No Gesture Recognized\n");
    }

}

-(NSMutableString *)writeDataDependingOnGesture:(int)ident{
    NSMutableString *data = [NSMutableString stringWithCapacity:0];
    GestureRecognitionModel *gestureModel = [[GestureRecognitionModel alloc]init];
    
    if([self.testedGesture isEqualToString:@"Tap"]){
        for(int i=0; i<[self.gestureModels count]; i++){
            gestureModel = [self.gestureModels objectAtIndex:i];
            [data appendString:[NSString stringWithFormat:@"%f, %f, %d, \n", gestureModel.xPosStart, gestureModel.yPosStart, ident]];
        }
    }else if([self.testedGesture isEqualToString:@"DoubleTap"]){
        for(int i=0; i<[self.gestureModels count]; i++){
            gestureModel = [self.gestureModels objectAtIndex:i];
            [data appendString:[NSString stringWithFormat:@"%f, %f, %d, \n", gestureModel.xPosStart, gestureModel.yPosStart, ident]];
        }
    }else if([self.testedGesture isEqualToString:@"Longpress"]){
        for(int i=0; i<[self.gestureModels count]; i++){
            gestureModel = [self.gestureModels objectAtIndex:i];
            [data appendString:[NSString stringWithFormat:@"%f, %f, %d, \n", gestureModel.xPosStart, gestureModel.yPosStart, ident]];
        }
    }else if([self.testedGesture isEqualToString:@"Swipe"]){
        for(int i=0; i<[self.gestureModels count]; i++){
            gestureModel = [self.gestureModels objectAtIndex:i];
            [data appendString:[NSString stringWithFormat:@"%f, %f, %f, %f, %d, \n", gestureModel.xPosStart, gestureModel.yPosStart, gestureModel.xPosEnd, gestureModel.yPosEnd, ident]];
        }
    }else if([self.testedGesture isEqualToString:@"Pan"]){
        for(int i=0; i<[self.gestureModels count]; i++){
            gestureModel = [self.gestureModels objectAtIndex:i];
            [data appendString:[NSString stringWithFormat:@"%f, %f, %f, %f, %d, \n", gestureModel.xPosStart, gestureModel.yPosStart, gestureModel.xPosEnd, gestureModel.yPosEnd, ident]];
        }
    }else if([self.testedGesture isEqualToString:@"Pinch"]){
        for(int i=0; i<[self.gestureModels count]; i++){
            gestureModel = [self.gestureModels objectAtIndex:i];
            [data appendString:[NSString stringWithFormat:@"%f, %f, %f, %d, \n", gestureModel.startdistance, gestureModel.enddistance, gestureModel.duration, ident]];
        }
    }else if([self.testedGesture isEqualToString:@"Rotate"]){
        for(int i=0; i<[self.gestureModels count]; i++){
            gestureModel = [self.gestureModels objectAtIndex:i];
            [data appendString:[NSString stringWithFormat:@"%f, %f, %f, %d, \n", gestureModel.angle, (gestureModel.angle  * (180.0 / M_PI)), gestureModel.duration, ident]];
        }
    }
    return data;
}



-(void)sendToServer:(NSMutableArray *)writeStringArray{
    
     NSString *aHostName = @"192.168.1.133";
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
     
     
    for(int i=0; i<[writeStringArray count]; i++){
        NSData *data = [[NSData alloc] initWithData:[[writeStringArray objectAtIndex:i] dataUsingEncoding:NSASCIIStringEncoding]];
        [outputStream write:[data bytes] maxLength:[data length]];
    }
    [inputStream close];
    [outputStream close];
    
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
