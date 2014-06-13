//
//  EventPerSecondViewController.m
//  TestingIRsensors
//
//  Created by Fuffr1 on 31/05/14.
//  Copyright (c) 2014 Fuffr1. All rights reserved.
//

#import "EventPerSecondViewController.h"
#import "EventsPerSecondStorageModel.h"
#import "EventsPerSecondSideModel.h"

@interface EventPerSecondViewController ()

//UI
@property (weak, nonatomic) IBOutlet UISegmentedControl *topButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *rightButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *bottomButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *leftButton;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (strong, nonatomic) NSMutableArray *eventsPerSecondArray; // of eventsPerSecondStorageModel
@property (strong, nonatomic) NSMutableArray *activeSidesArray; // of NSString
@property (strong, nonatomic) NSMutableArray *activeSidesNameArray; // of NSString
@property (strong, nonatomic) EventsPerSecondSideModel *rightSide, *leftSide, *topSide, *bottomSide;
@property (nonatomic) int eventId, numOfSidesActiveAtOnce;
@end

@implementation EventPerSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.rightSide = [[EventsPerSecondSideModel alloc] init];
    self.leftSide = [[EventsPerSecondSideModel alloc] init];
    self.topSide = [[EventsPerSecondSideModel alloc] init];
    self.bottomSide = [[EventsPerSecondSideModel alloc] init];
    [self fuffrSetup];
    self.eventsPerSecondArray = [[NSMutableArray alloc] init];
    self.activeSidesArray = [[NSMutableArray alloc] init];
    self.activeSidesNameArray = [[NSMutableArray alloc] init];
}


- (IBAction)changeSideOption:(UISegmentedControl *)sender {
    if(sender == self.topButton) {
        if(sender.selectedSegmentIndex) self.topSide.sideEnabled = 0;
        else self.topSide.sideEnabled = FFRSideTop;
    }
    if(sender == self.rightButton) {
        if(sender.selectedSegmentIndex) self.rightSide.sideEnabled = 0;
        else self.rightSide.sideEnabled = FFRSideRight;
    }
    if(sender == self.bottomButton) {
        if(sender.selectedSegmentIndex) self.bottomSide.sideEnabled = 0;
        else self.bottomSide.sideEnabled = FFRSideBottom;
    }
    if(sender == self.leftButton) {
        if(sender.selectedSegmentIndex) self.leftSide.sideEnabled = 0;
        else self.leftSide.sideEnabled = FFRSideLeft;
    }
    [[FFRTouchManager sharedManager] enableSides: self.topSide.sideEnabled | self.bottomSide.sideEnabled | self.leftSide.sideEnabled | self.rightSide.sideEnabled touchesPerSide:@5];
}

- (void)fuffrSetup
{
    // Get a reference to the touch manager.
	FFRTouchManager* manager = [FFRTouchManager sharedManager];
    
	// Set active sides.
    [[FFRTouchManager sharedManager]
     enableSides: 0
     touchesPerSide: @5
     ];
	// Register methods for right side touches. The touchEnded
	// method is not used in this example.
    
    
    [manager
     addTouchObserver: self
     touchBegan: @selector(touchesBeganRight:)
     touchMoved: @selector(touchesMovedRight:)
     touchEnded: @selector(touchesEndedRight:)
     sides: FFRSideRight];
    
    [manager
     addTouchObserver: self
     touchBegan: @selector(touchesBeganLeft:)
     touchMoved: @selector(touchesMovedLeft:)
     touchEnded: @selector(touchesEndedLeft:)
     sides: FFRSideLeft];
    
    [manager
     addTouchObserver: self
     touchBegan: @selector(touchesBeganBottom:)
     touchMoved: @selector(touchesMovedBottom:)
     touchEnded: @selector(touchesEndedBottom:)
     sides: FFRSideBottom];
    
    [manager
     addTouchObserver: self
     touchBegan: @selector(touchesBeganTop:)
     touchMoved: @selector(touchesMovedTop:)
     touchEnded: @selector(touchesEndedTop:)
     sides: FFRSideTop];
}

- (void)touchesBegan:(NSSet *)touches side:(NSString *)side sideModel:(EventsPerSecondSideModel *)sideModel {
    [self increaseId];
    [self addActiveSide:side];
    sideModel.numOfActiveTouches++;
    if (sideModel.highestNumOfActiveTouches < [touches count] && sideModel.previousNumOfActiveTouches==[touches count]) {
        sideModel.startTime = CACurrentMediaTime();
        sideModel.numOfEvents = 1;
    }
    sideModel.previousNumOfActiveTouches = (int)[touches count];
}

- (void)touchesMoved:(NSSet *)touches sideModel:(EventsPerSecondSideModel *)sideModel {
    sideModel.numOfEvents++;
    if ([touches count] > sideModel.highestNumOfActiveTouches && sideModel.previousNumOfActiveTouches==[touches count]) sideModel.highestNumOfActiveTouches = (int)[touches count];
    sideModel.previousNumOfActiveTouches = (int)[touches count];
    
}

- (void)touchesEnded:(NSSet *)touches side:(NSString *)side sideModel:(EventsPerSecondSideModel *)sideModel Label:(UILabel *)label {
    sideModel.numOfEvents++;
    sideModel.numOfActiveTouches--;
    if (!sideModel.numOfActiveTouches) {
        sideModel.stopTime = CACurrentMediaTime();
        float eventsPerSecond = sideModel.numOfEvents / (sideModel.stopTime - sideModel.startTime);
        NSLog(@"Events per second on %@: %f",side,eventsPerSecond);
        label.text =[NSString stringWithFormat:@"%f", eventsPerSecond];
        
        //storagemodel code here
        EventsPerSecondStorageModel *eps = [[EventsPerSecondStorageModel alloc] init];
        eps.eventId = self.eventId;
        eps.eventsPerSecond = eventsPerSecond;
        eps.side = side;
        eps.numOfEnabledSides = [self getNumOfEnabledSides];
        eps.enabledSides = [self getEnabledSides];
        eps.numOfSidesActiveAtOnce = self.numOfSidesActiveAtOnce;
        eps.sidesActiveAtOnce = [self getSidesActiveAtOnce];
        eps.numOfTouchesActiveAtOnce = sideModel.highestNumOfActiveTouches;
        eps.durationInSeconds =  (sideModel.stopTime - sideModel.startTime);
        
        [self.eventsPerSecondArray addObject:eps];
        sideModel.numOfEvents = 0;
        [self removeActiveSide:side];
    }
}

- (void) touchesBeganRight: (NSSet *)touches {
    [self touchesBegan:touches side:@"Right" sideModel:self.rightSide];
}

- (void) touchesMovedRight: (NSSet*)touches
{
    [self touchesMoved:touches sideModel:self.rightSide];
}

- (void) touchesEndedRight: (NSSet*)touches {
    [self touchesEnded:touches side:@"Right" sideModel:self.rightSide Label:self.rightLabel];
}

- (void) touchesBeganLeft: (NSSet*)touches
{
    [self touchesBegan:touches side:@"Left" sideModel:self.leftSide];
}

- (void) touchesMovedLeft: (NSSet*)touches
{
    [self touchesMoved:touches sideModel:self.leftSide];
}

- (void) touchesEndedLeft: (NSSet*)touches {
    [self touchesEnded:touches side:@"Left" sideModel:self.leftSide Label:self.leftLabel];
}

- (void) touchesBeganBottom: (NSSet*)touches
{
    [self touchesBegan:touches side:@"Bottom" sideModel:self.bottomSide];
}

- (void)touchesMovedBottom: (NSSet*)touches{
    [self touchesMoved:touches sideModel:self.bottomSide];
}
- (void)touchesEndedBottom: (NSSet*)touches{
    [self touchesEnded:touches side:@"Bottom" sideModel:self.bottomSide Label:self.bottomLabel];
}

- (void) touchesBeganTop: (NSSet*)touches
{
    [self touchesBegan:touches side:@"Top" sideModel:self.topSide];
}

- (void)touchesMovedTop: (NSSet *) touches {
    [self touchesMoved:touches sideModel:self.topSide];
}

- (void)touchesEndedTop: (NSSet *) touches {
    [self touchesEnded:touches side:@"Top" sideModel:self.topSide Label:self.topLabel];
}

- (IBAction)sendToServerPressed:(UIButton *)sender {
    //[self printStorageModel];
    [self sendFileToServer];
}


// currently not used. Saving array locally
- (void)saveArrayToFile: (NSString *) fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataFilePath]) {
        [[NSFileManager defaultManager] createFileAtPath:dataFilePath contents:nil attributes:nil];
    }
    
    NSMutableString *writeString = [NSMutableString stringWithCapacity:0];
    
    for (int i=0; i<[self.eventsPerSecondArray count]; i++) {
        EventsPerSecondStorageModel *eps = [self.eventsPerSecondArray objectAtIndex:i];
        [writeString appendString:[NSString stringWithFormat:@"%d, %f, %@, %d, %@, %d, %@, %d, %f, \n", eps.eventId, eps.eventsPerSecond, eps.side, eps.numOfEnabledSides, eps.enabledSides, eps.numOfSidesActiveAtOnce, eps.sidesActiveAtOnce, eps.numOfTouchesActiveAtOnce, eps.durationInSeconds]];
    }
    NSLog(@"writeString :%@",writeString);
    
    NSFileHandle *handle;
    handle = [NSFileHandle fileHandleForWritingAtPath: dataFilePath];
    //say to handle where's the file fo write
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    //position handle cursor to the end of file
    [handle writeData:[writeString dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)sendFileToServer {
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
    
    // send a test string
    //NSString *response  = [NSString stringWithFormat:@"I am BATMAN!"];
    NSMutableString *writeString = [NSMutableString stringWithCapacity:0];
    for (int i=0; i<[self.eventsPerSecondArray count]; i++) {
        EventsPerSecondStorageModel *eps = [self.eventsPerSecondArray objectAtIndex:i];
        [writeString appendString:[NSString stringWithFormat:@"%d, %f, %@, %d, %@, %d, %@, %d, %f, \n", eps.eventId, eps.eventsPerSecond, eps.side, eps.numOfEnabledSides, eps.enabledSides, eps.numOfSidesActiveAtOnce, eps.sidesActiveAtOnce, eps.numOfTouchesActiveAtOnce, eps.durationInSeconds]];
    }
	NSData *data = [[NSData alloc] initWithData:[writeString dataUsingEncoding:NSASCIIStringEncoding]];
	[outputStream write:[data bytes] maxLength:[data length]];
    
}

- (NSString *)getEnabledSides {
    NSString *temp = [NSString stringWithFormat:@""];
    if (self.leftSide.sideEnabled)  temp = [temp stringByAppendingString:@"Left "];
    if (self.rightSide.sideEnabled) temp = [temp stringByAppendingString:@"Right "];
    if (self.topSide.sideEnabled) temp = [temp stringByAppendingString:@"Top "];
    if (self.bottomSide.sideEnabled) temp = [temp stringByAppendingString:@"Bottom "];
    temp = [temp substringToIndex:[temp length] - 1];
    return temp;
}

- (NSString *)getSidesActiveAtOnce {
    NSString *temp = [NSString stringWithFormat:@""];
    if([self.activeSidesNameArray containsObject:@"Left"]) temp = [temp stringByAppendingString:@"Left "];
    if([self.activeSidesNameArray containsObject:@"Right"]) temp = [temp stringByAppendingString:@"Right "];
    if([self.activeSidesNameArray containsObject:@"Top"]) temp = [temp stringByAppendingString:@"Top "];
    if([self.activeSidesNameArray containsObject:@"Bottom"]) temp = [temp stringByAppendingString:@"Bottom "];
    temp = [temp substringToIndex:[temp length] - 1];
    return temp;
}

- (void)printStorageModel {
    for (EventsPerSecondStorageModel *eps in self.eventsPerSecondArray) {
        NSLog(@"id = %d", eps.eventId);
        NSLog(@"EPS = %f", eps.eventsPerSecond);
        NSLog(@"side = %@", eps.side);
        NSLog(@"numOfEnabledSides = %d", eps.numOfEnabledSides);
        NSLog(@"enabledSides = %@", eps.enabledSides);
        NSLog(@"numOfSidesActiveAtOnce = %d", eps.numOfSidesActiveAtOnce);
        NSLog(@"sidesActiveAtOnce = %@", eps.sidesActiveAtOnce);
        NSLog(@"numOfTouchesActiveAtOnce = %d", eps.numOfTouchesActiveAtOnce);
        NSLog(@"durationInSeconds = %f", eps.durationInSeconds);
    }
}

- (int)getNumOfEnabledSides {
    int numOfEnabledSides = 0;
    if (self.leftSide.sideEnabled) numOfEnabledSides++;
    if (self.rightSide.sideEnabled) numOfEnabledSides++;
    if (self.topSide.sideEnabled) numOfEnabledSides++;
    if (self.bottomSide.sideEnabled) numOfEnabledSides++;
    return numOfEnabledSides;
}

- (void)increaseId {
    if (![self.activeSidesArray count]) {
        self.eventId++;
        self.numOfSidesActiveAtOnce = 0;
        [self.activeSidesNameArray removeAllObjects];
        self.leftSide.highestNumOfActiveTouches = 0;
        self.rightSide.highestNumOfActiveTouches = 0;
        self.topSide.highestNumOfActiveTouches = 0;
        self.bottomSide.highestNumOfActiveTouches = 0;
        self.rightSide.previousNumOfActiveTouches = 1;
        self.leftSide.previousNumOfActiveTouches = 1;
        self.bottomSide.previousNumOfActiveTouches = 1;
        self.topSide.previousNumOfActiveTouches = 1;
    }
}

- (void)addActiveSide:(NSString *)side {
    if(![self.activeSidesArray containsObject:side]) {
        [self.activeSidesArray addObject:side];
        [self.activeSidesNameArray addObject:side];
        self.numOfSidesActiveAtOnce++;
    }
}

- (void)removeActiveSide:(NSString *)side {
    if([self.activeSidesArray containsObject:side]) {
        [self.activeSidesArray removeObject:side];
    }
}

@end
