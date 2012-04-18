/*
 * Copyright (c) 2012 Eli Wang
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */

#import "NSData+YAJLtoObject.h"
#import "YAJLObjectParser.h"


@implementation NSData(YAJLtoObject)


- (id)newObjectFromJSONOfType:(Class)klass withOptions:(YAJLParserOptions)option
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	YAJLParser *parser = [[YAJLParser alloc] initWithParserOptions: option];
	YAJLObjectParser *objParser = [[YAJLObjectParser alloc] initWithClass:klass parser:parser];
	[parser parse:self];
    [objParser cleanClassObjects];
	id ret = [objParser.root retain];
	
	parser.delegate = nil;
	[objParser release];
	[parser release];
	[pool drain];
	return ret;
}

- (id)objectFromJSONOfType:(Class)klass withOptions:(YAJLParserOptions)option
{
	return [[self newObjectFromJSONOfType:klass withOptions:option] autorelease];
}

- (id)newObjectFromJSONOfType:(Class)klass
{
	return [self newObjectFromJSONOfType: klass withOptions: YAJLParserOptionsNone];
}

- (id)objectFromJSONOfType:(Class)klass
{
	return [self objectFromJSONOfType:klass withOptions:YAJLParserOptionsNone];
}

- (void)fillObject:(id)obj withOptions:(YAJLParserOptions)option
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	YAJLParser *parser = [[YAJLParser alloc] initWithParserOptions: option];
	YAJLObjectParser *objParser = [[YAJLObjectParser alloc] initWithStubObject:obj parser:parser];
	[parser parse:self];
    [objParser cleanClassObjects];
	
	parser.delegate = nil;
	[objParser release];
	[parser release];
	[pool drain];
}

- (void)fillObject:(id)obj
{
    [self fillObject:obj withOptions:YAJLGenOptionsNone];
}

@end
