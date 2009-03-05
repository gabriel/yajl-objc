//
//  SBJSONTest.m
//  YAJL
//
//  Created by Gabriel Handford on 3/4/09.
//  Copyright 2009 Yelp. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import "NSString+SBJSON.h"

@interface SBJSONTest : GHTestCase { 
	NSString *testString_;
}
@end

@implementation SBJSONTest

- (void)setUp {
	NSString *examplePath = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"json"];
	NSData *testData = [NSData dataWithContentsOfFile:examplePath options:NSUncachedRead error:nil];
	testString_ = [[NSString alloc] initWithData:testData encoding:NSUTF8StringEncoding];
}

- (void)tearDown {
	[testString_ release];
}

- (void)testDecode {
	NSDate *date = [NSDate date];
	NSInteger count = 100000;
	for(NSInteger i = 0; i < count; i++) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		[testString_ JSONValue];
		[pool release];
	}
	NSTimeInterval interval = [date timeIntervalSinceNow];
	NSLog(@"Took %0.2f", interval);
	
}

@end
