.PHONY: clean build

RESULT_PATH=build/Build/Products
FRAMEWORK=TelegramSDK

clean: 
	rm -rf "build"

build: clean
	xcodebuild -scheme TelegramSDK -workspace TelegramSDK.xcworkspace -configuration Release -arch arm64 -arch armv7 -arch armv7s only_active_arch=no defines_module=yes -derivedDataPath "build" -sdk "iphoneos" build | bundle exec xcpretty
	xcodebuild -scheme TelegramSDK -workspace TelegramSDK.xcworkspace -configuration Release -arch x86_64 -arch i386 only_active_arch=no defines_module=yes -derivedDataPath "build" -sdk "iphonesimulator" build | bundle exec xcpretty
	rsync -rtvu --delete "$(RESULT_PATH)/Release-iphonesimulator/$(FRAMEWORK).framework/" "build/$(FRAMEWORK).framework/"
	lipo -create -output "build/$(FRAMEWORK).framework/$(FRAMEWORK)" "$(RESULT_PATH)/Release-iphoneos/$(FRAMEWORK).framework/$(FRAMEWORK)" "$(RESULT_PATH)/Release-iphonesimulator/$(FRAMEWORK).framework/$(FRAMEWORK)"
