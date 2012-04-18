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
#import "MyAddress.h"
#import "NSString+CaseExt.h"

@interface YAJL_EntityTest : YAJLTestCase
@end

@implementation YAJL_EntityTest

- (void)testYAJL_Entity
{    
    NSData *data = [self loadData:@"my-entity"];
    
    MyEntity *entity = [data objectFromJSONOfType:[MyEntity class]];
    
    GHAssertEqualStrings(entity.name, @"the entity name", nil);
    GHAssertEquals(entity.value, 100, nil);
    NSArray *followers = [NSArray arrayWithObjects:[NSNumber numberWithInt:200],
                          [NSNumber numberWithInt:201],
                          [NSNumber numberWithInt:202],
                          [NSNumber numberWithInt:205], nil];
    GHAssertEqualObjects(entity.followers, followers, nil);
    GHAssertEquals([entity.addresses count], 2u, nil);
    
    MyAddress *a1 = [entity.addresses objectAtIndex:0];
    MyAddress *a2 = [entity.addresses objectAtIndex:1];
    
    GHAssertEqualStrings(a1.city, @"Shanghai", nil);
    GHAssertEquals(a1.zipcode, 200000, nil);
    GHAssertEqualStrings(a2.city, @"Beijing", nil);
    GHAssertEquals(a2.zipcode, 100000, nil);
    
    GHAssertTrue(entity.isNew, nil);
    GHAssertTrue(entity.outdated, nil);
    
    GHAssertNotNil(entity.parent, nil);
    GHAssertEqualStrings(entity.parent.name, @"the inner entity name", nil);
    GHAssertEquals(entity.parent.value, 0, nil);
    GHAssertEquals([entity.parent.addresses count], 2u, nil);
    
    a1 = [entity.parent.addresses objectAtIndex:0];
    a2 = [entity.parent.addresses objectAtIndex:1];
    
    GHAssertEqualStrings(a1.city, @"Shanghai inner", nil);
    GHAssertEquals(a1.zipcode, 200000, nil);
    GHAssertEqualStrings(a2.city, @"Beijing inner", nil);
    GHAssertEquals(a2.zipcode, 100000, nil);
    
    GHAssertNil(entity.parent.parent, nil);
}


@end
