//
//  MeterLoggerDevice.h
//  MeterLogger
//
//  Created by stoffer on 10/07/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MeterLoggerDevice : NSObject

@property AVAudioPlayer *audioPlayer;

-(void)powerOff;

@end
