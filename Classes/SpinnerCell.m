//
//  SpinnerCell.m
//  QuickElephant
//
//  Created by Guy Philipp Bollbach on 01.06.10.
//  Copyright 2010 itemis GmbH. All rights reserved.
//

#import "SpinnerCell.h"


@implementation SpinnerCell
@synthesize spinner;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.textLabel.text = @"placeholder";
		CGRect bounds = [[self contentView] bounds];
		CGRect rectTmp = CGRectInset(bounds, 0.0, 0.0);
		
		CGFloat textPosition = 70.0;
		CGRect rect = CGRectMake(CGRectGetMinX(rectTmp)+textPosition, CGRectGetMinY(rectTmp),CGRectGetWidth(rectTmp)-textPosition, CGRectGetHeight(rectTmp));
		
		UIActivityIndicatorView *spinnerTmp = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//		spinnerTmp.bounds.origin.x = CGRectGetMinX(rectTmp)+textPosition;
//		spinnerTmp.bounds.origin.y = CGRectGetMinY(rectTmp);
		//spinnerTmp.bounds = CGRectMake(CGRectGetMinX(rectTmp)+textPosition, CGRectGetMinY(rectTmp), CGRectGetWidth(spinnerTmp.bounds), CGRectGetHeight(spinnerTmp.bounds));
		CGRect newFrame = spinnerTmp.frame;
		newFrame.origin.x = CGRectGetMinX(newFrame)+textPosition;
		newFrame.origin.y = CGRectGetMinY(newFrame)+(CGRectGetHeight(self.bounds)/4.0);
		spinnerTmp.frame = newFrame;
		[[self contentView] addSubview:spinnerTmp];
		self.spinner = spinnerTmp;
		
		[spinnerTmp release];
//		self.spinner.hidden = NO;
		//[self.spinner startAnimating];
	}   
	
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
