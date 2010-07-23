//
//  SpinnerCell.h
//  QuickElephant
//
//  Created by Guy Philipp Bollbach on 01.06.10.
//  Copyright 2010 itemis GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SpinnerCell : UITableViewCell {
	UIActivityIndicatorView *spinner;
}
@property (nonatomic, retain) UIActivityIndicatorView *spinner;

@end
