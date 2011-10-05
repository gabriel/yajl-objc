# YAJL Framework

The YAJL framework is an Objective-C framework for the [YAJL](http://lloyd.github.com/yajl/) SAX-style JSON parser.

## Features

- Stream parsing, comments in JSON, better error messages.
- Parse directly from NSString or NSData.
- Generate JSON from default or custom types.
- Properly handles large numeric types.
- Document style parser.
- Error by exception or out error.

## Links

- The online [API documentation](http://gabriel.github.com/yajl-objc/).

## Installing in Xcode 4 (Mac OS X)

- Copy `YAJL.framework` to your project directory (maybe in MyProject/Frameworks/.)
- Add the `YAJL.framework` files (from MyProject/Frameworks/) to your target.
- In Build Settings, add `@loader_path/../Frameworks` to `Runpath Search Paths`. If you don't see `Runpath Search Paths` make sure `All` is selected instead of 'Basic'.
- In Build Phases, select `Add Build Phase`, then `Add Copy Files`.
  - Change the Destination to `Frameworks`.
  - Drag `YAJL.framework` into the the build phase
  - Make sure the copy phase appears before any `Run Script` phases
- Import with `#import <YAJL/YAJL.h>`.
- See the [API documentation](http://gabriel.github.com/yajl-objc/)

## Installing in Xcode 3 (Mac OS X)

- Copy `YAJL.framework` to your project directory (maybe in MyProject/Frameworks/.)
- Add the `YAJL.framework` files (from MyProject/Frameworks/) to your target. It should be visible as a `Linked Framework` in the target. 
- Under Build Settings, add `@loader_path/../Frameworks` to `Runpath Search Paths` 
- Add `New Build Phase` | `New Copy Files Build Phase`. 
	- Change the Destination to `Frameworks`.
	- Drag `YAJL.framework` into the the build phase
	- Make sure the copy phase appears before any `Run Script` phases 

## Installing in Xcode 4 (iOS)

- Add `YAJLiOS.framework` to your project.
- In `Build Phases`, make sure its listed in `Link Binary With Libraries`, along with:
  - `CoreGraphics.framework`
  - `Foundation.framework`
  - `UIKit.framework`
- In `Build Settings`:
  - Under `Framework Search Paths` make sure the (parent) directory to `YAJLiOS.framework` is listed.
  - Under `Other Linker Flags` in your target, add `-ObjC` and `-all_load`
- Import with `#import <YAJLiOS/YAJL.h>`.
- See the [API documentation](http://gabriel.github.com/yajl-objc/)

## Installing in Xcode 3 (iOS)

- Add `YAJLiOS.framework` to your project.
- Add the frameworks to `Linked Libraries`:
  - `YAJLiOS.framework`
  - `CoreGraphics.framework`
  - `Foundation.framework`
  - `UIKit.framework`
- Under `Framework Search Paths` make sure the (parent) directory to `YAJLiOS.framework` is listed.
- Under `Other Linker Flags` in your target, add `-ObjC` and `-all_load`
- Import with `#import "YAJLiOS/YAJL.h"`.

## Docset

Download and copy the YAJL.docset to `~/Library/Developer/Shared/Documentation/DocSets/YAJL.docset`

(You may need to restart Xcode after copying the file.)

The documentation will appear within Xcode:

![YAJL-Docset](http://rel.me.s3.amazonaws.com/yajl/images/docset.png)



