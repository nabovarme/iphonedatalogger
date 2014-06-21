//
//  DeviceSampleDataObject.h
//  SoftModemRemote
//
//  Created by johannes on 5/5/14.
//  Copyright (c) 2014 Johannes Gaardsted Jørgensen <johannesgj@gmail.com> + Kristoffer Ek <stoffer@skulp.net>. All rights reserved.
//  This program is distributed under the terms of the GNU General Public License

#import <Foundation/Foundation.h>

@class DeviceSampleDataObject;
@interface DeviceSampleDataObject : NSObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * deviceName;
@property (nonatomic, retain) NSString * placeName;
@property (nonatomic, retain) NSMutableDictionary *sampleDataDict;
@end
