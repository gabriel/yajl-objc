
default:
	xcodebuild -target CombineLibs -configuration Release build

4_0:
	xcodebuild -target "YAJLIPhone (Device-4.0)" -sdk iphoneos4.0 -configuration Release build
	xcodebuild -target "YAJLIPhone (Simulator-4.0)" -sdk iphonesimulator4.0 -configuration Release build
	BUILD_DIR="build" BUILD_STYLE="Release" FLAVOR="4_0" YAJL_VERSION="0.2.19" sh ../Scripts/CombineLibs.sh


# If you need to clean a specific target/configuration: $(COMMAND) -target $(TARGET) -configuration DebugOrRelease -sdk $(SDK) clean
clean:
	-rm -rf build/*

test:
	GHUNIT_CLI=1 xcodebuild -target Tests -configuration Debug -sdk iphonesimulator3.0 build
	
