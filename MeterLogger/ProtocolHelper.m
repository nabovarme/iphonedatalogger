//
//  GasSampleObject.m
//  SoftModemRemote
//
//  Created by johannes on 4/28/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
// inspired by http://stackoverflow.com/questions/6969389/hex-nsstring-to-char

#import "ProtocolHelper.h"

@implementation ProtocolHelper
-(NSData*) hexStringToBytes:(NSString*) hexString {
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
/*
- (NSData *)asciiStringToBytes:(NSString *)asciiString
{
    char *utf8 = [string UTF8String];
    NSMutableString *hex = [NSMutableString string];
    while ( *utf8 ) [hex appendFormat:@"%02X" , *utf8++ & 0x00FF];
    
    return [NSString stringWithFormat:@"%@", hex];
}*/
@end
