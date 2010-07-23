//
//  NoteEntry.h
//  QuickElephant
//
//  Created by Guy Philipp Bollbach on 19.05.10.
//  Copyright 2010 itemis GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NoteEntry : NSManagedObject {

}
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * textContent;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic) BOOL uploaded;

@end
