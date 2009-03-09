//
//  YAJLDecoder.m
//  YAJL
//
//  Created by Gabriel Handford on 3/1/09.
//  Copyright 2009. All rights reserved.
//

#import "YAJLDecoder.h"

@interface YAJLDecoder (Private)
- (void)_pop;

- (void)_add:(id)value;
- (void)_mapKey:(NSString *)key;
- (void)_popKey;

- (void)_startDictionary;
- (void)_endDictionary;

- (void)_startArray;
- (void)_endArray;

- (void)_setup;
- (void)_reset;
- (void)_setError:(NSError **)error status:(NSInteger)status errorMessage:(NSString *)errorMessage;
@end

NSString *const YAJLErrorDomain = @"YAJL";

#define YAJLDebug(...) NSLog(__VA_ARGS__)
//#define YAJLDebug(...) do { } while(0)

@implementation YAJLDecoder

#pragma mark YAJL Callbacks

int yajl_null(void *ctx) {
	//YAJLDebug(@"NULL");
	[(id)ctx _add:[NSNull null]];
	return 1;
}

int yajl_boolean(void *ctx, int boolVal) {
	//YAJLDebug(@"BOOL(%d)", boolVal);
	[(id)ctx _add:[NSNumber numberWithBool:(BOOL)boolVal]];
	return 1;
}

int yajl_integer(void *ctx, long integerVal) {
	//YAJLDebug(@"Integer(%d)", integerVal);
	[(id)ctx _add:[NSNumber numberWithLong:integerVal]];
	return 1;
}

int yajl_double(void *ctx, double doubleVal) {
	//YAJLDebug(@"Double(%0.5f)", doubleVal);
	[(id)ctx _add:[NSNumber numberWithDouble:doubleVal]];
	return 1;
}

int yajl_string(void *ctx, const unsigned char *stringVal, unsigned int stringLen) {
	NSString *s = [[NSString alloc] initWithBytes:stringVal length:stringLen encoding:NSUTF8StringEncoding];
	//YAJLDebug(@"String(%@)", s);
	[(id)ctx _add:s];
	[s release];
	return 1;
}

int yajl_map_key(void *ctx, const unsigned char *stringVal, unsigned int stringLen) {
	NSString *s = [[NSString alloc] initWithBytes:stringVal length:stringLen encoding:NSUTF8StringEncoding];
	//YAJLDebug(@"MapKey(%@)", s);
	[(id)ctx _mapKey:s];
	return 1;
}

int yajl_start_map(void *ctx) {
	//YAJLDebug(@"StartMap");
	[(id)ctx _startDictionary];
	return 1;
}

int yajl_end_map(void *ctx) {
	//YAJLDebug(@"EndMap");
	[(id)ctx _endDictionary];
	return 1;
}

int yajl_start_array(void *ctx) {
	//YAJLDebug(@"StartArray");
	[(id)ctx _startArray];
	return 1;
}

int yajl_end_array(void *ctx) {
	//YAJLDebug(@"EndArray");
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

- (void)dealloc {
	[self _reset];
	[result_ release];
	result_ = nil;
	[super dealloc];
}

- (void)_setup:(NSError **)error {
	yajl_parser_config cfg = {
		0, // allowComments: if nonzero, javascript style comments will be allowed in the input (both /* */ and //)
		0  // checkUTF8: if nonzero, invalid UTF8 strings will cause a parse error
	};
	handle_ = yajl_alloc(&callbacks, &cfg, self);
	if (!handle_) {		
		if (error) {
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Unable to allocate YAJL handle" forKey:NSLocalizedDescriptionKey];
			*error = [NSError errorWithDomain:YAJLErrorDomain code:-1 userInfo:userInfo];
			YAJLDebug(@"Error: %@", *error);
		}
		return;
	}			
	
	[stack_ release];
	stack_ = [[NSMutableArray alloc] init];
	[keyStack_ release];
	keyStack_ = [[NSMutableArray alloc] init];
	[result_ release];
	result_ = nil;
}

- (void)_reset {
	if (handle_ != NULL) {
		yajl_free(handle_);
		handle_ = NULL;
	}
	dict_ = nil;
	array_ = nil;
	key_ = nil;
	[stack_ release];
	stack_ = nil;
	[keyStack_ release];
	keyStack_ = nil;
}

- (void)_add:(id)value {
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

- (void)_mapKey:(NSString *)key {
	key_ = key;
	[keyStack_ addObject:key_]; // Push
}

- (void)_popKey {
	key_ = nil;
	[keyStack_ removeLastObject]; // Pop	
	if ([keyStack_ count] > 0) 
		key_ = [keyStack_ objectAtIndex:[keyStack_ count]-1];	
}

- (void)_startDictionary {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	if (!result_) {
		[result_ release];
		result_ = [dict retain];
	}
	[stack_ addObject:dict]; // Push
	[dict release];
	dict_ = dict;
	currentType_ = YAJLDecoderCurrentTypeDict;	
}

- (void)_endDictionary {
	id value = [[stack_ objectAtIndex:[stack_ count]-1] retain];
	[self _pop];
	[self _add:value];
	[value release];
}

- (void)_startArray {	
	NSMutableArray *array = [[NSMutableArray alloc] init];
	if (!result_) {
		[result_ release];
		result_ = [array retain];
	}
	[stack_ addObject:array]; // Push
	[array release];
	array_ = array;
	currentType_ = YAJLDecoderCurrentTypeArray;
}

- (void)_endArray {
	id value = [[stack_ objectAtIndex:[stack_ count]-1] retain];
	[self _pop];	
	[self _add:value];
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

- (void)_setError:(NSError **)error status:(NSInteger)status errorMessage:(NSString *)errorMessage {	
	if (error) {
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errorMessage forKey:NSLocalizedDescriptionKey];
		*error = [NSError errorWithDomain:YAJLErrorDomain code:status userInfo:userInfo];
	}
}

- (id)parse:(NSData *)data error:(NSError **)error {
	[self _setup:error];
	if (*error) {
		YAJLDebug(@"Error: %@", *error);
		[self _reset];
		return nil;
	}
		
	yajl_status status = yajl_parse(handle_, [data bytes], [data length]);
	if (status != yajl_status_insufficient_data && status != yajl_status_ok) {
		unsigned char *errorMessage = yajl_get_error(handle_, 0, [data bytes], [data length]);
		NSString *errorString = [NSString stringWithUTF8String:(char *)errorMessage];
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errorString forKey:NSLocalizedDescriptionKey];
		if (error) *error = [NSError errorWithDomain:YAJLErrorDomain code:status userInfo:userInfo];
		YAJLDebug(@"Error: %@", *error);
		yajl_free_error(errorMessage);
	}

	[self _reset];	
	return result_;
}	



@end
