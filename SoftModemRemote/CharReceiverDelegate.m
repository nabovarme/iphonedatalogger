//
//  CharReceiverDelegate.m
//  SoftModemRemote
//
//  Created by johannes on 4/24/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import "CharReceiverDelegate.h"
#import "UIView+Layout.h"
#import "NSString+HexColor.h"
#import "FSKSerialGenerator.h"
#include <ctype.h>


@interface NSString (NSStringHexToBytes)
-(NSData*) hexToBytes ;

@end

@implementation NSString (NSStringHexToBytes)

-(NSData*) hexToBytes {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= self.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [self substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}
@end




@implementation CharReceiverDelegate

@synthesize delegate=_delegate;

-(id)init {
    
    self = [super init];
    
    return self;
    
}



- (void) receivedChar:(char)input
{
    //NSLog(@"input");
    //NSLog(@"input from delegate%c", input);
    
    [_delegate chaCha:input];
    
	if(isprint(input)){
        //NSLog(@"inputIsAvailableChanged %c", input);
        
		//textReceived.text = [textReceived.text stringByAppendingFormat:@"%c", input];
	}
}


@end
