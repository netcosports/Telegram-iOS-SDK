.PHONY: build

RESULT_PATH=build/Build/Products

clean: 
	rm -rf "build/*"

build: clean
	xcodebuild -scheme TelegramSDK -workspace TelegramSDK.xcworkspace -configuration Release -arch arm64 -arch armv7 -arch armv7s only_active_arch=no defines_module=yes -derivedDataPath "build" -sdk "iphoneos" build | bundle exec xcpretty
	xcodebuild -scheme TelegramSDK -workspace TelegramSDK.xcworkspace -configuration Release -arch x86_64 only_active_arch=no defines_module=yes -derivedDataPath "build" -sdk "iphonesimulator" build | bundle exec xcpretty
	cp -r "$(RESULT_PATH)/Release-iphonesimulator/TelegramSDK.framework" "build/TelegramSDK.framework"
	lipo -create -output "build/TelegramSDK.framework/TelegramSDK" "$(RESULT_PATH)/Release-iphoneos/TelegramSDK.framework/TelegramSDK" "$(RESULT_PATH)/Release-iphonesimulator/TelegramSDK.framework/TelegramSDK"
	mv "build/TelegramSDK.framework" "release/TelegramSDK.framework"
