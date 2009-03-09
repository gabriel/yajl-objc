//
//  YAJLDecoder.h
//  YAJL
//
//  Created by Gabriel Handford on 3/1/09.
//  Copyright 2009. All rights reserved.
//

#include "yajl_parse.h"

typedef enum {
	YAJLDecoderCurrentTypeNone,
	YAJLDecoderCurrentTypeArray,
	YAJLDecoderCurrentTypeDict
} YAJLDecoderCurrentType;

extern NSString *const YAJLErrorDomain;

@interface YAJLDecoder : NSObject {
	
	__weak NSMutableDictionary *dict_; // weak; if map in progress, points to the current map	
	__weak NSMutableArray *array_; // weak; If array in progress, points the current array
	__weak NSString *key_; // weak; If map in progress, points to current key
	
	id result_; // NSArray or NSDictionary to return
	
	NSMutableArray *stack_;
	NSMutableArray *keyStack_;
	
	YAJLDecoderCurrentType currentType_;
	
	yajl_handle handle_;	
}

- (id)parse:(NSData *)data error:(NSError **)error;

@end
