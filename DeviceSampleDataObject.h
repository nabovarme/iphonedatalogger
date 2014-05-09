//
//  DeviceSampleDataObject.h
//  SoftModemRemote
//
//  Created by johannes on 5/5/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DeviceSampleDataObject;
@interface DeviceSampleDataObject : NSObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * deviceName;
@property (nonatomic, retain) NSString * placeName;
@property (nonatomic, retain) NSMutableDictionary *sampleDataDict;
@end
