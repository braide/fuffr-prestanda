//
//  IRSensorRangeViewController.m
//  TestingIRsensors
//
//  Created by Fuffr1 on 31/05/14.
//  Copyright (c) 2014 Fuffr1. All rights reserved.
//

#import "IRSensorRangeViewController.h"

@interface IRSensorRangeViewController ()
@property float x, width;
@property float y, height;
@property (nonatomic) NSMutableArray *listOfCoordinates;
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

-(void)setupFuffr{
    FFRTouchManager* manager = [FFRTouchManager sharedManager];
    
    [manager
     enableSides: FFRSideLeft | FFRSideRight | FFRSideTop | FFRSideBottom
     touchesPerSide: @1];
    
    
    
    [manager
     addTouchObserver: self
     touchBegan: @selector(touchesBeganRight:)
     touchMoved: nil
     touchEnded: nil
     sides: FFRSideRight];
    
    [manager
     addTouchObserver: self
     touchBegan: @selector(touchesBeganLeft:)
     touchMoved: nil
     touchEnded: nil
     sides: FFRSideLeft];
    
    [manager
     addTouchObserver: self
     touchBegan: @selector(touchesBeganBottom:)
     touchMoved: nil
     touchEnded: nil
     sides: FFRSideBottom];
    
    [manager
     addTouchObserver: self
     touchBegan: @selector(touchesBeganTop:)
     touchMoved: nil
     touchEnded: nil
     sides: FFRSideTop];
}



-(void)touchesBeganRight:(NSSet *)touches{
    for(FFRTouch *t in touches){
        NSLog(@"X: %f",t.normalizedLocation.x*self.width);
        NSLog(@"Y: %f",t.normalizedLocation.y*self.height);
        NSString *values = [NSString stringWithFormat:@"Right\nX: %f \nY: %f",t.normalizedLocation.x*self.width, t.normalizedLocation.y*self.height];
        [self.listOfCoordinates addObject:values];
    }
    
}
-(void)touchesBeganLeft:(NSSet *)touches{
    for(FFRTouch *t in touches){
        NSLog(@"X: %f",t.normalizedLocation.x*self.width);
        NSLog(@"Y: %f",t.normalizedLocation.y*self.height);
        NSString *values = [NSString stringWithFormat:@"Left\nX: %f \nY: %f",t.normalizedLocation.x*self.width, t.normalizedLocation.y*self.height];
        [self.listOfCoordinates addObject:values];
    }
}
-(void)touchesBeganTop:(NSSet *)touches{
    for(FFRTouch *t in touches){
        NSLog(@"X: %f",t.normalizedLocation.x*self.width);
        NSLog(@"Y: %f",t.normalizedLocation.y*self.height);
        NSString *values = [NSString stringWithFormat:@"Top\nX: %f \nY: %f",t.normalizedLocation.x*self.width, t.normalizedLocation.y*self.height];
        [self.listOfCoordinates addObject:values];
    }
}
-(void)touchesBeganBottom:(NSSet *)touches{
    for(FFRTouch *t in touches){
        NSLog(@"X: %f",t.normalizedLocation.x*self.width);
        NSLog(@"Y: %f",t.normalizedLocation.y*self.height);
        NSString *values = [NSString stringWithFormat:@"Bottom\nX: %f \nY: %f",t.normalizedLocation.x*self.width, t.normalizedLocation.y*self.height];
        [self.listOfCoordinates addObject:values];
    }
}




-(void)touchesEndedRight:(NSSet *)touches{
    
}
-(void)touchesEndedLeft:(NSSet *)touches{
    
}
-(void)touchesEndedTop:(NSSet *)touches{
    
}
-(void)touchesEndedBottom:(NSSet *)touches{
    
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
