PLATFORMS := android ios macos web
BUILD_MODES := debug profile release
ENVS := $(shell ls .env*)
GIT_COMMITS_COUNT := $(shell git rev-list --count HEAD ^master)
BUILD_NAME := $(shell echo "$(shell grep 'version: ' pubspec.yaml)" | sed -E 's/version: ([0-9]+\.[0-9]+\.[0-9]+)\-.*/\1/')
CURRENT_GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)

.PHONY: rebase
rebase:
	@echo ""
	@read -p "Enter the branch to rebase: " branch_selected; \
	echo "git rebase $${branch_selected}"; \
	git rebase $${branch_selected}

.PHONY: push
push:
	@echo ""
	@git push --force-with-lease

.PHONY: logs
logs:
	@echo ""
	@read -p "Enter the project name: " project_name; \
	echo ""; \
	echo "----------------------------------------------"; \
	echo ""; \
	echo "# $${project_name} v${BUILD_NAME} [$(shell date '+%d-%m-%Y')]"; \
	echo ""; \
	git log -n ${GIT_COMMITS_COUNT} --pretty=format:"- %s"; \
	echo ""; \
	echo "----------------------------------------------"; \
	echo ""; \
	echo "Git message | [${CURRENT_GIT_BRANCH}] refactor: update changelog"; \
	echo ""; \

.PHONY: delete-branch
delete-branch:
	@echo ""
	@read -p "Enter the branch to delete: " branch_selected; \
	echo ""; \
	read -p "Delete local branch? [y/n]: " delete_local; \
	echo ""; \
	if [[ $$delete_local == "y" ]]; then \
		git branch --delete --force $${branch_selected}; \
	fi; \
	echo ""; \
	read -p "Delete remote branch? [y/n]: " delete_remote; \
	echo ""; \
	if [[ $$delete_remote == "y" ]]; then \
		git push origin --delete $${branch_selected}; \
	fi; \
	echo ""; \

.PHONY: merge
merge:
	@echo ""
	@read -p "Enter the branch to merge: " branch_selected; \
	echo ""; \
	echo "Git Merge [$${branch_selected}] -> [${CURRENT_GIT_BRANCH}]"; \
	echo ""; \
	read -p "Enter the project name: " project_name; \
	echo ""; \
	echo "Project Name [$${project_name}]"; \
	echo ""; \
	buildMode="release"; \
	if [[ ${CURRENT_GIT_BRANCH} == "master" ]]; then \
		buildMode="${CURRENT_GIT_BRANCH}"; \
		project_name="flutter demo app"; \
	fi; \
	echo ""; \
	git merge --squash $${branch_selected} --strategy-option theirs; \
	echo ""; \
	echo "-------------------"; \
	currentVersion=$$(grep 'version: ' pubspec.yaml); \
	currentBuildName=$$(echo "$${currentVersion}" | sed -E 's/version: ([0-9]+\.[0-9]+\.[0-9]+)\-.*/\1/'); \
	echo "Git merge message | $${buildMode}: $${project_name} v$${currentBuildName}"; \
	echo "-------------------"; \

.PHONY: recreate-branch
recreate-branch:
	@echo ""
	@read -p "Enter the branch to recreate: " branch_selected; \
	echo ""; \
	echo "Deleting branch $${branch_selected}"; \
	git push origin --delete $${branch_selected}; \
	git branch $${branch_selected} -D; \
	echo ""; \
	echo "Recreate branch $${branch_selected}"; \
	git branch $${branch_selected}; \
	git checkout $${branch_selected}; \
	git push --set-upstream origin $${branch_selected}; \
	git checkout ${CURRENT_GIT_BRANCH}; \

.PHONY: tag
tag:
	@echo ""
	@read -p "Enter the App name: " app_name; \
	echo "\nCreate tag [$${app_name}-v${BUILD_NAME}] - $${app_name} Release v${BUILD_NAME} \n"
	git tag -a $${app_name}-v${BUILD_NAME} -m "$${app_name} Release v${BUILD_NAME}"
	git push --tags

.PHONY: clean-build
clean-build:
	@echo ""
	@echo "deleting build folders..."
	@rm -rf build .dart_tool/flutter_build android/build ios/build
	@rm -rf ios/Flutter/DartDefine.xcconfig macos/Flutter/DartDefine.xcconfig
	@rm -rf /Users/cassio/Xcode/DerivedData/

.PHONY: clean
clean:
	@echo ""
	@echo "flutter build clean..."
	@flutter clean > /dev/null
	@echo "delete pods..."
	@rm -rf pubspec.lock
	@rm -rf ios/Pods ios/Podfile.lock
	@rm -rf macos/Pods macos/Podfile.lock
	@$(MAKE) clean-build
	@$(MAKE) pubget

.PHONY: full-clean
full-clean:
	@echo ""
	@echo "full clean flutter..."
	@rm -rf .dart_tool .idea build .flutter-plugins-dependencies
	dart pub cache clean --force
	@$(MAKE) clean-build
	@flutter precache --ios --macos
	@$(MAKE) pubget

.PHONY: pubget
pubget:
	@echo ""
	@echo "flutter pub get..."
	@flutter pub get > /dev/null
	@echo "pod install iOS..."
	@cd ios && pod install --repo-update > /dev/null && cd ..
	@echo "pod install macOS..."
	@cd macos && pod install --repo-update > /dev/null && cd ..

choice-env:
	@echo ""
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
		CHOICE_SELECTED=$$(echo ${ENVS} | cut -d ' ' -f $$env_choice); \
		echo "$$CHOICE_SELECTED" > .env_selected; \
	fi;

choice-build-mode:
	@echo ""
	@echo "Please choose an build mode:"
	@i=1; for option in $(shell echo ${BUILD_MODES}); do \
		echo "$$i) $$option"; \
		i=$$((i + 1)); \
	done
	@echo ""
	@read -p "Enter the number of the build mode: " build_mode_choice; \
	echo ""; \
	if [ -z "$$build_mode_choice" ]; then \
		echo "Error: No build mode was selected."; \
		rm -rf .build_mode_selected; \
	else \
		CHOICE_SELECTED=$$(echo ${BUILD_MODES} | cut -d ' ' -f $$build_mode_choice); \
		echo "$$CHOICE_SELECTED" > .build_mode_selected; \
	fi;

choice-platform:
	@echo ""
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
		CHOICE_SELECTED=$$(echo ${PLATFORMS} | cut -d' ' -f$$platform_choice); \
		echo "$$CHOICE_SELECTED" > .platform_selected; \
	fi;

.PHONY: build
build:
	@$(MAKE) choice-platform
	@if [ -f .platform_selected ]; then \
		PLATFORM=$$(cat .platform_selected); \
		rm -rf .platform_selected; \
		"$(MAKE)" choice-env; \
		if [[ $$PLATFORM == "android" ]]; then \
			"$(MAKE)" build-android; \
		fi; \
		if [[ $$PLATFORM == "ios" ]]; then \
			"$(MAKE)" build-ios; \
		fi; \
		if [[ $$PLATFORM == "macos" ]]; then \
			"$(MAKE)" build-macos; \
		fi; \
		if [[ $$PLATFORM == "web" ]]; then \
			"$(MAKE)" build-web; \
		fi; \
	fi; \

.PHONY: build-android
build-android:
	@if [[ ! (-f .env_selected) ]]; then \
		$(MAKE) choice-env; \
	fi; \
	if [[ ! (-f .build_mode_selected) ]]; then \
		$(MAKE) choice-build-mode; \
	fi; \
	echo "Build Android"; \
	ENV=$$(cat .env_selected); \
	BUILD_MODE=$$(cat .build_mode_selected); \
	BUILD_NAME_SUFFIX=""; \
	BUILD_NUMBER=${GIT_COMMITS_COUNT}; \
	if [[ $$BUILD_MODE == "debug" ]]; then \
		BUILD_NAME_SUFFIX="-dev"; \
	fi; \
	if [[ $$BUILD_MODE == "profile" ]]; then \
		BUILD_NAME_SUFFIX="-rc.${GIT_COMMITS_COUNT}"; \
	fi; \
	if [[ $$BUILD_MODE != "release" ]]; then \
		BUILD_NUMBER=1; \
	fi; \
	rm -rf .env_selected .build_mode_selected; \
	ARGS="--$$BUILD_MODE --dart-define-from-file=$$ENV --no-tree-shake-icons"; \
	BUILD_FOLDER="v${BUILD_NAME}"; \
	ENV_APP_NAME=$$(grep '"app_name": ' $$ENV | sed 's/"app_name": //'); \
	ENV_APP_NAME=$${ENV_APP_NAME//[\", ]/}; \
	APPLE_DEVELOPMENT_TEAM=$$(grep '"apple_development_team": ' $$ENV | sed 's/"apple_development_team": //'); \
	APPLE_DEVELOPMENT_TEAM=$${APPLE_DEVELOPMENT_TEAM//[\", ]/}; \
	BASE_HREF=$$(grep '"baseHREF": ' $$ENV | sed 's/"baseHREF": //'); \
	BASE_HREF=$${BASE_HREF//[\", ]/}; \
	BUILD_NAME_FULL="${BUILD_NAME}$$BUILD_NAME_SUFFIX"; \
	echo "App: $${ENV_APP_NAME} [$$BUILD_MODE]"; \
	echo "Build Name: $${BUILD_NAME_FULL}"; \
	echo "Build Number: $${BUILD_NUMBER}"; \
	echo "Base HREF: $${BASE_HREF}"; \
	echo "Apple Team: $${APPLE_DEVELOPMENT_TEAM}"; \
	mkdir -p "releases/$$ENV_APP_NAME/$$BUILD_FOLDER/Android"; \
	echo ""; \
	"$(MAKE)" clean; \
	flutter build apk $$ARGS --build-name=$$BUILD_NAME_FULL --build-number=$$BUILD_NUMBER; \
	if [ -d "build/app/outputs/flutter-apk" ]; then \
		cp -r build/app/outputs/flutter-apk/*.apk releases/$$ENV_APP_NAME/$$BUILD_FOLDER/Android/$${ENV_APP_NAME}_v$$BUILD_NAME_FULL+$$BUILD_NUMBER.apk; \
	fi; \
	if [ -d "build/app/outputs/bundle/release" ]; then \
		cp -r build/app/outputs/bundle/release/*.aab releases/$$ENV_APP_NAME/$$BUILD_FOLDER/Android/$${ENV_APP_NAME}_v$$BUILD_NAME_FULL+$$BUILD_NUMBER.aab; \
	fi; \
	if [ -d "build/app/outputs/bundle/release" ]; then \
		echo "Generate Android Native Symbols"; \
		DEFAULT_PATH=$$(pwd); \
		cd build/app/intermediates/merged_native_libs/release/mergeReleaseNativeLibs/out/lib; \
		zip -r symbols.zip arm64-v8a armeabi-v7a x86 x86_64; \
		sleep 1; \
		cd "$${DEFAULT_PATH}"; \
		mv build/app/intermediates/merged_native_libs/release/mergeReleaseNativeLibs/out/lib/symbols.zip releases/$$ENV_APP_NAME/$$BUILD_FOLDER/Android/Android\ Native\ Bundle\ Symbols.zip; \
	fi; \
	open "releases/$$ENV_APP_NAME/$$BUILD_FOLDER"; \

.PHONY: build-ios
build-ios:
	@if [[ ! (-f .env_selected) ]]; then \
		$(MAKE) choice-env; \
	fi; \
	if [[ ! (-f .build_mode_selected) ]]; then \
		$(MAKE) choice-build-mode; \
	fi; \
	echo "Build iOS"; \
	ENV=$$(cat .env_selected); \
	BUILD_MODE=$$(cat .build_mode_selected); \
	BUILD_NAME_SUFFIX=""; \
	BUILD_NUMBER=${GIT_COMMITS_COUNT}; \
	if [[ $$BUILD_MODE == "debug" ]]; then \
		BUILD_NAME_SUFFIX="-dev"; \
	fi; \
	if [[ $$BUILD_MODE == "profile" ]]; then \
		BUILD_NAME_SUFFIX="-rc.${GIT_COMMITS_COUNT}"; \
	fi; \
	if [[ $$BUILD_MODE != "release" ]]; then \
		BUILD_NUMBER=1; \
	fi; \
	rm -rf .env_selected .build_mode_selected; \
	ARGS="--$$BUILD_MODE --dart-define-from-file=$$ENV --no-tree-shake-icons"; \
	BUILD_FOLDER="v${BUILD_NAME}"; \
	ENV_APP_NAME=$$(grep '"app_name": ' $$ENV | sed 's/"app_name": //'); \
	ENV_APP_NAME=$${ENV_APP_NAME//[\", ]/}; \
	APPLE_DEVELOPMENT_TEAM=$$(grep '"apple_development_team": ' $$ENV | sed 's/"apple_development_team": //'); \
	APPLE_DEVELOPMENT_TEAM=$${APPLE_DEVELOPMENT_TEAM//[\", ]/}; \
	BASE_HREF=$$(grep '"baseHREF": ' $$ENV | sed 's/"baseHREF": //'); \
	BASE_HREF=$${BASE_HREF//[\", ]/}; \
	BUILD_NAME_FULL="${BUILD_NAME}$$BUILD_NAME_SUFFIX"; \
	echo "App: $${ENV_APP_NAME} [$$BUILD_MODE]"; \
	echo "Build Name: $${BUILD_NAME_FULL}"; \
	echo "Build Number: $${BUILD_NUMBER}"; \
	echo "Base HREF: $${BASE_HREF}"; \
	echo "Apple Team: $${APPLE_DEVELOPMENT_TEAM}"; \
	mkdir -p "releases/$$ENV_APP_NAME/$$BUILD_FOLDER/iOS"; \
	echo ""; \
	"$(MAKE)" clean; \
	if [[ $$APPLE_DEVELOPMENT_TEAM ]]; then \
		flutter build ipa $$ARGS --export-method ad-hoc --build-name=$$BUILD_NAME_FULL --build-number=$$BUILD_NUMBER; \
	else \
		flutter build ipa $$ARGS --export-method ad-hoc --no-codesign --build-name=$$BUILD_NAME_FULL --build-number=$$BUILD_NUMBER; \
	fi; \
	if [ -d "build/ios/archive" ]; then \
		cp -r build/ios/archive/*.xcarchive releases/$$ENV_APP_NAME/$$BUILD_FOLDER/iOS/$${ENV_APP_NAME}_v$$BUILD_NAME_FULL+$$BUILD_NUMBER.xcarchive; \
	fi; \
	if [ -d "build/ios/ipa" ]; then \
		cp -r build/ios/ipa/*.ipa releases/$$ENV_APP_NAME/$$BUILD_FOLDER/iOS/$${ENV_APP_NAME}_v$$BUILD_NAME_FULL+$$BUILD_NUMBER.ipa; \
	fi; \
	if [ -d "build/ios/archive" ]; then \
		echo "Generate iOS dSYMs"; \
		DEFAULT_PATH=$$(pwd); \
		cd build/ios/archive/*.xcarchive; \
		zip -r dSYMs.zip dSYMs; \
		sleep 1; \
		cd "$${DEFAULT_PATH}"; \
		mv build/ios/archive/*.xcarchive/dSYMs.zip releases/$$ENV_APP_NAME/$$BUILD_FOLDER/iOS/dSYMs.zip; \
	fi; \
	open "releases/$$ENV_APP_NAME/$$BUILD_FOLDER"; \

.PHONY: build-macos
build-macos:
	@if [[ ! (-f .env_selected) ]]; then \
		$(MAKE) choice-env; \
	fi; \
	echo "Build MacOS"; \
	ENV=$$(cat .env_selected); \
	rm -rf .env_selected; \
	ARGS="--release --dart-define-from-file=$$ENV --no-tree-shake-icons"; \
	BUILD_NUMBER=${GIT_COMMITS_COUNT}; \
	BUILD_FOLDER="v${BUILD_NAME}"; \
	ENV_APP_NAME=$$(grep '"app_name": ' $$ENV | sed 's/"app_name": //'); \
	ENV_APP_NAME=$${ENV_APP_NAME//[\", ]/}; \
	APPLE_DEVELOPMENT_TEAM=$$(grep '"apple_development_team": ' $$ENV | sed 's/"apple_development_team": //'); \
	APPLE_DEVELOPMENT_TEAM=$${APPLE_DEVELOPMENT_TEAM//[\", ]/}; \
	BASE_HREF=$$(grep '"baseHREF": ' $$ENV | sed 's/"baseHREF": //'); \
	BASE_HREF=$${BASE_HREF//[\", ]/}; \
	echo "App: $${ENV_APP_NAME} [release]"; \
	echo "Build Name: ${BUILD_NAME}"; \
	echo "Build Number: $${BUILD_NUMBER}"; \
	echo "Base HREF: $${BASE_HREF}"; \
	echo "Apple Team: $${APPLE_DEVELOPMENT_TEAM}"; \
	mkdir -p "releases/$$ENV_APP_NAME/$$BUILD_FOLDER/macOS"; \
	echo ""; \
	"$(MAKE)" clean; \
	flutter build macos $$ARGS --build-name=${BUILD_NAME} --build-number=$$BUILD_NUMBER; \
	if [ -d "build/macos/Build/Products/Release" ]; then \
		cp -r build/macos/Build/Products/Release/*.app releases/$$ENV_APP_NAME/$$BUILD_FOLDER/macOS/$${ENV_APP_NAME}_v${BUILD_NAME}+$$BUILD_NUMBER.app; \
	fi; \
	open "releases/$$ENV_APP_NAME/$$BUILD_FOLDER"; \

.PHONY: build-web
build-web:
	@if [[ ! (-f .env_selected) ]]; then \
		$(MAKE) choice-env; \
	fi; \
	echo "Build Web"; \
	ENV=$$(cat .env_selected); \
	rm -rf .env_selected; \
	ARGS="--release --dart-define-from-file=$$ENV --no-tree-shake-icons"; \
	BUILD_NUMBER=${GIT_COMMITS_COUNT}; \
	BUILD_FOLDER="v${BUILD_NAME}"; \
	ENV_APP_NAME=$$(grep '"app_name": ' $$ENV | sed 's/"app_name": //'); \
	ENV_APP_NAME=$${ENV_APP_NAME//[\", ]/}; \
	APPLE_DEVELOPMENT_TEAM=$$(grep '"apple_development_team": ' $$ENV | sed 's/"apple_development_team": //'); \
	APPLE_DEVELOPMENT_TEAM=$${APPLE_DEVELOPMENT_TEAM//[\", ]/}; \
	BASE_HREF=$$(grep '"baseHREF": ' $$ENV | sed 's/"baseHREF": //'); \
	BASE_HREF=$${BASE_HREF//[\", ]/}; \
	echo "App: $${ENV_APP_NAME} [release]"; \
	echo "Build Name: ${BUILD_NAME}"; \
	echo "Build Number: $${BUILD_NUMBER}"; \
	echo "Base HREF: $${BASE_HREF}"; \
	echo "Apple Team: $${APPLE_DEVELOPMENT_TEAM}"; \
	mkdir -p "releases/$$ENV_APP_NAME/$$BUILD_FOLDER"; \
	echo ""; \
	"$(MAKE)" clean; \
	flutter build web $$ARGS --base-href $${BASE_HREF} --build-name=${BUILD_NAME} --build-number=$$BUILD_NUMBER; \
	if [ -d "build/web" ]; then \
		cp -r build/web/ releases/$$ENV_APP_NAME/$$BUILD_FOLDER/Web/; \
	fi; \
	open "releases/$$ENV_APP_NAME/$$BUILD_FOLDER"; \