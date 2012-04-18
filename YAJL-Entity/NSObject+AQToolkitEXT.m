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

#import "NSObject+AQToolkitEXT.h"


@implementation NSObject(AQToolkitEXT)

+ (NSMutableSet *)mutableSetOfObjectPropertyNames
{
    unsigned int i, count = 0;
	objc_property_t * properties = class_copyPropertyList( self, &count );
	
	if ( count == 0 )
	{
		free( properties );
		return ( nil );
	}
	
	NSMutableSet * set = [NSMutableSet setWithCapacity:10];
	
	for ( i = 0; i < count; i++ ) {
        const char *attr = property_getAttributes(properties[i]);
        for (int j = 0; attr[j] != '\0'; j++) {
            if (attr[j] == '@') {
                NSString *str = [NSString stringWithUTF8String: property_getName(properties[i])];
                [set addObject: str];
                break;
            }
        }
    }
    
    free( properties );
	
    Class superClass = [self superclass];
    if (superClass != [NSObject class])
        [set unionSet:[superClass mutableSetOfObjectPropertyNames]];
    
	return set;

}

- (NSMutableSet *)mutableSetOfObjectPropertyNames
{
    return [[self class] mutableSetOfObjectPropertyNames];
}

@end
