//
//  BatteryLifeModel.h
//  TestingIRsensors
//
//  Created by Fuffr2 on 25/06/14.
//  Copyright (c) 2014 Fuffr2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BatteryLifeModel : NSObject

@property (strong, nonatomic) NSDate *timestamp;
@property (strong, nonatomic) NSString *info, *side;
@property (nonatomic) int previousNumOfActiveTouches, currentNumOfActiveTouches;


@end
