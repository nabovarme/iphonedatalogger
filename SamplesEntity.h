//
//  SamplesEntity.h
//  SoftModemRemote
//
//  Created by johannes on 4/30/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SamplesEntity;
@interface SamplesEntity : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * deviceName;
@property (nonatomic, retain) NSString * placeName;
@property (nonatomic, retain) id sampleDataDict;

@end
