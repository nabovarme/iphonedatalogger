//
//  CharReceiverDelegate.h
//  SoftModemRemote
//
//  Created by johannes on 4/24/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLAppDelegate.h"
#import "CharReceiver.h"

@class CharReceiverDelegate;

@protocol CharReceiverProtocol

// define protocol functions that can be used in any class using this delegate
- (void) receivedChar:(char)input;

@end

@interface CharReceiverDelegate : NSObject <CharReceiver>{
    
}
@property (nonatomic, assign) id  delegate;


@end
