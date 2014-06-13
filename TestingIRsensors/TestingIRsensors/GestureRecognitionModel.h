//
//  GestureRecognitionModel.h
//  TestingIRsensors
//
//  Created by Fuffr1 on 12/06/14.
//  Copyright (c) 2014 Fuffr1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GestureRecognitionModel : NSObject

@property float xPosStart;
@property float yPosStart;
@property float xPosEnd;
@property float yPosEnd;
@property NSString *side;
@property float startdistance;
@property float enddistance;
@property float angle;
@property double duration;

@end
