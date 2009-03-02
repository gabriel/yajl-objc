//
//  DecoderTest.m
//  YAJL
//
//  Created by Gabriel Handford on 3/1/09.
//  Copyright 2009. All rights reserved.
//

#import <GHUnit/GHUnit.h>

#import <YAJL/YAJLDecoder.h>

@interface DecoderTest : GHTestCase { }
@end

@implementation DecoderTest

- (void)testDecode {
	
	NSString *examplePath = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"json"];
	NSData *exampleData = [NSData dataWithContentsOfFile:examplePath options:NSUncachedRead error:nil];	
	
	NSError *error = nil;
	YAJLDecoder *decoder = [[YAJLDecoder alloc] init];
	id result = [[decoder parse:exampleData error:&error] retain];
	[decoder release];
	
	NSLog(@"Error: %@", error);
	NSLog(@"Result: %@", result);
	
	[result release];
}

@end
