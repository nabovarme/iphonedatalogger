//
//  IEC62056-21.h
//  MeterLogger
//
//  Created by stoffer on 28/05/14.
//  Copyright (c) 2014 stoffer@skulp.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IEC62056_21 : NSObject;

@property NSMutableData *frame;
@property BOOL frameReceived;
@property BOOL errorReceiving;

@property NSMutableDictionary *responseData;
@property NSArray *crc16Table;
@property NSDictionary *registerIDTable;
@property NSDictionary *registerUnitsTable;


-(void)getType;
-(void)getSerialNo;
-(void)setClock:(NSDate *)theDate;
-(void)prepareFrameWithRegistersFromArray:(NSArray *)theRegisterArray;
//-(void)putRegister:(NSNumber *)theRegister withPassword:(NSNumber *)thePassword andValue:(NSNumber *)theValue;


-(void)decodeFrame:(NSData *)theFrame;

-(NSData *)crc16ForData:(NSData *)theData;
-(NSNumber *)numberForIEC62056_21Number:(NSNumber *)theNumber andSiEx:(NSNumber *)theSiEx;

-(NSData *)iec62056_21DateWithDate:(NSDate *)theDate;
-(NSData *)iec62056_21TimeWithDate:(NSDate *)theDate;

-(NSDate *)dateWithIEC62056_21Date:(NSData *)theData;
-(NSDate *)dateWithIEC62056_21Time:(NSData *)theData;

-(NSData *)iec62056_21ByteStuff:(NSData *)theData;
-(NSData *)iec62056_21ByteUnstuff:(NSData *)theData;

@end
