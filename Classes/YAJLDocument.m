//
//  YAJLDocument.m
//  YAJL
//
//  Created by Gabriel Handford on 3/1/09.
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


#import "YAJLDocument.h"

@interface YAJLDocument (Private)
- (void)_setup;
- (void)_reset;
- (void)_pop;
- (void)_popKey;
@end

@implementation YAJLDocument

@synthesize root=root_;

- (id)initWithData:(NSData *)data parserOptions:(YAJLParserOptions)parserOptions error:(NSError **)error {
	if ((self = [super init])) {		
		[self _setup];
		parser_ = [[YAJLParser alloc] initWithParserOptions:parserOptions];
		parser_.delegate = self;
		[parser_ parse:data];
		if (error) *error = [parser_ parserError];
		[parser_ release];
		[self _reset];
		
	}
	return self;
}

- (void)dealloc {
	[root_ release];
	[super dealloc];
}

- (void)_setup {
	[stack_ release];
	stack_ = [[NSMutableArray alloc] init];
	[keyStack_ release];
	keyStack_ = [[NSMutableArray alloc] init];
	[root_ release];
	root_ = nil;
}

- (void)_reset {
	dict_ = nil;
	array_ = nil;
	key_ = nil;
	[stack_ release];
	stack_ = nil;
	[keyStack_ release];
	keyStack_ = nil;
}

#pragma mark Delegates

- (void)parser:(YAJLParser *)parser didAdd:(id)value {
	switch(currentType_) {
		case YAJLDecoderCurrentTypeArray:
			[array_ addObject:value];
			break;
		case YAJLDecoderCurrentTypeDict:
			NSParameterAssert(key_);
			[dict_ setObject:value forKey:key_];
			[self _popKey];
			break;
	}	
}

- (void)parser:(YAJLParser *)parser didMapKey:(NSString *)key {
	key_ = key;
	[keyStack_ addObject:key_]; // Push
}

- (void)_popKey {
	key_ = nil;
	[keyStack_ removeLastObject]; // Pop	
	if ([keyStack_ count] > 0) 
		key_ = [keyStack_ objectAtIndex:[keyStack_ count]-1];	
}

- (void)parserDidStartDictionary:(YAJLParser *)parser {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	if (!root_) {
		[root_ release];
		root_ = [dict retain];
	}
	[stack_ addObject:dict]; // Push
	[dict release];
	dict_ = dict;
	currentType_ = YAJLDecoderCurrentTypeDict;	
}

- (void)parserDidEndDictionary:(YAJLParser *)parser {
	id value = [[stack_ objectAtIndex:[stack_ count]-1] retain];
	[self _pop];
	[self parser:parser didAdd:value];
	[value release];
}

- (void)parserDidStartArray:(YAJLParser *)parser {
	NSMutableArray *array = [[NSMutableArray alloc] init];
	if (!root_) {
		[root_ release];
		root_ = [array retain];
	}
	[stack_ addObject:array]; // Push
	[array release];
	array_ = array;
	currentType_ = YAJLDecoderCurrentTypeArray;
}

- (void)parserDidEndArray:(YAJLParser *)parser {
	id value = [[stack_ objectAtIndex:[stack_ count]-1] retain];
	[self _pop];	
	[self parser:parser didAdd:value];
	[value release];
}

- (void)_pop {
	[stack_ removeLastObject];
	array_ = nil;
	dict_ = nil;
	currentType_ = YAJLDecoderCurrentTypeNone;

	id value = nil;
	if ([stack_ count] > 0) value = [stack_ objectAtIndex:[stack_ count]-1];
	if ([value isKindOfClass:[NSArray class]]) {		
		array_ = (NSMutableArray *)value;
		currentType_ = YAJLDecoderCurrentTypeArray;
	} else if ([value isKindOfClass:[NSDictionary class]]) {		
		dict_ = (NSMutableDictionary *)value;
		currentType_ = YAJLDecoderCurrentTypeDict;
	}
}

@end
