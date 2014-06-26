//
//  KamstrupRequest.m
//  MeterLogger
//
//  Created by johannes on 6/26/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import "KamstrupRequest.h"

@interface KamstrupRequest()

@end

@implementation KamstrupRequest

- (void)receivedChar:(unsigned char)input;
{
    NSLog(@"lol multical received a char lol");
}

- (void)sendRequest {

}

- (void)sendKamstrupRequest:(NSOperation *)theOperation {
}

@end
