//
//	YAJLDocumentTest.m
//	YAJL
//
//	Created by Gabriel Handford on 3/1/09.
//	Copyright 2009. All rights reserved.
//

#import "YAJLTestCase.h"
#import "YAJLDocument.h"

@interface YAJLDocumentTest : YAJLTestCase {}
@end

@implementation YAJLDocumentTest

- (YAJLDocument *)_loadDocument:(NSString *)sampleName parserOptions:(YAJLParserOptions)parserOptions error:(NSError **)error {
	NSData *data = [self loadData:sampleName];
	YAJLDocument *document = [[YAJLDocument alloc] initWithData:data parserOptions:parserOptions error:error];
	return document;
}

- (void)test {
	NSError *error = nil;
	YAJLDocument *document = [self _loadDocument:@"example" parserOptions:0 error:&error];
	if (error) XCTFail(@"Error: %@", error);
	NSLog(@"Root: %@", document.root);
}

- (void)testStreaming {
	YAJLDocument *document = [[YAJLDocument alloc] init];
	
	NSError *error = nil;
	NSData *data1 = [self loadData:@"stream_array1"];
	YAJLParserStatus status1 = [document parse:data1 error:&error];
	XCTAssertEqual(status1, YAJLParserStatusOK);
	if (error) XCTFail(@"Error: %@", error);
	NSLog(@"First part: %@", document.root);
	
	NSData *data2 = [self loadData:@"stream_array2"];
	YAJLParserStatus status2 = [document parse:data2 error:&error];
	XCTAssertEqual(status2, YAJLParserStatusOK);
	if (error) XCTFail(@"Error: %@", error);
	
	NSLog(@"Root: %@", document.root);
}

- (void)testDoubleOverflow {
	NSError *error = nil;
	YAJLDocument *document = [self _loadDocument:@"overflow" parserOptions:0 error:&error];
	XCTAssertNotNil(document);
	NSLog(@"Root: %@", document.root);
	YAJLParserStatus status = document.parserStatus;
	XCTAssertEqual(status, (NSUInteger)YAJLParserStatusError, @"Should have error status");
	
	if (error) {
		NSLog(@"Parse error:\n%@", error);
		XCTAssertEqual([error code], (NSInteger)YAJLParserErrorCodeDoubleOverflow);
		XCTAssertEqualObjects([error userInfo][YAJLParserValueKey], @"1.79769e+309");
	} else {
		XCTFail(@"Should have error");
	}
}

- (void)testOverflow2 {
	NSError *error = nil;
	YAJLDocument *document = [self _loadDocument:@"overflow2" parserOptions:0 error:&error];
	NSLog(@"Root: %@", document.root);
	YAJLParserStatus status = document.parserStatus;
	XCTAssertEqual(status, (NSUInteger)YAJLParserStatusOK, @"Should have OK status");
	XCTAssertEqualObjects((document.root)[@"key1"], @12343434343434343434343434344343434.0);
	XCTAssertEqualObjects((document.root)[@"key2"], @343434343434344343434343434.0);
}

@end
