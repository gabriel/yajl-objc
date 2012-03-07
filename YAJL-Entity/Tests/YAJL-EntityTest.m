//
//  YAJL-EntityTest.m
//  YAJLiOS
//
//  Created by Eli Wang on 3/7/12.
//  Copyright (c) 2012 ekohe.com. All rights reserved.
//
#import "YAJLTestCase.h"
#import "YAJL-Entity.h"
#import "MyEntity.h"

@interface YAJL_EntityTest : YAJLTestCase
@end

@implementation YAJL_EntityTest

- (void)testYAJL_Entity
{
    NSLog(@"Hello, world");
    
    NSData *data = [self loadData:@"my-entity"];
    MyEntity *entity = [data objectFromJSONOfType:[MyEntity class]];
    
    NSString *jsonString = [entity yajl_JSONStringWithOptions:YAJLGenOptionsBeautify indentString:@"  "];
    GHTestLog(jsonString);
}


@end
