/*
 *  MGTemplateFilter.h
 *
 *  Created by Matt Gemmell on 12/05/2008.
 *  Copyright 2008 Instinctive Code. All rights reserved.
 *
 */
#import <Cocoa/Cocoa.h>

@protocol MGTemplateFilter <NSObject>

- (NSArray *)filters;
- (id)filterInvoked:(NSString *)filter withArguments:(NSArray *)args onValue:(NSObject *)value;

@end
