//
//  IEC62056-21.m
//  MeterLogger
//
//  Created by stoffer on 28/05/14.
//  Copyright (c) 2014 stoffer@skulp.net. All rights reserved.
//

#import "IEC62056-21.h"

@implementation IEC62056_21

@synthesize frame;
@synthesize frameReceived;
@synthesize errorReceiving;

@synthesize responseData;
@synthesize crc16Table;
@synthesize registerIDTable;
@synthesize registerUnitsTable;


#pragma mark - Init

-(id)init {
    self = [super init];
    
    self.frame = [[NSMutableData alloc] init];
    self.responseData = [[NSMutableDictionary alloc] init];
    self.frameReceived = NO;
    self.errorReceiving = NO;
    
    self.crc16Table = @[
                        @0x0000, @0x1021, @0x2042, @0x3063, @0x4084, @0x50a5, @0x60c6, @0x70e7,
                        @0x8108, @0x9129, @0xa14a, @0xb16b, @0xc18c, @0xd1ad, @0xe1ce, @0xf1ef,
                        @0x1231, @0x0210, @0x3273, @0x2252, @0x52b5, @0x4294, @0x72f7, @0x62d6,
                        @0x9339, @0x8318, @0xb37b, @0xa35a, @0xd3bd, @0xc39c, @0xf3ff, @0xe3de,
                        @0x2462, @0x3443, @0x0420, @0x1401, @0x64e6, @0x74c7, @0x44a4, @0x5485,
                        @0xa56a, @0xb54b, @0x8528, @0x9509, @0xe5ee, @0xf5cf, @0xc5ac, @0xd58d,
                        @0x3653, @0x2672, @0x1611, @0x0630, @0x76d7, @0x66f6, @0x5695, @0x46b4,
                        @0xb75b, @0xa77a, @0x9719, @0x8738, @0xf7df, @0xe7fe, @0xd79d, @0xc7bc,
                        @0x48c4, @0x58e5, @0x6886, @0x78a7, @0x0840, @0x1861, @0x2802, @0x3823,
                        @0xc9cc, @0xd9ed, @0xe98e, @0xf9af, @0x8948, @0x9969, @0xa90a, @0xb92b,
                        @0x5af5, @0x4ad4, @0x7ab7, @0x6a96, @0x1a71, @0x0a50, @0x3a33, @0x2a12,
                        @0xdbfd, @0xcbdc, @0xfbbf, @0xeb9e, @0x9b79, @0x8b58, @0xbb3b, @0xab1a,
                        @0x6ca6, @0x7c87, @0x4ce4, @0x5cc5, @0x2c22, @0x3c03, @0x0c60, @0x1c41,
                        @0xedae, @0xfd8f, @0xcdec, @0xddcd, @0xad2a, @0xbd0b, @0x8d68, @0x9d49,
                        @0x7e97, @0x6eb6, @0x5ed5, @0x4ef4, @0x3e13, @0x2e32, @0x1e51, @0x0e70,
                        @0xff9f, @0xefbe, @0xdfdd, @0xcffc, @0xbf1b, @0xaf3a, @0x9f59, @0x8f78,
                        @0x9188, @0x81a9, @0xb1ca, @0xa1eb, @0xd10c, @0xc12d, @0xf14e, @0xe16f,
                        @0x1080, @0x00a1, @0x30c2, @0x20e3, @0x5004, @0x4025, @0x7046, @0x6067,
                        @0x83b9, @0x9398, @0xa3fb, @0xb3da, @0xc33d, @0xd31c, @0xe37f, @0xf35e,
                        @0x02b1, @0x1290, @0x22f3, @0x32d2, @0x4235, @0x5214, @0x6277, @0x7256,
                        @0xb5ea, @0xa5cb, @0x95a8, @0x8589, @0xf56e, @0xe54f, @0xd52c, @0xc50d,
                        @0x34e2, @0x24c3, @0x14a0, @0x0481, @0x7466, @0x6447, @0x5424, @0x4405,
                        @0xa7db, @0xb7fa, @0x8799, @0x97b8, @0xe75f, @0xf77e, @0xc71d, @0xd73c,
                        @0x26d3, @0x36f2, @0x0691, @0x16b0, @0x6657, @0x7676, @0x4615, @0x5634,
                        @0xd94c, @0xc96d, @0xf90e, @0xe92f, @0x99c8, @0x89e9, @0xb98a, @0xa9ab,
                        @0x5844, @0x4865, @0x7806, @0x6827, @0x18c0, @0x08e1, @0x3882, @0x28a3,
                        @0xcb7d, @0xdb5c, @0xeb3f, @0xfb1e, @0x8bf9, @0x9bd8, @0xabbb, @0xbb9a,
                        @0x4a75, @0x5a54, @0x6a37, @0x7a16, @0x0af1, @0x1ad0, @0x2ab3, @0x3a92, 
                        @0xfd2e, @0xed0f, @0xdd6c, @0xcd4d, @0xbdaa, @0xad8b, @0x9de8, @0x8dc9, 
                        @0x7c26, @0x6c07, @0x5c64, @0x4c45, @0x3ca2, @0x2c83, @0x1ce0, @0x0cc1, 
                        @0xef1f, @0xff3e, @0xcf5d, @0xdf7c, @0xaf9b, @0xbfba, @0x8fd9, @0x9ff8, 
                        @0x6e17, @0x7e36, @0x4e55, @0x5e74, @0x2e93, @0x3eb2, @0x0ed1, @0x1ef0
    ];
    
    self.registerIDTable = @{@"0.0":	@"Serial no.",
                             @"6.8":   @"Heat energy",
                             @"6.26":	@"Mass register",
                             @"6.31":	@"Operational hour counter"};
    
    self.registerUnitsTable = @{@0x01: @"Wh",
                                @0x02: @"kWh",
                                @0x03: @"MWh",
                                @0x08: @"Gj",
                                @0x0c: @"Gcal",
                                @0x16: @"kW",
                                @0x17: @"MW",
                                @0x25: @"C",
                                @0x26: @"K",
                                @0x27: @"l",
                                @0x28: @"m3",
                                @0x29: @"l/h",
                                @0x2a: @"m3/h",
                                @0x2b: @"m3xC",
                                @0x2c: @"ton",
                                @0x2d: @"ton/h",
                                @0x2e: @"h",
                                @0x2f: @"clock",
                                @0x30: @"date1",
                                @0x32: @"date3",
                                @0x33: @"number",
                                @0x34: @"bar"};
    
    return self;
}


#pragma mark - IEC62056_21 CIDs

-(void)getType {
    // start byte
    self.frame = [[NSMutableData alloc] initWithBytes:(unsigned char[]){0x80} length:1];
    
    // data
    NSMutableData *data = [[NSMutableData alloc] initWithBytes:(unsigned char[]){0x3f, 0x01} length:2];
    
    // append crc 16 to data
    [data appendData:[self crc16ForData:data]];
    
    // stuff data
    data = [[self iec62056_21ByteStuff:data] mutableCopy];
    
    // create frame
    [self.frame appendData:data];
    [self.frame appendData:[[NSMutableData alloc] initWithBytes:(unsigned char[]){0x0d} length:1]];
    NSLog(@"%@", self.frame);
}

-(void)getSerialNo {
    // start byte
    self.frame = [[NSMutableData alloc] initWithBytes:(unsigned char[]){0x80} length:1];

    // data
    NSMutableData *data = [[NSMutableData alloc] initWithBytes:(unsigned char[]){0x3f, 0x02} length:2];

    // append crc 16 to data
    [data appendData:[self crc16ForData:data]];
    
    // stuff data
    data = [[self iec62056_21ByteStuff:data] mutableCopy];
    
    // create frame
    [self.frame appendData:data];
    [self.frame appendData:[[NSMutableData alloc] initWithBytes:(unsigned char[]){0x0d} length:1]];
    NSLog(@"%@", self.frame);
}

-(void)setClock:(NSDate *)theDate {
    // start byte
    self.frame = [[NSMutableData alloc] initWithBytes:(unsigned char[]){0x80} length:1];
    
    // data
    NSMutableData *data = [[NSMutableData alloc] initWithBytes:(unsigned char[]){0x3f, 0x09} length:2];
    
    NSMutableData *iec62056_21DateTime = [[NSMutableData alloc] init];
    [iec62056_21DateTime appendData:[self iec62056_21DateWithDate:theDate]];
    [iec62056_21DateTime appendData:[self iec62056_21TimeWithDate:theDate]];
    [data appendData:iec62056_21DateTime];
    NSLog(@"%@", data);
    
    // append crc 16 to data
    [data appendData:[self crc16ForData:data]];
    
    // stuff data
    data = [[self iec62056_21ByteStuff:data] mutableCopy];
    
    // create frame
    [self.frame appendData:data];
    [self.frame appendData:[[NSMutableData alloc] initWithBytes:(unsigned char[]){0x0d} length:1]];
    NSLog(@"%@", self.frame);
}

-(void)prepareFrameWithRegistersFromArray:(NSArray *)theRegisterArray {
    if (theRegisterArray.count > 8) {
        // maximal number of 8 registers can be read with one request
        NSRange range = NSMakeRange(0, 7);
        theRegisterArray = [[theRegisterArray subarrayWithRange:range] mutableCopy];
        NSLog(@"prepareFrameWithRegisters: number of registers was > 8, last ones ommitted");
    }
    
    // start byte
    self.frame = [[NSMutableData alloc] initWithBytes:(unsigned char[]){0x80} length:1];
    
    // data
    NSMutableData *data = [[NSMutableData alloc] initWithBytes:(unsigned char[]){0x3f, 0x10} length:2];
    [data appendBytes:(unsigned char[]){theRegisterArray.count} length:1];  // number of registers
    
    unsigned char registerHigh;
    unsigned char registerLow;
    for (NSNumber *reg in theRegisterArray) {
        registerHigh = (unsigned char)(reg.intValue >> 8);
        registerLow = (unsigned char)(reg.intValue & 0xff);
        [data appendData:[NSData dataWithBytes:(unsigned char[]){registerHigh, registerLow} length:2]];
    }
    // append crc 16 to data
    [data appendData:[self crc16ForData:data]];
    
    // stuff data
    data = [[self iec62056_21ByteStuff:data] mutableCopy];
    
    // create frame
    [self.frame appendData:data];
    [self.frame appendData:[[NSMutableData alloc] initWithBytes:(unsigned char[]){0x0d} length:1]];
    NSLog(@"frame: %@", self.frame);

}



#pragma mark - IEC62056_21 Decoder

-(void)decodeFrame:(NSData *)theFrame {
    self.frameReceived = NO;
    self.errorReceiving = NO;
    
    const char *bytes = theFrame.bytes;

    if (theFrame.length == 1) {
        // no data returned from Kamstrup meter
        if  (bytes[theFrame.length - 1] == 0x06) {
            self.frameReceived = YES;
            NSLog(@"hjfgj");
        }
        else {
            NSLog(@"Kamstrup: device said: no valid reply from kamstrup meter");
            self.errorReceiving = YES;
        }
        return;
    }

    if (bytes[0] == '/') {
        // ACK
        bytes = theFrame.bytes;
        //[self.responseData setObject:[NSData dataWithBytes:bytes length:theFrame.length] forKey:@"ack"];
        [self.responseData setObject:theFrame forKey:@"ack"];
    }
    else if (bytes[0] == 0x02) {
        // BCC
        NSRange range = NSMakeRange(theFrame.length - 2, 1);
        unsigned char bcc = bytes[theFrame.length - 1];
        //[self.responseData setObject:[self.frame subdataWithRange:range] forKey:@"bcc"];

        // Data block
       range = NSMakeRange(1, [theFrame length] - 2);
        NSData *dataBlock = [theFrame subdataWithRange:range];
        
        // check bcc

        // parse data
        NSString *str = [[NSString alloc] initWithData:dataBlock encoding:NSUTF8StringEncoding];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(.*?)[(](.*?)(?:[*](.*?))?[)]" options:0 error:NULL];
        NSArray* matches = [regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
        for (NSTextCheckingResult *match in matches) {
            NSRange ridGroup = [match rangeAtIndex:1];
            NSRange valueGroup = [match rangeAtIndex:2];
            NSRange unitGroup = [match rangeAtIndex:3];
            
            if (ridGroup.length && valueGroup.length) {
                NSString *rid = [str substringWithRange:ridGroup];
                NSMutableString *valueString = [[str substringWithRange:valueGroup] mutableCopy];
                [self.responseData setObject:[[NSMutableDictionary alloc] init] forKey:rid];
                
                if (unitGroup.length) {
                    NSString *unitString = [str substringWithRange:unitGroup];
                    [self.responseData[rid] setObject:unitString forKey:@"unit"];
                    NSLog(@"valueString %@", valueString);
                    // format as number
                    float valueFloat = atof([valueString UTF8String]);
                    valueString = [[[NSNumber numberWithFloat:valueFloat] stringValue] mutableCopy];
                    NSLog(@"valueString %@", valueString);
                    
                    // and append unit
                    [valueString appendString:@" "];
                    [valueString appendString:unitString];
                    
                    [self.responseData[rid] setObject:valueString forKey:@"value"];
                }
                else {
                    [self.responseData[rid] setObject:valueString forKey:@"value"];
                }
            }
        }
    }
}


#pragma mark - Helper methods

-(NSData *)crc16ForData:(NSData *)theData {
    char *buf = (char *)theData.bytes;

    int counter;
    unsigned short crc16 = 0;
    for (counter = 0; counter < theData.length; counter++) {
        crc16 = (crc16 << 8) ^ [crc16Table[((crc16 >> 8) ^ *(char *)buf++) & 0x00FF] intValue];
    }
    unsigned char crcHigh = (unsigned char)(crc16 >> 8);
    unsigned char crcLow = (unsigned char)(crc16 & 0xff);

    return [[NSData alloc] initWithBytes:(unsigned char[]){crcHigh, crcLow} length:2];
}

-(NSNumber *)numberForIEC62056_21Number:(NSNumber *)theNumber andSiEx:(NSNumber *)theSiEx {
    int32_t number = theNumber.intValue;
    int8_t siEx = theSiEx.intValue & 0xff;
    int8_t signI = (siEx & 0x80) >> 7;
    int8_t signE = (siEx & 0x40) >> 6;
    int8_t exponent = (siEx & 0x3f);
    float res = powf(-1, (float)signI) * number * powf(10, (powf(-1, (float)signE) * exponent));
    if ((res - (int)res) == 0.0) {
        return [NSNumber numberWithInt:(int32_t)res];
    }
    else {
        return [NSNumber numberWithFloat:res];
    }
}

-(NSData *)iec62056_21DateWithDate:(NSDate *)theDate {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:theDate];
    
    unsigned int year = (int)(components.year - 2000);
    unsigned int month = (int)(components.month);
    unsigned int day = (int)(components.day);
    
    NSString *dateString = [NSString stringWithFormat:@"%02d%02d%02d", year, month, day];
    NSString *hexDate = [NSString stringWithFormat:@"%08x", dateString.intValue];
    NSLog(@"%@", hexDate);

    NSMutableData *result = [[NSMutableData alloc] init];
    unsigned int i;
    for (i = 0; i < 4; i++) {
        NSRange range = NSMakeRange(2 * i, 2);
        NSString* hexValue = [hexDate substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexValue];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        unsigned char uc = (unsigned char) intValue;
        [result appendBytes:&uc length:1];
    }
    return result;
}

-(NSData *)iec62056_21TimeWithDate:(NSDate *)theDate {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:theDate];
    
    unsigned int hour = (int)(components.hour);
    unsigned int minute = (int)(components.minute);
    unsigned int second = (int)(components.second);
    
    NSString *dateString = [NSString stringWithFormat:@"%02d%02d%02d", hour, minute, second];
    NSString *hexDate = [NSString stringWithFormat:@"%08x", dateString.intValue];
    NSLog(@"%@", hexDate);
    
    NSMutableData *result = [[NSMutableData alloc] init];
    unsigned int i;
    for (i = 0; i < 4; i++) {
        NSRange range = NSMakeRange(2 * i, 2);
        NSString* hexValue = [hexDate substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexValue];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        unsigned char uc = (unsigned char) intValue;
        [result appendBytes:&uc length:1];
    }
    return result;
}

-(NSDate *)dateWithIEC62056_21Date:(NSData *)theData {
    return [NSDate date];
}

-(NSDate *)dateWithIEC62056_21Time:(NSData *)theData {
    return [NSDate date];
}

-(NSData *)iec62056_21ByteStuff:(NSData *)theData {
    unsigned char *bytes = (unsigned char *)theData.bytes;
    unsigned long len = theData.length;
    
    NSMutableData *stuffedData = [[NSMutableData alloc] init];
    
    unsigned long i;
    for (i = 0; i < len; i++) {
        if ((bytes[i] == 0x80) || (bytes[i] == 0x40) || (bytes[i] == 0x0d) || (bytes[i] == 0x06) || (bytes[i] == 0x1b)) {
            [stuffedData appendBytes:(unsigned char[]){0x1b, bytes[i] ^ 0xff} length:2];
            NSLog(@"0x80 stuffed");
        }
        else {
            [stuffedData appendBytes:(bytes + i) length:1];
        }
    }
    return stuffedData;
}

-(NSData *)iec62056_21ByteUnstuff:(NSData *)theData {
    unsigned char *bytes = (unsigned char *)theData.bytes;
    unsigned long len = theData.length;
    
    unsigned char unstuffedBytes[len];
    unsigned long unstuffedLen = 0;
    
    unsigned long i;
    unsigned j = 0;
    for (i = 0; i < len; i++) {
        if (bytes[i] == 0x1b) {          // byte stuffing special char
            unstuffedBytes[j++] = bytes[i + 1] ^ 0xff;
            unstuffedLen++;
            i++;
            NSLog(@"unstuffed %02x%02x to %02x", bytes[i - 1], bytes[i], unstuffedBytes[j - 1]);
        }
        else {
            unstuffedBytes[j++] = bytes[i];
            unstuffedLen++;
        }
    }
    
    NSData *unstuffedData = [NSData dataWithBytes:unstuffedBytes length:unstuffedLen];
    return unstuffedData;
}



@end
