//
//	YAJLDocument.m
//	YAJL
//
//	Created by Gabriel Handford on 3/1/09.
//	Copyright 2009. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person
//	obtaining a copy of this software and associated documentation
//	files (the "Software"), to deal in the Software without
//	restriction, including without limitation the rights to use,
//	copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following
//	conditions:
//
//	The above copyright notice and this permission notice shall be
//	included in all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//	OTHER DEALINGS IN THE SOFTWARE.
//


#import "YAJLDocument.h"

@interface YAJLDocument ()

@property id root; // NSArray or NSDictionary
@property YAJLParser *parser;

@property (weak) NSMutableDictionary *dict; // if map in progress, points to the current map
@property (weak) NSMutableArray *array; // If array in progress, points the current array
@property (weak) NSString *key; // If map in progress, points to current key

@property NSMutableArray *stack;
@property NSMutableArray *keyStack;

@property YAJLDecoderCurrentType currentType;

@property YAJLParserStatus parserStatus;

- (void)_pop;
- (void)_popKey;
@end

NSInteger YAJLDocumentStackCapacity = 20;

@implementation YAJLDocument

- (instancetype)init {
	return [self initWithParserOptions:0];
}

- (instancetype)initWithParserOptions:(YAJLParserOptions)parserOptions {
	return [self initWithParserOptions:parserOptions capacity:YAJLDocumentStackCapacity];
}

- (instancetype)initWithParserOptions:(YAJLParserOptions)parserOptions capacity:(NSInteger)capacity {
	if ((self = [super init])) {
		_stack = [[NSMutableArray alloc] initWithCapacity:YAJLDocumentStackCapacity];
		_keyStack = [[NSMutableArray alloc] initWithCapacity:YAJLDocumentStackCapacity];
		_parserStatus = YAJLParserStatusNone;
		_parser = [[YAJLParser alloc] initWithParserOptions:parserOptions];
		_parser.delegate = self;
	}
	return self;
}

- (instancetype)initWithData:(NSData *)data parserOptions:(YAJLParserOptions)parserOptions error:(NSError **)error {
	return [self initWithData:data parserOptions:parserOptions capacity:YAJLDocumentStackCapacity error:error];
}

- (instancetype)initWithData:(NSData *)data parserOptions:(YAJLParserOptions)parserOptions capacity:(NSInteger)capacity error:(NSError **)error {
	if ((self = [self initWithParserOptions:parserOptions capacity:capacity])) {
		[self parse:data error:error];
	}
	return self;
}

- (YAJLParserStatus)parse:(NSData *)data error:(NSError **)error {
	_parserStatus = [_parser parse:data];
	if (error) *error = _parser.parserError;
	return _parserStatus;
}

#pragma mark Delegates

- (void)parser:(YAJLParser *)parser didAdd:(id)value {
	switch (_currentType) {
		case YAJLDecoderCurrentTypeArray:
		[_array addObject:value];
		if ([_delegate respondsToSelector:@selector(document:didAddObject:toArray:)])
		[_delegate document:self didAddObject:value toArray:_array];
		break;
		case YAJLDecoderCurrentTypeDict:
		NSParameterAssert(_key);
		if (value) _dict[_key] = value;
		if ([_delegate respondsToSelector:@selector(document:didSetObject:forKey:inDictionary:)])
		[_delegate document:self didSetObject:value forKey:_key inDictionary:_dict];
		[self _popKey];
		break;
		default:
		break;
	}
}

- (void)parser:(YAJLParser *)parser didMapKey:(NSString *)key {
	_key = key;
	[_keyStack addObject:_key]; // Push
}

- (void)_popKey {
	_key = nil;
	[_keyStack removeLastObject]; // Pop
	if (_keyStack.count > 0)
	_key = _keyStack[_keyStack.count-1];
}

- (void)parserDidStartDictionary:(YAJLParser *)parser {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:YAJLDocumentStackCapacity];
	if (!_root) _root = dict;
	[_stack addObject:dict]; // Push
	_dict = dict;
	_currentType = YAJLDecoderCurrentTypeDict;
}

- (void)parserDidEndDictionary:(YAJLParser *)parser {
	id value = _stack[_stack.count-1];
	NSDictionary *dict = _dict;
	[self _pop];
	[self parser:parser didAdd:value];
	if ([_delegate respondsToSelector:@selector(document:didAddDictionary:)])
	[_delegate document:self didAddDictionary:dict];
}

- (void)parserDidStartArray:(YAJLParser *)parser {
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:YAJLDocumentStackCapacity];
	if (!_root) _root = array;
	[_stack addObject:array]; // Push
	_array = array;
	_currentType = YAJLDecoderCurrentTypeArray;
}

- (void)parserDidEndArray:(YAJLParser *)parser {
	id value = _stack[_stack.count-1];
	NSArray *array = _array;
	[self _pop];
	[self parser:parser didAdd:value];
	if ([_delegate respondsToSelector:@selector(document:didAddArray:)])
	[_delegate document:self didAddArray:array];
}

- (void)_pop {
	[_stack removeLastObject];
	_array = nil;
	_dict = nil;
	_currentType = YAJLDecoderCurrentTypeNone;
	
	id value = nil;
	if (_stack.count > 0) value = _stack[_stack.count-1];
	if ([value isKindOfClass:[NSArray class]]) {
		_array = (NSMutableArray *)value;
		_currentType = YAJLDecoderCurrentTypeArray;
	} else if ([value isKindOfClass:[NSDictionary class]]) {
		_dict = (NSMutableDictionary *)value;
		_currentType = YAJLDecoderCurrentTypeDict;
	}
}

@end
