//
//  DecoderTest.m
//  YAJL
//
//  Created by Gabriel Handford on 3/1/09.
//  Copyright 2009. All rights reserved.
//

#import <GHUnit/GHUnit.h>

#import <YAJL/YAJLDecoder.h>

@interface DecoderTest : GHTestCase { 
	NSData *testData_;
}
@end

@implementation DecoderTest

- (void)setUp {
	NSString *examplePath = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"json"];
	testData_ = [[NSData dataWithContentsOfFile:examplePath options:NSUncachedRead error:nil] retain];
}

- (void)tearDown {
	[testData_ release];
}

- (void)testDecode {	
	NSError *error = nil;
	YAJLDecoder *decoder = [[YAJLDecoder alloc] initWithError:&error];
	if (error) GHFail(@"error=%@", error);
	NSDate *date = [NSDate date];
	NSInteger count = 100000;
	for(NSInteger i = 0; i < count; i++) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		[decoder parse:testData_ error:&error];
		if (error) GHFail(@"error=%@", error);
		[pool release];
	}
	NSTimeInterval interval = [date timeIntervalSinceNow];
	NSLog(@"Took %0.2f", interval);
	[decoder release];
}

@end
