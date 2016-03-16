//
//	YAJLGen.m
//	YAJL
//
//	Created by Gabriel Handford on 7/19/09.
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

#import "YAJLGen.h"
#import "yajl_gen.h"

NSString *const YAJLGenInvalidObjectException = @"YAJLGenInvalidObjectException";

@implementation YAJLGen {
	yajl_gen gen_;	
	YAJLGenOptions genOptions_;
}

- (instancetype)init {
	return [self initWithGenOptions:YAJLGenOptionsNone indentString:@""];
}

- (instancetype)initWithGenOptions:(YAJLGenOptions)genOptions indentString:(NSString *)indentString {
	if ((self = [super init])) {
		genOptions_ = genOptions;

		gen_ = yajl_gen_alloc(NULL);
		
		yajl_gen_config(gen_, yajl_gen_beautify, (genOptions & YAJLGenOptionsBeautify) ? 1 : 0);
		yajl_gen_config(gen_, yajl_gen_indent_string, (indentString ?: @"").UTF8String);
	}
	return self;
}

- (void)dealloc {
	if (gen_ != NULL) yajl_gen_free(gen_);
}

- (void)object:(id)obj {
	if ([obj respondsToSelector:@selector(JSON)]) {
		return [self object:[obj JSON]];
	} else if ([obj isKindOfClass:[NSArray class]]) {
		[self startArray];
		for(id element in obj)
		[self object:element];
		[self endArray];
	} else if ([obj isKindOfClass:[NSDictionary class]]) {
		[self startDictionary];
		for(id key in obj) {
			[self object:key];
			[self object:obj[key]];
		}
		[self endDictionary];
	} else if ([obj isKindOfClass:[NSNumber class]]) {
		if ('c' != *[obj objCType]) {
			[self number:obj];
		} else {
			[self bool:[obj boolValue]];
		}
	} else if ([obj isKindOfClass:[NSString class]]) {
		[self string:obj];
	} else if ([obj isKindOfClass:[NSNull class]]) {
		[self null];
	} else {
		
		BOOL unknownType = NO;
		if (genOptions_ & YAJLGenOptionsIncludeUnsupportedTypes) {
			// Begin with support for non-JSON representable (PList) types
			if ([obj isKindOfClass:[NSDate class]]) {
				[self number:[NSNumber numberWithLongLong:round([obj timeIntervalSince1970] * 1000)]];
			} else if ([obj isKindOfClass:[NSData class]]) {
				[self string:[(NSData*)obj base64EncodedStringWithOptions:0]];
			} else if ([obj isKindOfClass:[NSURL class]]) {
				[self string:[obj absoluteString]];
			} else {
				unknownType = YES;
			}
		} else {
			unknownType = YES;
		}
		
		// If we didn't handle special PList types
		if (unknownType) {
			if (!(genOptions_ & YAJLGenOptionsIgnoreUnknownTypes)) {
				[NSException raise:YAJLGenInvalidObjectException format:@"Unknown object type: %@ (%@)", [obj class], obj];
			} else {
				[self null]; // Use null value for unknown type if we are ignoring
			}
		}
	}
}

- (void)null {
	yajl_gen_null(gen_);
}

- (void)bool:(BOOL)b {
	yajl_gen_bool(gen_, b);
}

- (void)number:(NSNumber *)number {
	if ([number isEqualToNumber:[NSDecimalNumber notANumber]]) {
		yajl_gen_null(gen_);
	} else {
		NSString *s = number.stringValue;
		NSUInteger length = [s lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
		const char *c = s.UTF8String;
		yajl_gen_number(gen_, c, (unsigned int) length);
	}
}

- (void)string:(NSString *)s {
	NSUInteger length = [s lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	const unsigned char *c = (const unsigned char *)s.UTF8String;
	yajl_gen_string(gen_, c, (unsigned int) length);
}

- (void)startDictionary {
	yajl_gen_map_open(gen_);
}

- (void)endDictionary {
	yajl_gen_map_close(gen_);
}

- (void)startArray {
	yajl_gen_array_open(gen_);
}

- (void)endArray {
	yajl_gen_array_close(gen_);
}

- (void)clear {
	yajl_gen_clear(gen_);
}

- (NSString *)buffer {
	const unsigned char *buf;
	size_t len;
	yajl_gen_get_buf(gen_, &buf, &len);
	NSString *s = @((const char*)buf);
	return s;
}

@end




