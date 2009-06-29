//
//  YAJLParser.m
//  YAJL
//
//  Created by Gabriel Handford on 6/14/09.
//  Copyright 2009. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//


#import "YAJLParser.h"

NSString *const YAJLErrorDomain = @"YAJLErrorDomain";


@interface YAJLParser ()
@property (retain, nonatomic) NSError *parserError;
@end


@interface YAJLParser (Private)
- (void)_add:(id)value;
- (void)_mapKey:(NSString *)key;

- (void)_startDictionary;
- (void)_endDictionary;

- (void)_startArray;
- (void)_endArray;

- (void)_setup;
- (void)_reset;
@end


@implementation YAJLParser

@synthesize parserError=_parserError, delegate=_delegate;

- (id)initWithData:(NSData *)data parserOptions:(YAJLParserOptions)parserOptions {
	if ((self = [super init])) {
		_data = [data retain];
		_parserOptions = parserOptions;
	}
	return self;
}

- (void)dealloc {
	[self _reset];
	[_parserError release];
	[_data release];
	[super dealloc];
}


#pragma mark YAJL Callbacks

int yajl_null(void *ctx) {
	[(id)ctx _add:[NSNull null]];
	return 1;
}

int yajl_boolean(void *ctx, int boolVal) {
	[(id)ctx _add:[NSNumber numberWithBool:(BOOL)boolVal]];
	return 1;
}

int yajl_integer(void *ctx, long integerVal) {
	[(id)ctx _add:[NSNumber numberWithLong:integerVal]];
	return 1;
}

int yajl_double(void *ctx, double doubleVal) {
	[(id)ctx _add:[NSNumber numberWithDouble:doubleVal]];
	return 1;
}

int yajl_string(void *ctx, const unsigned char *stringVal, unsigned int stringLen) {
	NSString *s = [[NSString alloc] initWithBytes:stringVal length:stringLen encoding:NSUTF8StringEncoding];
	[(id)ctx _add:s];
	[s release];
	return 1;
}

int yajl_map_key(void *ctx, const unsigned char *stringVal, unsigned int stringLen) {
	NSString *s = [[NSString alloc] initWithBytes:stringVal length:stringLen encoding:NSUTF8StringEncoding];
	[(id)ctx _mapKey:s];
	[s release];
	return 1;
}

int yajl_start_map(void *ctx) {
	[(id)ctx _startDictionary];
	return 1;
}

int yajl_end_map(void *ctx) {
	[(id)ctx _endDictionary];
	return 1;
}

int yajl_start_array(void *ctx) {
	[(id)ctx _startArray];
	return 1;
}

int yajl_end_array(void *ctx) {
	[(id)ctx _endArray];
	return 1;
}

static yajl_callbacks callbacks = {
yajl_null,
yajl_boolean,
yajl_integer,
yajl_double,
NULL,
yajl_string,
yajl_start_map,
yajl_map_key,
yajl_end_map,
yajl_start_array,
yajl_end_array
};

#pragma mark -

- (void)_setup:(NSError **)error {
	self.parserError = nil;
	
	yajl_parser_config cfg = {
		((_parserOptions & YAJLParserOptionsAllowComments == YAJLParserOptionsAllowComments) ? 1 : 0), // allowComments: if nonzero, javascript style comments will be allowed in the input (both /* */ and //)
		((_parserOptions & YAJLParserOptionsCheckUTF8 == YAJLParserOptionsCheckUTF8) ? 1 : 0)  // checkUTF8: if nonzero, invalid UTF8 strings will cause a parse error
	};

	handle_ = yajl_alloc(&callbacks, &cfg, NULL, self);
	if (!handle_) {		
		if (error) {
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Unable to allocate YAJL handle" forKey:NSLocalizedDescriptionKey];
			*error = [NSError errorWithDomain:YAJLErrorDomain code:-1 userInfo:userInfo];
			YAJLDebug(@"Error: %@", *error);
		}
		return;
	}	
}

- (void)_reset {
	if (handle_ != NULL) {
		yajl_free(handle_);
		handle_ = NULL;
	}	
}

- (void)_add:(id)value {
	[_delegate parser:self didAdd:value];
}

- (void)_mapKey:(NSString *)key {
	[_delegate parser:self didMapKey:key];
}

- (void)_startDictionary {
	[_delegate parserDidStartDictionary:self];
}

- (void)_endDictionary {
	[_delegate parserDidEndDictionary:self];
}

- (void)_startArray {	
	[_delegate parserDidStartArray:self];
}

- (void)_endArray {
	[_delegate parserDidEndArray:self];
}

- (BOOL)parse {
	YAJLDebug(@"Parsing");
	NSError *error = nil;
	[self _setup:&error];
	if (error) {
		YAJLDebug(@"Error: %@", *error);
		self.parserError = error;		
		[self _reset];
		return NO;
	}
		
	yajl_status status = yajl_parse(handle_, [_data bytes], [_data length]);
	if (status != yajl_status_insufficient_data && status != yajl_status_ok) {
		unsigned char *errorMessage = yajl_get_error(handle_, 0, [_data bytes], [_data length]);
		NSString *errorString = [NSString stringWithUTF8String:(char *)errorMessage];
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errorString forKey:NSLocalizedDescriptionKey];
		self.parserError = [NSError errorWithDomain:YAJLErrorDomain code:status userInfo:userInfo];
		YAJLDebug(@"Error: %@", *_parserError);
		yajl_free_error(handle_, errorMessage);
		[self _reset];
		return NO;
	} else {
		[self _reset];
		return YES;
	}
}

@end
