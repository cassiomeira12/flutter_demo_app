PLATFORMS := android ios macos web
ENVS := $(shell ls .env*)
GIT_COMMITS_COUNT := $(shell git rev-list --count HEAD ^master)
BUILD_NAME := $(shell echo "$(shell grep 'version: ' pubspec.yaml)" | sed -E 's/version: ([0-9]+\.[0-9]+\.[0-9]+)\+.*/\1/')

.PHONY: rebase
rebase:
	@clear
	@echo ""
	@read -p "Enter the branch to rebase: " branch_selected; \
	echo "git rebase $${branch_selected}"; \
	git rebase $${branch_selected}

.PHONY: push
push:
	@clear
	@echo ""
	@git push --force-with-lease

.PHONY: merge
merge:
	@clear
	@echo ""
	@read -p "Enter the branch to merge: " branch_selected; \
	git merge --squash $${branch_selected}

.PHONY: tag
tag:
	@clear
	@echo ""
	@read -p "Enter the App name: " app_name; \
	git tag -a $${app_name}-v${BUILD_NAME} -m "$${app_name} Release v${BUILD_NAME}"
	git tag

.PHONY: clean_build
clean_build:
	@echo "deleting build folders..."
	@rm -rf build .dart_tool/flutter_build android/build ios/build
	@rm -rf ios/Flutter/DartDefine.xcconfig macos/Flutter/DartDefine.xcconfig
	@rm -rf /Users/cassio/Xcode/DerivedData/

.PHONY: clean
clean:
	@echo "flutter build clean..."
	@flutter clean > /dev/null
	@echo "delete pods..."
	@rm -rf pubspec.lock
	@rm -rf ios/Pods ios/Podfile.lock
	@rm -rf macos/Pods macos/Podfile.lock
	@$(MAKE) clean_build
	@$(MAKE) pubget

.PHONY: full_clean
full_clean:
	@echo "full clean flutter..."
	@rm -rf .dart_tool .idea build .flutter-plugins-dependencies
	dart pub cache clean --force
	@$(MAKE) clean_build
	@flutter precache --ios --macos
	@$(MAKE) pubget

.PHONY: pubget
pubget:
	@echo "flutter pub get..."
	@flutter pub get > /dev/null
	@echo "pod install iOS..."
	@cd ios && pod install --repo-update > /dev/null && cd ..
	@echo "pod install macOS..."
	@cd macos && pod install --repo-update > /dev/null && cd ..

choice_env:
	clear
	@echo "Please choose an env:"
	@i=1; for option in $(shell echo ${ENVS}); do \
		echo "$$i) $$option"; \
		i=$$((i + 1)); \
	done
	@echo ""
	@read -p "Enter the number of the env: " env_choice; \
	echo ""; \
	if [ -z "$$env_choice" ]; then \
		echo "Error: No env was selected."; \
		rm -rf .env_selected; \
	else \
		APP_NAME=$$(echo ${ENVS} | cut -d ' ' -f $$env_choice); \
		echo "$$APP_NAME" > .env_selected; \
	fi;
	clear

choice_platform:
	clear
	@echo "Please choose an platform to build:"
	@i=1; for option in $(shell echo ${PLATFORMS}); do \
		echo "$$i) $$option"; \
		i=$$((i + 1)); \
	done
	@echo ""
	@read -p "Enter the number of the platform: " platform_choice; \
	echo ""; \
	if [ -z "$$platform_choice" ]; then \
		echo "Error: No platform was selected."; \
		rm -rf .platform_selected; \
	else \
		APP_NAME=$$(echo ${PLATFORMS} | cut -d' ' -f$$platform_choice); \
		echo "$$APP_NAME" > .platform_selected; \
	fi;
	clear

.PHONY: build
build:
	"$(MAKE)" choice_platform; \
	if [ -f .platform_selected ]; then \
		PLATFORM=$$(cat .platform_selected); \
		rm -rf .platform_selected; \
		"$(MAKE)" choice_env; \
		if [[ $$PLATFORM == "android" ]]; then \
			"$(MAKE)" build_android; \
		fi; \
		if [[ $$PLATFORM == "ios" ]]; then \
			"$(MAKE)" build_ios; \
		fi; \
		if [[ $$PLATFORM == "macos" ]]; then \
			"$(MAKE)" build_macos; \
		fi; \
		if [[ $$PLATFORM == "web" ]]; then \
			"$(MAKE)" build_web; \
		fi; \
	fi; \

.PHONY: build_android
build_android:
	clear
	if [[ ! (-f .env_selected) ]]; then \
		$(MAKE) choice_env; \
	fi; \
	echo "Build Android"; \
	ENV=$$(cat .env_selected); \
	rm -rf .env_selected; \
	ARGS="--dart-define-from-file=$$ENV"; \
	BUILD_NUMBER=${GIT_COMMITS_COUNT}; \
	BUILD_FOLDER="v${BUILD_NAME}+$${BUILD_NUMBER}"; \
	ENV_APP_NAME=$$(grep '"app_name": ' $$ENV | sed 's/"app_name": //'); \
	ENV_APP_NAME=$${ENV_APP_NAME//[\", ]/}; \
	APPLE_DEVELOPMENT_TEAM=$$(grep '"apple_development_team": ' $$ENV | sed 's/"apple_development_team": //'); \
	APPLE_DEVELOPMENT_TEAM=$${APPLE_DEVELOPMENT_TEAM//[\", ]/}; \
	BASE_HREF=$$(grep '"baseHREF": ' $$ENV | sed 's/"baseHREF": //'); \
	BASE_HREF=$${BASE_HREF//[\", ]/}; \
	echo "App: $${ENV_APP_NAME}"; \
	echo "Build Name: ${BUILD_NAME}"; \
	echo "Build Number: $${BUILD_NUMBER}"; \
	echo "Base HREF: $${BASE_HREF}"; \
	echo "Apple Team: $${APPLE_DEVELOPMENT_TEAM}"; \
	if [ ! -d "releases" ]; then \
		mkdir "releases"; \
	fi; \
	if [ ! -d "releases/$$BUILD_FOLDER" ]; then \
		mkdir "releases/$$BUILD_FOLDER"; \
	fi; \
	echo ""; \
	"$(MAKE)" clean; \
	flutter build apk --release $$ARGS --no-tree-shake-icons --build-name=${BUILD_NAME} --build-number=$$BUILD_NUMBER; \
	if [ -d "build/app/outputs/flutter-apk" ]; then \
		cp -r build/app/outputs/flutter-apk/*.apk releases/$$BUILD_FOLDER/$${ENV_APP_NAME}_v${BUILD_NAME}+$$BUILD_NUMBER.apk; \
	fi; \
	if [ -d "build/app/outputs/bundle/release" ]; then \
		cp -r build/app/outputs/bundle/release/*.aab releases/$$BUILD_FOLDER/$${ENV_APP_NAME}_v${BUILD_NAME}+$$BUILD_NUMBER.aab; \
	fi; \
	if [ -d "build/app/outputs/bundle/release" ]; then \
		echo "Generate Android Native Symbols"; \
		DEFAULT_PATH=$$(pwd); \
		cd build/app/intermediates/merged_native_libs/release/mergeReleaseNativeLibs/out/lib; \
		zip -r symbols.zip arm64-v8a armeabi-v7a x86 x86_64; \
		sleep 1; \
		cd "$${DEFAULT_PATH}"; \
		mv build/app/intermediates/merged_native_libs/release/mergeReleaseNativeLibs/out/lib/symbols.zip releases/$$BUILD_FOLDER/Android\ Native\ Bundle\ Symbols.zip; \
	fi; \
	open "releases/$$BUILD_FOLDER"; \

.PHONY: build_ios
build_ios:
	clear; \
	if [[ ! (-f .env_selected) ]]; then \
		$(MAKE) choice_env; \
	fi; \
	echo "Build iOS"; \
	ENV=$$(cat .env_selected); \
	rm -rf .env_selected; \
	ARGS="--dart-define-from-file=$$ENV"; \
	BUILD_NUMBER=${GIT_COMMITS_COUNT}; \
	BUILD_FOLDER="v${BUILD_NAME}+$${BUILD_NUMBER}"; \
	ENV_APP_NAME=$$(grep '"app_name": ' $$ENV | sed 's/"app_name": //'); \
	ENV_APP_NAME=$${ENV_APP_NAME//[\", ]/}; \
	APPLE_DEVELOPMENT_TEAM=$$(grep '"apple_development_team": ' $$ENV | sed 's/"apple_development_team": //'); \
	APPLE_DEVELOPMENT_TEAM=$${APPLE_DEVELOPMENT_TEAM//[\", ]/}; \
	BASE_HREF=$$(grep '"baseHREF": ' $$ENV | sed 's/"baseHREF": //'); \
	BASE_HREF=$${BASE_HREF//[\", ]/}; \
	echo "App: $${ENV_APP_NAME}"; \
	echo "Build Name: ${BUILD_NAME}"; \
	echo "Build Number: $${BUILD_NUMBER}"; \
	echo "Base HREF: $${BASE_HREF}"; \
	echo "Apple Team: $${APPLE_DEVELOPMENT_TEAM}"; \
	if [ ! -d "releases" ]; then \
		mkdir "releases"; \
	fi; \
	if [ ! -d "releases/$$BUILD_FOLDER" ]; then \
		mkdir "releases/$$BUILD_FOLDER"; \
	fi; \
	echo ""; \
	"$(MAKE)" clean; \
	if [[ $$APPLE_DEVELOPMENT_TEAM ]]; then \
		flutter build ipa --release $$ARGS --export-method ad-hoc --no-tree-shake-icons --build-name=${BUILD_NAME} --build-number=$$BUILD_NUMBER; \
	else \
		flutter build ipa --release $$ARGS --export-method ad-hoc --no-codesign --no-tree-shake-icons --build-name=${BUILD_NAME} --build-number=$$BUILD_NUMBER; \
	fi; \
	if [ -d "build/ios/archive" ]; then \
		cp -r build/ios/archive/*.xcarchive releases/$$BUILD_FOLDER/$${ENV_APP_NAME}_v${BUILD_NAME}+$$BUILD_NUMBER.xcarchive; \
	fi; \
	if [ -d "build/ios/ipa" ]; then \
		cp -r build/ios/ipa/*.ipa releases/$$BUILD_FOLDER/$${ENV_APP_NAME}_v${BUILD_NAME}+$$BUILD_NUMBER.ipa; \
	fi; \
	if [ -d "build/ios/archive" ]; then \
		echo "Generate iOS dSYMs"; \
		DEFAULT_PATH=$$(pwd); \
		cd build/ios/archive/*.xcarchive; \
		zip -r dSYMs.zip dSYMs; \
		sleep 1; \
		cd "$${DEFAULT_PATH}"; \
		mv build/ios/archive/*.xcarchive/dSYMs.zip releases/$$BUILD_FOLDER/dSYMs.zip; \
	fi; \
	open "releases/$$BUILD_FOLDER"; \

.PHONY: build_macos
build_macos:
	clear; \
	if [[ ! (-f .env_selected) ]]; then \
		$(MAKE) choice_env; \
	fi; \
	echo "Build MacOS"; \
	ENV=$$(cat .env_selected); \
	rm -rf .env_selected; \
	ARGS="--dart-define-from-file=$$ENV"; \
	BUILD_NUMBER=${GIT_COMMITS_COUNT}; \
	BUILD_FOLDER="v${BUILD_NAME}+$${BUILD_NUMBER}"; \
	ENV_APP_NAME=$$(grep '"app_name": ' $$ENV | sed 's/"app_name": //'); \
	ENV_APP_NAME=$${ENV_APP_NAME//[\", ]/}; \
	APPLE_DEVELOPMENT_TEAM=$$(grep '"apple_development_team": ' $$ENV | sed 's/"apple_development_team": //'); \
	APPLE_DEVELOPMENT_TEAM=$${APPLE_DEVELOPMENT_TEAM//[\", ]/}; \
	BASE_HREF=$$(grep '"baseHREF": ' $$ENV | sed 's/"baseHREF": //'); \
	BASE_HREF=$${BASE_HREF//[\", ]/}; \
	echo "App: $${ENV_APP_NAME}"; \
	echo "Build Name: ${BUILD_NAME}"; \
	echo "Build Number: $${BUILD_NUMBER}"; \
	echo "Base HREF: $${BASE_HREF}"; \
	echo "Apple Team: $${APPLE_DEVELOPMENT_TEAM}"; \
	if [ ! -d "releases" ]; then \
		mkdir "releases"; \
	fi; \
	if [ ! -d "releases/$$BUILD_FOLDER" ]; then \
		mkdir "releases/$$BUILD_FOLDER"; \
	fi; \
	echo ""; \
	"$(MAKE)" clean; \
	flutter build macos --release $$ARGS --no-tree-shake-icons --build-name=${BUILD_NAME} --build-number=$$BUILD_NUMBER; \
	if [ -d "build/macos/Build/Products/Release" ]; then \
		cp -r build/macos/Build/Products/Release/*.app releases/$$BUILD_FOLDER/$${ENV_APP_NAME}_v${BUILD_NAME}+$$BUILD_NUMBER.app; \
	fi; \
	open "releases/$$BUILD_FOLDER"; \

.PHONY: build_web
build_web:
	clear; \
	if [[ ! (-f .env_selected) ]]; then \
		$(MAKE) choice_env; \
	fi; \
	echo "Build Web"; \
	ENV=$$(cat .env_selected); \
	rm -rf .env_selected; \
	ARGS="--dart-define-from-file=$$ENV"; \
	BUILD_NUMBER=${GIT_COMMITS_COUNT}; \
	BUILD_FOLDER="v${BUILD_NAME}+$${BUILD_NUMBER}"; \
	ENV_APP_NAME=$$(grep '"app_name": ' $$ENV | sed 's/"app_name": //'); \
	ENV_APP_NAME=$${ENV_APP_NAME//[\", ]/}; \
	APPLE_DEVELOPMENT_TEAM=$$(grep '"apple_development_team": ' $$ENV | sed 's/"apple_development_team": //'); \
	APPLE_DEVELOPMENT_TEAM=$${APPLE_DEVELOPMENT_TEAM//[\", ]/}; \
	BASE_HREF=$$(grep '"baseHREF": ' $$ENV | sed 's/"baseHREF": //'); \
	BASE_HREF=$${BASE_HREF//[\", ]/}; \
	echo "App: $${ENV_APP_NAME}"; \
	echo "Build Name: ${BUILD_NAME}"; \
	echo "Build Number: $${BUILD_NUMBER}"; \
	echo "Base HREF: $${BASE_HREF}"; \
	echo "Apple Team: $${APPLE_DEVELOPMENT_TEAM}"; \
	if [ ! -d "releases" ]; then \
		mkdir "releases"; \
	fi; \
	if [ ! -d "releases/$$BUILD_FOLDER" ]; then \
		mkdir "releases/$$BUILD_FOLDER"; \
	fi; \
	echo ""; \
	"$(MAKE)" clean; \
	flutter build web --release $$ARGS --base-href $${BASE_HREF} --no-tree-shake-icons --build-name=${BUILD_NAME} --build-number=$$BUILD_NUMBER; \
	if [ -d "build/web" ]; then \
		cp -r build/web/ releases/$$BUILD_FOLDER/$${ENV_APP_NAME}_v${BUILD_NAME}+$$BUILD_NUMBER/; \
	fi; \
	open "releases/$$BUILD_FOLDER"; \
