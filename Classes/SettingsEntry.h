//
//  SettingsEntry.h
//  QuickElephant
//
//  Created by Guy Philipp Bollbach on 31.05.10.
//  Copyright 2010 itemis GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SettingsEntry : NSManagedObject {

}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *editable;
@property (nonatomic, retain) NSNumber *detailAvailable;
@property (nonatomic, retain) NSNumber *sectionId;
@property (nonatomic, retain) NSNumber *rowId;

@end
