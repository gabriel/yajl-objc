//
//  YAJLParserTest.m
//  YAJL
//
//  Created by Gabriel Handford on 6/14/09.
//  Copyright 2009. All rights reserved.
//


#import <GHUnit/GHUnit.h>

#import <YAJL/YAJLParser.h>

@interface YAJLParserTest : GHTestCase { 
	NSData *testData_;
}
@end

@implementation YAJLParserTest

- (void)setUp {
}

- (void)tearDown {
	
}

- (void)test {	
	NSString *examplePath = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"json"];
	NSData *testData = [[NSData dataWithContentsOfFile:examplePath options:NSUncachedRead error:nil] retain];
	
	YAJLParser *parser = [[YAJLParser alloc] initWithData:testData_ parserOptions:0];
	[parser parse];
	
	NSError *error = [parser parserError];
	if (error) {
		NSLog(@"Parse error:\n%@", error);
		GHFail(@"Error: %@", error);
	}
	
	[parser release];
	[testData release];
}

- (void)testError {
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"error" ofType:@"json"];
	NSData *data = [[NSData dataWithContentsOfFile:path options:NSUncachedRead error:nil] retain];
	
	YAJLParser *parser = [[YAJLParser alloc] initWithData:data parserOptions:0];
	BOOL ok = [parser parse];
	GHAssertFalse(ok, @"Should not have OK status");
	
	NSError *error = [parser parserError];
	if (error) {
		GHTestLog(@"Parse error:\n%@", error);		
	} else {
		GHFail(@"Should have error");
	}
	
	[parser release];
	[data release];
}

- (void)testComments {
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"comments" ofType:@"json"];
	NSData *data = [[NSData dataWithContentsOfFile:path options:NSUncachedRead error:nil] retain];
	
	YAJLParser *parser = [[YAJLParser alloc] initWithData:data parserOptions:YAJLParserOptionsAllowComments];
	[parser parse];
	
	NSError *error = [parser parserError];
	if (error) {
		GHTestLog(@"Parse error:\n%@", error);		
		GHFail(@"Error: %@", error);
	}
	
	[parser release];
	[data release];
}

- (void)testFailOnComments {
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"comments" ofType:@"json"];
	NSData *data = [[NSData dataWithContentsOfFile:path options:NSUncachedRead error:nil] retain];
	
	YAJLParser *parser = [[YAJLParser alloc] initWithData:data parserOptions:0];
	[parser parse];
	
	NSError *error = [parser parserError];
	if (error) {
		GHTestLog(@"Parse error:\n%@", error);		
	} else {
		GHFail(@"Should have error");
	}

	[parser release];
	[data release];
}

@end