//
//  MeterLoggerDevice.m
//  MeterLogger
//
//  Created by stoffer on 10/07/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import "MeterLoggerDevice.h"

@implementation MeterLoggerDevice

@synthesize audioPlayer;

-(id)init {
	self = [super init];
    
	NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/power_on.aiff", [[NSBundle mainBundle] resourcePath]]];
	
	NSError *error;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioPlayer.numberOfLoops = -1;
	
	if (audioPlayer == nil)
		NSLog([error description]);
	else
		[audioPlayer play];
    
    return self;
}

-(void)powerOff {
    [self.audioPlayer stop];
    self.audioPlayer = nil;
}

@end
