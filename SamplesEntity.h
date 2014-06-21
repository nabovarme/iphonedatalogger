//
//  SamplesEntity.h
//  SoftModemRemote
//
//  Created by johannes on 4/30/14.
//  Copyright (c) 2014 Johannes Gaardsted Jørgensen <johannesgj@gmail.com> + Kristoffer Ek <stoffer@skulp.net>. All rights reserved.
//  This program is distributed under the terms of the GNU General Public License

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SamplesEntity;
@interface SamplesEntity : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * deviceName;
@property (nonatomic, retain) NSString * placeName;
@property (nonatomic, retain) id sampleDataDict;

@end
