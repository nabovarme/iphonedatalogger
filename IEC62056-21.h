//
//  IEC62056-21.h
//  MeterLogger
//
//  Created by stoffer on 28/05/14.
//  Copyright (c) 2014 Johannes Gaardsted Jørgensen <johannesgj@gmail.com> + Kristoffer Ek <stoffer@skulp.net>. All rights reserved.
//  This program is distributed under the terms of the GNU General Public License

#import <Foundation/Foundation.h>

@interface IEC62056_21 : NSObject;

@property NSMutableData *frame;
@property BOOL frameReceived;
@property BOOL errorReceiving;

@property NSMutableDictionary *responseData;
@property NSDictionary *registerIDTable;

-(void)decodeFrame:(NSData *)theFrame;

@end
