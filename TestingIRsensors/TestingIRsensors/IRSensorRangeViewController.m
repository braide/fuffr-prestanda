//
//  IRSensorRangeDrawingViewController.m
//  TestingIRsensors
//
//  Created by Fuffr1 on 05/06/14.
//  Copyright (c) 2014 Fuffr1. All rights reserved.
//

#import "IRSensorRangeViewController.h"

@interface IRSensorRangeViewController ()
@property float x, width;
@property float y, height;
@property (nonatomic) NSMutableArray *listOfCoordinates;
@property (nonatomic) NSMutableArray *listOfTouches;
@property (nonatomic) NSMutableArray *listOfTaps;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) CGRect rect;
@end

@implementation IRSensorRangeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFuffr];
    self.width = self.view.frame.size.width;
    self.height = self.view.frame.size.height;
}

-(NSMutableArray *)listOfCoordinates{
    if(!_listOfCoordinates){
        _listOfCoordinates = [[NSMutableArray alloc]init];
    }
    return _listOfCoordinates;
}
-(NSMutableArray *)listOfTouches{
    if(!_listOfTouches){
        _listOfTouches = [[NSMutableArray alloc]init];
    }
    return _listOfTouches;
}
-(NSMutableArray *)listOfTaps{
    if(!_listOfTaps){
        _listOfTaps = [[NSMutableArray alloc]init];
    }
    return _listOfTaps;
}

-(void)setupFuffr{
    FFRTouchManager* manager = [FFRTouchManager sharedManager];
    
    [manager
     enableSides: FFRSideLeft | FFRSideRight | FFRSideTop | FFRSideBottom
     touchesPerSide: @1];
    
    
    FFRTapGestureRecognizer* tap = [FFRTapGestureRecognizer new];
    tap.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
    [tap addTarget: self action: @selector(onTap:)];
    [manager addGestureRecognizer: tap];
    
}


-(void)onTap:(FFRTapGestureRecognizer *)sender{
    NSLog(@"Right X: %f",sender.touch.normalizedLocation.x*self.width);
    NSLog(@"Right Y: %f",sender.touch.normalizedLocation.y*self.height);
    NSString *values = [NSString stringWithFormat:@"Right\nX: %f \nY: %f",sender.touch.normalizedLocation.x*self.width, sender.touch.normalizedLocation.y*self.height];
    [self.listOfCoordinates addObject:values];
    [self.listOfTouches addObject:sender.touch];
    [self.listOfTaps addObject:sender];
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self drawStuff];
                   });
}

-(void)drawStuff{
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for(FFRTouch *touch in self.listOfTouches){
        if (touch.phase != UITouchPhaseEnded)
        {
            self.rect = CGRectMake(touch.normalizedLocation.x * self.imageView.bounds.size.width, touch.normalizedLocation.y * self.imageView.bounds.size.height, 20, 20);
            CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
            CGContextAddRect(context, self.rect);
            CGContextFillEllipseInRect(context, self.rect);
        }
    }
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}



- (IBAction)sendToServer:(UIButton *)sender {
    
    NSMutableString *writeString = [NSMutableString stringWithCapacity:0];
    for (int i=0; i<[self.listOfCoordinates count]; i++) {
        NSLog(@"%@",[self.listOfCoordinates objectAtIndex:i]);
        [writeString appendString:[NSString stringWithFormat:@"%@ \n", [self.listOfCoordinates objectAtIndex:i]]];
    }
    
    /*
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
     
     NSMutableString *writeString = [NSMutableString stringWithCapacity:0];
     for (int i=0; i<[self.listOfCoordinates count]; i++) {
     [writeString appendString:[NSString stringWithFormat:@"%@ \n", [self.listOfCoordinates objectAtIndex:i]]];
     }
     NSLog(@"WriteString: %@", writeString);
     NSData *data = [[NSData alloc] initWithData:[writeString dataUsingEncoding:NSASCIIStringEncoding]];
     [outputStream write:[data bytes] maxLength:[data length]];*/
    
}



- (IBAction)goback:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
