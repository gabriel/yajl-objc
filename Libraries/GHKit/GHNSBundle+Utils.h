//
//  GHNSBundle+Utils.h
//  GHKit
//
//  Created by Gabriel Handford on 4/27/09.
//  Copyright 2009. All rights reserved.
//

@interface NSBundle (GHUtils)

/*!
 Load data from resource.
 @param resource Name of resource
 @result NSData
 */
- (NSData *)gh_loadDataFromResource:(NSString *)resource;

/*!
 Load string data from resource.
 @param resource Name of resource
 @result NSString
 */
- (NSString *)gh_loadStringDataFromResource:(NSString *)resource;

/*!
 Get URL for resource.
 @param resource Name of resource
 @result URL to resource
 */
- (NSURL *)gh_URLForResource:(NSString *)resource;

@end
