//
//  GasSampleObject.h
//  SoftModemRemote
//
//  Created by johannes on 4/28/14.
//  Copyright (c) 2014 Johannes Gaardsted Jørgensen <johannesgj@gmail.com> + Kristoffer Ek <stoffer@skulp.net>. All rights reserved.
//  This program is distributed under the terms of the GNU General Public License

#import <Foundation/Foundation.h>

@interface ProtocolHelper : NSObject

-(NSData*) hexStringToBytes:(NSString*) hexString;
//-(NSData*) asciiStringToBytes:(NSString*) asciiString;
@end
