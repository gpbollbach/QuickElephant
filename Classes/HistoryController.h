//
//  HistoryController.h
//  QuickElephant
//
//  Created by Guy Philipp Bollbach on 18.05.10.
//  Copyright 2010 itemis GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HistoryController : UITableViewController {
	NSDictionary *historyDataset;
	NSArray *viewSections;
}
@property(nonatomic,retain) NSDictionary *historyDataset;
@property(nonatomic,retain) NSArray *viewSections;

@end
