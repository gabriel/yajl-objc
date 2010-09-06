//
//  TestAppAppDelegate.m
//  TestApp
//
//  Created by Gabriel Handford on 9/5/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "TestAppAppDelegate.h"

#import <YAJL/YAJL.h>

@implementation TestAppAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  NSArray *test = [NSArray arrayWithObjects:@"one", @"two", @"three", nil];
  NSLog(@"%@", [test yajl_JSONString]);
}

@end
