//
//  SensorSampleDataObject.h
//  SoftModemRemote
//
//  Created by johannes on 5/5/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SensorSampleDataObject : NSObject

@property (nonatomic,assign)NSString *deviceName;
@property (nonatomic,assign)NSDate *date;
@property (nonatomic,assign)NSString *place;
@property (nonatomic,assign)NSDictionary *dataDict;

-(void) print;
@end
