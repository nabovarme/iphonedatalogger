//
//  GasSampleObject.m
//  SoftModemRemote
//
//  Created by johannes on 4/28/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
// inspired by http://stackoverflow.com/questions/6969389/hex-nsstring-to-char

#import "ProtocolHelper.h"

@implementation ProtocolHelper
-(NSData*) hexToBytes:(NSString*) hexString {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= hexString.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [hexString substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}
@end
