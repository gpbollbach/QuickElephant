//
//  NoteEntryTextView.m
//  QuickElephant
//
//  Created by Guy Philipp Bollbach on 07.05.10.
//  Copyright 2010 itemis GmbH. All rights reserved.
//

#import "NoteEntryTextView.h"
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


@implementation NoteEntryTextView

#pragma mark -
#pragma mark Drawing

/*
- (void)drawRect:(CGRect)rect {
	
	CGContextRef theContext = UIGraphicsGetCurrentContext();
	CGContextSaveGState(theContext);
	
	//shadow
	CGSize theOffset;
	theOffset.width = 2.5;
	if (shadowOnTop) {
		theOffset.height = 2.5;
	} else {
		theOffset.height = -2.5;
	}	
	CGContextSetShadowWithColor(theContext, theOffset, 5, [UIColor blackColor].CGColor);
	
	CGContextSetFillColorWithColor(theContext, [UIColor whiteColor].CGColor);
	
	//round corners
	CGRect rrect = self.bounds;
	rrect.origin.x += 5;
	rrect.origin.y += 5;
	rrect.size.width -= 10;
	rrect.size.height -= 10;
	
	CGFloat radius = 12.0;
	CGFloat width = CGRectGetWidth(rrect);
	CGFloat height = CGRectGetHeight(rrect);
	
	// Make sure corner radius isn't larger than half the shorter side
	if (radius > width/2.0)
		radius = width/2.0;
	if (radius > height/2.0)
		radius = height/2.0;    
	
	CGFloat minx = CGRectGetMinX(rrect);
	CGFloat midx = CGRectGetMidX(rrect);
	CGFloat maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect);
	CGFloat midy = CGRectGetMidY(rrect);
	CGFloat maxy = CGRectGetMaxY(rrect);
	CGContextMoveToPoint(theContext, minx, midy);
	CGContextAddArcToPoint(theContext, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(theContext, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(theContext, maxx, maxy, midx, maxy, radius);
	//CGContextAddArcToPoint(theContext, minx, maxy, minx, midy, radius);
	CGContextClosePath(theContext);
	CGContextDrawPath(theContext, kCGPathFill);
	
	CGContextRestoreGState(theContext);
}
*/

@end
