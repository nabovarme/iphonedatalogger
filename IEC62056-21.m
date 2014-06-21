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
@synthesize registerIDTable;


#pragma mark - Init

-(id)init {
    self = [super init];
    
    self.frame = [[NSMutableData alloc] init];
    self.responseData = [[NSMutableDictionary alloc] init];
    self.frameReceived = NO;
    self.errorReceiving = NO;
    
    self.registerIDTable = @{@"0.0":	@"Serial no.",
                             @"6.8":   @"Heat energy",
                             @"6.26":	@"Mass register",
                             @"6.31":	@"Operational hour counter"};
    return self;
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

    if ((bytes[0] == 0x02) | (bytes[0] == '/')) {
        // Ident
        NSString *str = [[NSString alloc] initWithData:theFrame encoding:NSUTF8StringEncoding];
        NSError *regexError;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[/](.*?)\r\n[\x02]?" options:NSRegularExpressionDotMatchesLineSeparators error:&regexError];
        if (regexError) {
            NSLog(@"%@",regexError.localizedDescription);
        }
        NSTextCheckingResult *match = [regex firstMatchInString:str options:kNilOptions range:NSMakeRange(0, str.length)];
        NSRange range = [match rangeAtIndex:1];
        if (range.location != NSNotFound) {
            NSData *identData = [theFrame subdataWithRange:range];
            NSString *ident = [[NSString alloc] initWithData:identData encoding:NSUTF8StringEncoding];
            [self.responseData setObject:ident forKey:@"ident"];
        }
        
        // Data block
        str = [[NSString alloc] initWithData:theFrame encoding:NSUTF8StringEncoding];
        regex = [NSRegularExpression regularExpressionWithPattern:@"\x02(.*).$" options:NSRegularExpressionDotMatchesLineSeparators error:&regexError];
        if (regexError) {
            NSLog(@"%@",regexError.localizedDescription);
        }
        match = [regex firstMatchInString:str options:kNilOptions range:NSMakeRange(0, str.length)];
        range = [match rangeAtIndex:1];
        if (range.location != NSNotFound) {
            NSData *dataBlock = [theFrame subdataWithRange:range];
            if (dataBlock.length) {
                // get bcc
                range = NSMakeRange(theFrame.length - 2, 1);
                uint8_t bcc = bytes[theFrame.length - 1];

                // calculate bcc
                uint8_t calculatedBCC = 0;
                for (unsigned int i = 0; i < dataBlock.length; i++) {
                    range = NSMakeRange(i, 1);
                    const char *b = [[dataBlock subdataWithRange:range] bytes];
                    calculatedBCC += b[0];
                    calculatedBCC &= 0x7f;  // 7 bit value
                }
                if (calculatedBCC == bcc) {
                    NSLog(@"bcc ok");
                    frameReceived = YES;
                    
                    // parse data
                    NSString *str = [[NSString alloc] initWithData:dataBlock encoding:NSUTF8StringEncoding];
                    NSError *regexError;
                    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(.*?)[(](.*?)(?:[*](.*?))?[)]" options:kNilOptions error:&regexError];
                    if (regexError) {
                        NSLog(@"%@",regexError.localizedDescription);
                    }
                    
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
                                // localized number format
                                valueString = [[NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:valueFloat] numberStyle:NSNumberFormatterDecimalStyle] mutableCopy];
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
                    errorReceiving = NO;
                }
                else {
                    NSLog(@"bcc error");
                    errorReceiving = YES;
                    frameReceived = NO;
                }
            }
            else {
                // this meter sends data separate from ack
                frameReceived = YES;
            }
        }
    }
    else {
        // start byte type not handled
        NSLog(@"unknown start byte");
        errorReceiving = YES;
        frameReceived = NO;
    }
}

@end
