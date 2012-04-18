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

#import "NSString+CaseExt.h"


@implementation NSString(CaseExt)

- (NSString *) stringByUppercaseFirstChar {
	return [self stringByReplacingCharactersInRange:NSMakeRange(0, 1) 
										 withString:[[self substringToIndex:1] uppercaseString]];
}

- (NSString *) stringByLowercaseFirstChar {
	return [self stringByReplacingCharactersInRange:NSMakeRange(0, 1) 
										 withString:[[self substringToIndex:1] lowercaseString]];
}

- (NSString *)camelcaseString
{
    NSMutableArray *components = [[[self componentsSeparatedByString:@"_"] mutableCopy] autorelease];
    if ([components count] > 1) {
        for (int i = 1, c = [components count]; i < c; i++) {
            NSString *str = [components objectAtIndex:i];
            [components replaceObjectAtIndex:i withObject:[str stringByUppercaseFirstChar]];
        }
    }
    
    return [components componentsJoinedByString:@""];
}

- (NSString *)snakecaseString
{
//    @throw [NSException exceptionWithName:@"Not Implemented" reason:nil userInfo:nil];
    NSMutableString *ret = [NSMutableString stringWithCapacity:[self length] + 5];
    NSCharacterSet *upppercased = [NSCharacterSet uppercaseLetterCharacterSet];
    
    BOOL addUnderscore = NO;
    for (int i = 0; i < [self length]; i++) {
        unichar aChar = [self characterAtIndex:i];
        if ([upppercased characterIsMember:aChar]) {
            NSString *lowerChar = [[NSString stringWithCharacters:&aChar length:1] lowercaseString];
            
            if (addUnderscore) {
                [ret appendFormat:@"_%@", lowerChar];
            } else {
                [ret appendString:lowerChar];
            }
            addUnderscore = NO;
        } else {
            [ret appendFormat:@"%C", aChar];
            addUnderscore = YES;
        }
        
    }
             
    return ret;
}

@end
