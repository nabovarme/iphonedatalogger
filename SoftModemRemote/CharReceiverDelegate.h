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

@protocol CharReceiverProtocol <NSObject>


// define protocol functions that can be used in any class using this delegate
@optional
-(void)chaCha:(char)myChar;

@end

@interface CharReceiverDelegate : NSObject <CharReceiver>{
    id<CharReceiverProtocol> delegate;
}
@property (nonatomic, assign) id  delegate;



@end
