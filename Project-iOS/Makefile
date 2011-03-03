
default:
	xcodebuild -target "YAJLiOS (Simulator)" -configuration Release build -sdk iphonesimulator
	xcodebuild -target "YAJLiOS (Device)" -configuration Release build -sdk iphoneos
	BUILD_DIR="build" BUILD_STYLE="Release" sh ../Scripts/CombineLibs.sh
	sh ../Scripts/iPhoneFramework.sh

# If you need to clean a specific target/configuration: $(COMMAND) -target $(TARGET) -configuration DebugOrRelease -sdk $(SDK) clean
clean:
	-rm -rf build/*

test:
	GHUNIT_CLI=1 xcodebuild -target Tests -configuration Debug -sdk iphonesimulator build
