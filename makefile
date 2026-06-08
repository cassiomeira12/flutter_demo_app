PLATFORMS := android ios macos web
BUILD_MODES := debug profile release
GIT_COMMITS_COUNT := $(shell git rev-list --count HEAD ^master 2>/dev/null || git rev-list --count HEAD ^main 2>/dev/null || echo 0)
BUILD_NAME := $(shell grep 'version: ' pubspec.yaml | sed -E 's/version: ([0-9]+\.[0-9]+\.[0-9]+).*/\1/')
CURRENT_GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)

define build_config
  ENV=$$(cat .env_selected); \
  BUILD_MODE=$$(cat .build_mode_selected); \
  BUILD_NAME_SUFFIX=""; \
  BUILD_NUMBER=$(GIT_COMMITS_COUNT); \
  if [ "$$BUILD_MODE" = "debug" ]; then \
    BUILD_NAME_SUFFIX="-dev"; \
  fi; \
  if [ "$$BUILD_MODE" = "profile" ]; then \
    BUILD_NAME_SUFFIX="-rc.$(GIT_COMMITS_COUNT)"; \
  fi; \
  if [ "$$BUILD_MODE" != "release" ]; then \
    BUILD_NUMBER=1; \
  fi; \
  rm -rf .build_mode_selected; \
  ARGS="--$$BUILD_MODE --dart-define-from-file=$$ENV --no-tree-shake-icons"; \
  BUILD_FOLDER="v$(BUILD_NAME)"; \
  ENV_APP_NAME=$$(grep '"app_name": ' $$ENV | sed 's/"app_name": //'); \
  ENV_APP_NAME=$${ENV_APP_NAME//[\", ]/}; \
  APPLE_DEVELOPMENT_TEAM=$$(grep '"apple_development_team": ' $$ENV | sed 's/"apple_development_team": //'); \
  APPLE_DEVELOPMENT_TEAM=$${APPLE_DEVELOPMENT_TEAM//[\", ]/}; \
  BASE_HREF=$$(grep '"baseHREF": ' $$ENV | sed 's/"baseHREF": //'); \
  BASE_HREF=$${BASE_HREF//[\", ]/}; \
  BUILD_NAME_FULL="$(BUILD_NAME)$$BUILD_NAME_SUFFIX";
endef


.PHONY: install-hooks
install-hooks:
	@git config core.hooksPath .githooks
	@echo "Git hooks installed from .githooks/"

.PHONY: native-splash
native-splash:
	@echo ""; \
	for env in dev stg; do \
		echo "Build native splash $$env"; \
		dart run flutter_native_splash:create --path=flutter_native_splash_$$env.yaml > /dev/null; \
		rm -rf */Runner/Assets.xcassets/LaunchImage-$$env.imageset; \
		rm -rf android/app/src/main/res/drawable-*/splash_$$env.png; \
		cp -r ios/Runner/Assets.xcassets/LaunchImage.imageset ios/Runner/Assets.xcassets/LaunchImage-$$env.imageset; \
		for density in hdpi mdpi xhdpi xxhdpi xxxhdpi; do \
			cp android/app/src/main/res/drawable-$$density/splash.png android/app/src/main/res/drawable-$$density/splash_$$env.png; \
		done; \
	done
	@echo "Build native splash prod"
	@dart run flutter_native_splash:create --path=flutter_native_splash.yaml > /dev/null
	@git restore android/app/src/main/res/drawable*/launch_background.xml
	@rm -rf android/app/src/main/res/drawable*/background.png
	@git restore android/app/src/main/res/values-*/styles.xml
	@git restore ios/Runner/Info.plist ios/Runner/Base.lproj
	@git restore web/index.html

.PHONY: icons
icons:
	@echo ""; \
	for env in dev stg; do \
		echo "Build icons $$env"; \
		dart run flutter_launcher_icons -f flutter_launcher_icons_$$env.yaml > /dev/null; \
		env_upper=$$(echo $$env | tr '[:lower:]' '[:upper:]'); \
		rm -rf */Runner/Assets.xcassets/AppIcon$${env_upper}.appiconset; \
		rm -rf android/app/src/main/res/drawable-*/ic_launcher_foreground_$$env.png; \
		cp -r ios/Runner/Assets.xcassets/AppIcon.appiconset ios/Runner/Assets.xcassets/AppIcon$${env_upper}.appiconset; \
		cp -r macos/Runner/Assets.xcassets/AppIcon.appiconset macos/Runner/Assets.xcassets/AppIcon$${env_upper}.appiconset; \
		for density in hdpi mdpi xhdpi xxhdpi xxxhdpi; do \
			cp android/app/src/main/res/drawable-$$density/ic_launcher_foreground.png android/app/src/main/res/drawable-$$density/ic_launcher_foreground_$$env.png; \
		done; \
	done
	@echo "Build icons PROD"
	@dart run flutter_launcher_icons -f flutter_launcher_icons.yaml > /dev/null
	@git restore android/app/src/main/AndroidManifest.xml
	@git restore ios/Runner.xcodeproj/project.pbxproj
	@git restore android/app/src/main/res/mipmap-anydpi-v26/*

.PHONY: open-worktree
open-worktree:
	@echo ""; \
	envsBranch=$$(git worktree list | sed -E 's/.*\[(.*)\].*/\1/'); \
	envFoldersWorktree=$$(git worktree list | sed -E 's|^(.*/)?([^[:space:]]+)[[:space:]].*|\2|'); \
	i=1; for option in $${envFoldersWorktree}; do \
		branch=$$(echo $${envsBranch} | cut -d ' ' -f $$i); \
		echo "$$i) $$option [$$branch]"; \
		i=$$((i + 1)); \
	done; \
	echo ""; \
	read -p "Enter the worktree name to open: " worktree_name; \
	echo ""; \
	if [ -z "$$worktree_name" ]; then \
		echo "Error: No worktree was selected."; \
	else \
		CHOICE_SELECTED=$$(echo $${envFoldersWorktree} | cut -d ' ' -f $$worktree_name); \
		currentFolder=$$(basename "$$PWD"); \
		if [ "$$CHOICE_SELECTED" = "$$currentFolder" ]; then \
			echo "You are on $$CHOICE_SELECTED!!\n" && exit 0; \
		fi; \
		code ../$$CHOICE_SELECTED; \
	fi;

.PHONY: worktree
worktree:
	@echo ""; \
	envsBranch=$$(git branch -r | grep -v 'origin/developments/' | sed 's/origin\///'); \
	i=1; for option in $${envsBranch}; do \
		echo "$$i) $$option"; \
		i=$$((i + 1)); \
	done; \
	echo ""; \
	read -p "Enter the number of the branch: " branch_choice; \
	echo ""; \
	if [ -z "$$branch_choice" ]; then \
		echo "Error: No env was selected."; \
	else \
		CHOICE_SELECTED=$$(echo $${envsBranch} | cut -d ' ' -f $$branch_choice); \
		FOLDER=$$(echo $$CHOICE_SELECTED | sed 's/^[^/]*\///'); \
		git worktree add ../$$FOLDER $$CHOICE_SELECTED; \
		cp android/key.properties ../$$FOLDER/android/key.properties; \
		cp -r android/key_properties ../$$FOLDER/android/key_properties; \
		cp -r android/app/Firebase ../$$FOLDER/android/app/Firebase; \
		cp -r macos/Firebase ../$$FOLDER/macos/Firebase; \
		cp -r ios/Firebase ../$$FOLDER/ios/Firebase; \
		code ../$$FOLDER; \
	fi;

.PHONY: remove-worktree
remove-worktree:
	@echo ""; \
	envsBranch=$$(git worktree list | sed -E 's/.*\[(.*)\].*/\1/' | tail -n +2 | sed 's/.*\///'); \
	i=1; for option in $${envsBranch}; do \
		echo "$$i) $$option"; \
		i=$$((i + 1)); \
	done; \
	echo ""; \
	read -p "Enter the worktree name to delete: " worktree_name; \
	echo ""; \
	if [ -z "$$worktree_name" ]; then \
		echo "Error: No worktree was selected."; \
	else \
		CHOICE_SELECTED=$$(echo $${envsBranch} | cut -d ' ' -f $$worktree_name); \
		git worktree remove $$CHOICE_SELECTED; \
	fi;

.PHONY: stash
stash:
	@echo ""; \
	if ! git diff --quiet || ! git diff --cached --quiet; then \
		onlyCommitFilesParam="--include-untracked"; \
		if ! git diff --cached --quiet; then \
			read -p "Do you want to stash only the files ready to commit? [y/n]: " only_commit_files; \
			echo ""; \
			if [ $$only_commit_files = "y" ]; then \
				onlyCommitFilesParam="--staged"; \
			fi; \
		fi; \
		echo "Stash ${CURRENT_GIT_BRANCH} [$(shell date '+%d-%m-%Y')]"; \
		git stash push -m "auto-stash ${CURRENT_GIT_BRANCH} [$(shell date '+%d-%m-%Y')]" $$onlyCommitFilesParam; \
	fi;

.PHONY: stash-pop
stash-pop:
	@echo ""; \
	read -p "Delete the stash after run pop? [y/n]: " delete_stash; \
	echo ""; \
	if [ $$delete_stash = "y" ]; then \
		git stash pop; \
	else \
		git stash apply; \
	fi;

.PHONY: rebase-release
rebase-release:
	@echo ""; \
	envsBranch=$$(git branch -r | sed 's/origin\///'); \
	i=1; for option in $${envsBranch}; do \
		echo "$$i) $$option"; \
		i=$$((i + 1)); \
	done; \
	echo ""; \
	read -p "Enter the branch to rebase release: " branch_selected; \
	echo ""; \
	if [ -z "$$branch_selected" ]; then \
		echo "Error: No branch was selected."; \
	else \
		CHOICE_SELECTED=$$(echo $${envsBranch} | cut -d ' ' -f $$branch_selected); \
		git rebase origin/$${CHOICE_SELECTED} --strategy-option=theirs --reapply-cherry-picks; \
	fi;

.PHONY: rebase
rebase:
	@echo ""; \
	envsBranch=$$(git branch -r | sed 's/origin\///'); \
	i=1; for option in $${envsBranch}; do \
		echo "$$i) $$option"; \
		i=$$((i + 1)); \
	done; \
	echo ""; \
	read -p "Enter the branch to rebase: " branch_selected; \
	echo ""; \
	if [ -z "$$branch_selected" ]; then \
		echo "Error: No branch was selected."; \
	else \
		CHOICE_SELECTED=$$(echo $${envsBranch} | cut -d ' ' -f $$branch_selected); \
		git rebase origin/$${CHOICE_SELECTED} --reapply-cherry-picks; \
	fi;

.PHONY: push
push:
	@echo ""
	@git push --force-with-lease

.PHONY: logs
logs:
	@echo ""; \
	projectName=$$(echo "${CURRENT_GIT_BRANCH}" | sed -E 's#^(developments|releases)/##'); \
	projectTitle=$$(echo "# $$projectName v$(BUILD_NAME) [$(shell date '+%d-%m-%Y')]"); \
	commitsLogs=$$(git log -n $(GIT_COMMITS_COUNT) --pretty=format:"- %s" --grep="^\[$${projectName}\]"); \
	echo "----------------------------------------------"; \
	echo "\n$${projectTitle}\n\n$${commitsLogs}\n"; \
	echo "----------------------------------------------"; \
	echo ""; \
	echo "Git message | [$$projectName] refactor: update changelog"; \
	echo "";

.PHONY: delete-branch
delete-branch:
	@echo ""; \
	envsBranch=$$(git branch -r | sed 's/origin\///'); \
	i=1; for option in $${envsBranch}; do \
		echo "$$i) $$option"; \
		i=$$((i + 1)); \
	done; \
	echo ""; \
	read -p "Enter the branch to delete: " branch_selected; \
	echo ""; \
	if [ -z "$$branch_selected" ]; then \
		echo "Error: No branch was selected."; \
	else \
		CHOICE_SELECTED=$$(echo $${envsBranch} | cut -d ' ' -f $$branch_selected); \
		read -p "Delete local branch? [y/n]: " delete_local; \
		echo ""; \
		if [ "$$delete_local" = "y" ]; then \
			git branch --delete --force $${CHOICE_SELECTED}; \
			echo ""; \
		fi; \
		read -p "Delete remote branch? [y/n]: " delete_remote; \
		echo ""; \
		if [ "$$delete_remote" = "y" ]; then \
			git push origin --delete $${CHOICE_SELECTED}; \
			echo ""; \
		fi; \
	fi;

.PHONY: merge
merge:
	@echo ""; \
	envsBranch=$$(git branch -r | sed 's/origin\///'); \
	i=1; for option in $${envsBranch}; do \
		echo "$$i) $$option"; \
		i=$$((i + 1)); \
	done; \
	echo ""; \
	read -p "Enter the branch to merge into: " branch_selected; \
	echo ""; \
	if [ -z "$$branch_selected" ]; then \
		echo "Error: No branch was selected."; \
	else \
		CHOICE_SELECTED=$$(echo $${envsBranch} | cut -d ' ' -f $$branch_selected); \
		echo "Git Merge [$${CHOICE_SELECTED}] -> [${CURRENT_GIT_BRANCH}]"; \
		echo ""; \
		read -p "Enter the project name: " project_name; \
		echo ""; \
		if [ -z "$$project_name" ]; then \
			echo "Error: Project name cannot be empty."; \
			exit 1; \
		fi; \
		echo "Project Name [$${project_name}]"; \
		echo ""; \
		buildMode="release"; \
		if [ "${CURRENT_GIT_BRANCH}" = "master" ] || [ "${CURRENT_GIT_BRANCH}" = "main" ]; then \
			buildMode="${CURRENT_GIT_BRANCH}"; \
			project_name="flutter demo app"; \
		fi; \
		echo ""; \
		git merge --squash $${CHOICE_SELECTED} --strategy-option theirs; \
		echo ""; \
		echo "\n-------------------"; \
		currentVersion=$$(grep 'version: ' pubspec.yaml); \
		currentBuildName=$$(echo "$${currentVersion}" | sed -E 's/version: ([0-9]+\.[0-9]+\.[0-9]+).*/\1/'); \
		echo "Git merge message | $${buildMode}: $${project_name} v$${currentBuildName}"; \
		echo "-------------------\n"; \
	fi;

.PHONY: recreate-branch
recreate-branch:
	@echo ""; \
	read -p "Enter the branch to recreate: " branch_selected; \
	echo ""; \
	if [ -z "$$branch_selected" ]; then \
		echo "Error: No branch was selected."; \
		exit 1; \
	fi; \
	currentBranch=$$(git rev-parse --abbrev-ref HEAD); \
	echo "Deleting branch $$branch_selected"; \
	git push origin --delete $$branch_selected || true; \
	git branch $$branch_selected -D || true; \
	echo ""; \
	echo "Recreate branch $$branch_selected"; \
	git checkout $(CURRENT_GIT_BRANCH) 2>/dev/null || git checkout $$currentBranch; \
	git branch $$branch_selected; \
	git checkout $$branch_selected; \
	git push --set-upstream origin $$branch_selected; \
	git checkout $$currentBranch;

.PHONY: tag
tag:
	@projectName=$$(echo "${CURRENT_GIT_BRANCH}" | sed -E 's#^(developments|releases)/##'); \
	echo "\nCreate tag [$${projectName}-v$(BUILD_NAME)] - $${projectName} release v$(BUILD_NAME) \n"; \
	read -p "Do you want create the tag? [y/n]: " create_tag; \
	echo ""; \
	if [ "$$create_tag" = "y" ]; then \
		git tag -a $${projectName}-v$(BUILD_NAME) -m "$${projectName} release v$(BUILD_NAME)"; \
		git push --tags; \
	fi;

.PHONY: clean-build
clean-build:
	@echo "\nclean build folders..."
	@rm -rf ../*/build
	@rm -rf build .dart_tool/flutter_build android/build ios/build
	@rm -rf packages/*/build
	@rm -rf ios/Flutter/DartDefine.xcconfig macos/Flutter/DartDefine.xcconfig
	@rm -rf $(HOME)/Xcode/DerivedData/*/

.PHONY: clean
clean:
	@echo ""
	@echo "flutter clean..."
	@flutter clean
	@rm -rf pubspec.lock
	@flutter pub get
	@echo "clean android gradle..."
	@cd android && ./gradlew clean && cd ..
	@echo "clean iOS pods..."
	@rm -rf ios/Pods ios/Podfile.lock
	@echo "clean macOS pods..."
	@rm -rf macos/Pods macos/Podfile.lock
	@$(MAKE) clean-build
	@$(MAKE) pubget

.PHONY: full-clean
full-clean:
	@echo ""
	@echo "full clean flutter..."
	@dart pub cache clean --force
	@$(MAKE) clean-build
	@flutter precache --web --ios --macos
	@$(MAKE) full-pubget

.PHONY: full-pubget
full-pubget:
	@echo ""
	@echo "flutter pub get..."
	@flutter pub get > /dev/null
	@echo "update android gradle dependencies..."
	@cd android && ./gradlew --refresh-dependencies && cd ..
	@echo "pod install iOS..."
	@cd ios && pod install --repo-update && cd ..
	@echo "pod install macOS..."
	@cd macos && pod install --repo-update && cd ..

.PHONY: pubget
pubget:
	@echo ""
	@echo "flutter pub get..."
	@flutter pub get > /dev/null
	@echo "update android gradle dependencies..."
	@cd android && ./gradlew > /dev/null && cd ..
	@echo "pod install iOS..."
	@cd ios && pod install > /dev/null && cd ..
	@echo "pod install macOS..."
	@cd macos && pod install > /dev/null && cd ..

.PHONY: choice-env
choice-env:
	@echo ""
	@echo "Please choose an env:"; \
	projectName=$$(echo "${CURRENT_GIT_BRANCH}" | sed -E 's#^(developments|releases)/##'); \
	if [ "$$projectName" = "master" ] || [ "$$projectName" = "main" ]; then \
		projectName="*"; \
	fi; \
	envsBranchFilter="../envs/env.$${projectName}."; \
	envsBranch=$$(ls $${envsBranchFilter}* 2>/dev/null); \
	if [ -z "$$envsBranch" ]; then \
		echo "Error: No env files found for filter '$${envsBranchFilter}*'"; \
		exit 1; \
	fi; \
	i=1; for option in $${envsBranch}; do \
		echo "$$i) $$option"; \
		i=$$((i + 1)); \
	done; \
	echo ""; \
	read -p "Enter the number of the env: " env_choice; \
	echo ""; \
	if [ -z "$$env_choice" ]; then \
		echo "Error: No env was selected."; \
		rm -rf .env_selected; \
	else \
		CHOICE_SELECTED=$$(echo $${envsBranch} | cut -d ' ' -f $$env_choice); \
		echo "$$CHOICE_SELECTED" > .env_selected; \
	fi;

.PHONY: choice-build-mode
choice-build-mode:
	@echo ""
	@echo "Please choose an build mode:"
	@i=1; for option in ${BUILD_MODES}; do \
		echo "$$i) $$option"; \
		i=$$((i + 1)); \
	done
	@echo ""; \
	read -p "Enter the number of the build mode: " build_mode_choice; \
	echo ""; \
	if [ -z "$$build_mode_choice" ]; then \
		echo "Error: No build mode was selected."; \
		rm -rf .build_mode_selected; \
	else \
		CHOICE_SELECTED=$$(echo ${BUILD_MODES} | cut -d ' ' -f $$build_mode_choice); \
		echo "$$CHOICE_SELECTED" > .build_mode_selected; \
	fi;

.PHONY: choice-platform
choice-platform:
	@echo ""
	@echo "Please choose an platform to build:"
	@i=1; for option in ${PLATFORMS}; do \
		echo "$$i) $$option"; \
		i=$$((i + 1)); \
	done
	@echo ""; \
	read -p "Enter the number of the platform: " platform_choice; \
	echo ""; \
	if [ -z "$$platform_choice" ]; then \
		echo "Error: No platform was selected."; \
		rm -rf .platform_selected; \
	else \
		CHOICE_SELECTED=$$(echo ${PLATFORMS} | cut -d' ' -f$$platform_choice); \
		echo "$$CHOICE_SELECTED" > .platform_selected; \
	fi;

.PHONY: analyze
analyze:
	@echo ""; \
	dart analyze || exit 1

.PHONY: test
test:
	@echo ""; \
	echo "Run flutter test"; \
	if [ ! -f .env_selected ]; then \
		$(MAKE) choice-env; \
	fi; \
	ENV=$$(cat .env_selected); \
	trap 'rm -rf .env_selected' EXIT; \
	time flutter test --dart-define-from-file=$$ENV --coverage --no-pub -r github test packages | sed "s|$(PWD)/||" || exit 1

.PHONY: test-file
test-file:
	@echo ""; \
	echo "Run flutter test in file"; \
	if [ ! -f .env_selected ]; then \
		$(MAKE) choice-env; \
	fi; \
	ENV=$$(cat .env_selected); \
	trap 'rm -rf .env_selected' EXIT; \
	if [ -f .test_file_path ]; then \
		FILE_PATH=$$(cat .test_file_path); \
		echo "Cache file path: [$$FILE_PATH]"; \
	fi; \
	read -p "Enter the path file or ENTER to use cache: " path_file; \
	if [ -z "$$path_file" ]; then \
		if [ -f .test_file_path ]; then \
			path_file=$$(cat .test_file_path); \
		else \
			echo "Error: No cache file found and no path provided."; \
			exit 1; \
		fi; \
	fi; \
	echo $$path_file > .test_file_path; \
	flutter test $$path_file --dart-define-from-file=$$ENV --no-pub -r github | sed "s|$(PWD)/||" || exit 1

.PHONY: integration-test
integration-test:
	@echo ""; \
	echo "Run flutter integration test"; \
	if [ ! -f .env_selected ]; then \
		$(MAKE) choice-env; \
	fi; \
	ENV=$$(cat .env_selected); \
	trap 'rm -rf .env_selected' EXIT; \
	flutter test integration_test/runner_test.dart --dart-define-from-file=$$ENV --no-pub -r github

.PHONY: build
build:
	@$(MAKE) choice-platform
	@if [ -f .platform_selected ]; then \
		PLATFORM=$$(cat .platform_selected); \
		rm -rf .platform_selected; \
		$(MAKE) choice-env; \
		if [ "$$PLATFORM" = "android" ]; then \
			$(MAKE) build-android; \
		fi; \
		if [ "$$PLATFORM" = "ios" ]; then \
			$(MAKE) build-ios; \
		fi; \
		if [ "$$PLATFORM" = "macos" ]; then \
			$(MAKE) build-macos; \
		fi; \
		if [ "$$PLATFORM" = "web" ]; then \
			$(MAKE) build-web; \
		fi; \
	fi;

.PHONY: build-android
build-android:
	@if [ ! -f .env_selected ]; then \
		$(MAKE) choice-env; \
	fi; \
	if [ ! -f .build_mode_selected ]; then \
		$(MAKE) choice-build-mode; \
	fi; \
	echo "Build Android"; \
	$(build_config) \
	echo "App: $${ENV_APP_NAME} [$$BUILD_MODE]"; \
	echo "Build Name: $${BUILD_NAME_FULL}"; \
	echo "Env: $$ENV"; \
	echo "Build Number: $${BUILD_NUMBER}"; \
	echo "Base HREF: $${BASE_HREF}"; \
	echo "Apple Team: $${APPLE_DEVELOPMENT_TEAM}"; \
	mkdir -p "releases/$$ENV_APP_NAME/$$BUILD_FOLDER/Android"; \
	$(MAKE) clean; \
	$(MAKE) analyze || exit 1; \
	$(MAKE) test || exit 1; \
	flutter build apk $$ARGS --build-name=$$BUILD_NAME_FULL --build-number=$$BUILD_NUMBER || exit 1; \
	if [ -d "build/app/outputs/flutter-apk" ]; then \
		cp -r build/app/outputs/flutter-apk/*.apk releases/$$ENV_APP_NAME/$$BUILD_FOLDER/Android/$${ENV_APP_NAME}_v$$BUILD_NAME_FULL+$$BUILD_NUMBER.apk; \
	fi; \
	if [ -d "build/app/outputs/bundle/$$BUILD_MODE" ]; then \
		cp -r build/app/outputs/bundle/$$BUILD_MODE/*.aab releases/$$ENV_APP_NAME/$$BUILD_FOLDER/Android/$${ENV_APP_NAME}_v$$BUILD_NAME_FULL+$$BUILD_NUMBER.aab; \
	fi; \
	if [ -d "build/app/outputs/bundle/$$BUILD_MODE" ]; then \
		echo "Generate Android Native Symbols"; \
		DEFAULT_PATH=$$(pwd); \
		cd build/app/intermediates/merged_native_libs/$$BUILD_MODE/merge$${BUILD_MODE}NativeLibs/out/lib; \
		zip -r symbols.zip arm64-v8a armeabi-v7a x86 x86_64; \
		sleep 1; \
		cd "$${DEFAULT_PATH}"; \
		mv build/app/intermediates/merged_native_libs/$$BUILD_MODE/merge$${BUILD_MODE}NativeLibs/out/lib/symbols.zip releases/$$ENV_APP_NAME/$$BUILD_FOLDER/Android/Android\ Native\ Bundle\ Symbols.zip; \
	fi; \
	echo ""; \
	read -p "Do you want to install the app? [y/n]: " installApp; \
	echo ""; \
	if [ "$$installApp" = "y" ]; then \
		echo "$$ENV_APP_NAME" > .project_selected; \
		echo "$$BUILD_FOLDER" > .version_selected; \
		echo "Android" > .platform_selected; \
		echo "$${ENV_APP_NAME}_v$$BUILD_NAME_FULL+$$BUILD_NUMBER.apk" > .app_selected; \
		$(MAKE) install-android; \
	else \
		open "releases/$$ENV_APP_NAME/$$BUILD_FOLDER"; \
	fi; \
	echo "$${ENV_APP_NAME}_v$$BUILD_NAME_FULL+$$BUILD_NUMBER.apk" > .build_chosen_app; \
	echo "releases/$$ENV_APP_NAME/$$BUILD_FOLDER/Android/$${ENV_APP_NAME}_v$$BUILD_NAME_FULL+$$BUILD_NUMBER.apk" > .build_app_path

.PHONY: build-ios
build-ios:
	@if [ ! -f .env_selected ]; then \
		$(MAKE) choice-env; \
	fi; \
	if [ ! -f .build_mode_selected ]; then \
		$(MAKE) choice-build-mode; \
	fi; \
	echo "Build iOS"; \
	$(build_config) \
	echo "App: $${ENV_APP_NAME} [$$BUILD_MODE]"; \
	echo "Build Name: $${BUILD_NAME_FULL}"; \
	echo "Env: $$ENV"; \
	echo "Build Number: $${BUILD_NUMBER}"; \
	echo "Base HREF: $${BASE_HREF}"; \
	echo "Apple Team: $${APPLE_DEVELOPMENT_TEAM}"; \
	mkdir -p "releases/$$ENV_APP_NAME/$$BUILD_FOLDER/iOS"; \
	$(MAKE) clean; \
	$(MAKE) analyze || exit 1; \
	$(MAKE) test || exit 1; \
	if [ -n "$$APPLE_DEVELOPMENT_TEAM" ]; then \
		flutter build ipa $$ARGS --export-method ad-hoc --build-name=$$BUILD_NAME_FULL --build-number=$$BUILD_NUMBER || exit 1; \
	else \
		flutter build ipa $$ARGS --export-method ad-hoc --no-codesign --build-name=$$BUILD_NAME_FULL --build-number=$$BUILD_NUMBER || exit 1; \
	fi; \
	if [ -d "build/ios/archive" ]; then \
		cp -r build/ios/archive/*.xcarchive releases/$$ENV_APP_NAME/$$BUILD_FOLDER/iOS/$${ENV_APP_NAME}_v$$BUILD_NAME_FULL+$$BUILD_NUMBER.xcarchive; \
	fi; \
	if [ -d "build/ios/ipa" ]; then \
		cp -r build/ios/ipa/*.ipa releases/$$ENV_APP_NAME/$$BUILD_FOLDER/iOS/$${ENV_APP_NAME}_v$$BUILD_NAME_FULL+$$BUILD_NUMBER.ipa; \
	fi; \
	echo ""; \
	read -p "Do you want to generate iOS dSYMs? [y/n]: " generateDSYMs; \
	echo ""; \
	if [ "$$generateDSYMs" = "y" ]; then \
		if [ -d "build/ios/archive" ]; then \
			echo "Generate iOS dSYMs"; \
			DEFAULT_PATH=$$(pwd); \
			cd build/ios/archive/*.xcarchive; \
			zip -r dSYMs.zip dSYMs; \
			sleep 1; \
			cd "$${DEFAULT_PATH}"; \
			mv build/ios/archive/*.xcarchive/dSYMs.zip releases/$$ENV_APP_NAME/$$BUILD_FOLDER/iOS/dSYMs.zip; \
		fi; \
	fi; \
	echo ""; \
	read -p "Do you want to install the app? [y/n]: " installApp; \
	echo ""; \
	if [ "$$installApp" = "y" ]; then \
		echo "$$ENV_APP_NAME" > .project_selected; \
		echo "$$BUILD_FOLDER" > .version_selected; \
		echo "iOS" > .platform_selected; \
		echo "$${ENV_APP_NAME}_v$$BUILD_NAME_FULL+$$BUILD_NUMBER.ipa" > .app_selected; \
		$(MAKE) install-ios; \
	else \
		open "releases/$$ENV_APP_NAME/$$BUILD_FOLDER"; \
	fi; \
	echo "$${ENV_APP_NAME}_v$$BUILD_NAME_FULL+$$BUILD_NUMBER.ipa" > .build_chosen_app; \
	echo "releases/$$ENV_APP_NAME/$$BUILD_FOLDER/iOS/$${ENV_APP_NAME}_v$$BUILD_NAME_FULL+$$BUILD_NUMBER.ipa" > .build_app_path

.PHONY: build-macos
build-macos:
	@if [ ! -f .env_selected ]; then \
		$(MAKE) choice-env; \
	fi; \
	if [ ! -f .build_mode_selected ]; then \
		$(MAKE) choice-build-mode; \
	fi; \
	echo "Build MacOS"; \
	$(build_config) \
	echo "App: $${ENV_APP_NAME} [$$BUILD_MODE]"; \
	echo "Build Name: $${BUILD_NAME_FULL}"; \
	echo "Env: $$ENV"; \
	echo "Build Number: $${BUILD_NUMBER}"; \
	echo "Base HREF: $${BASE_HREF}"; \
	echo "Apple Team: $${APPLE_DEVELOPMENT_TEAM}"; \
	mkdir -p "releases/$$ENV_APP_NAME/$$BUILD_FOLDER/macOS"; \
	$(MAKE) clean; \
	$(MAKE) analyze || exit 1; \
	$(MAKE) test || exit 1; \
	flutter build macos $$ARGS --build-name=$(BUILD_NAME) --build-number=$$BUILD_NUMBER || exit 1; \
	if [ -d "build/macos/Build/Products/$$BUILD_MODE" ]; then \
		cp -r build/macos/Build/Products/$$BUILD_MODE/*.app releases/$$ENV_APP_NAME/$$BUILD_FOLDER/macOS/$${ENV_APP_NAME}_v$(BUILD_NAME)+$$BUILD_NUMBER.app; \
	fi; \
	open "releases/$$ENV_APP_NAME/$$BUILD_FOLDER"

.PHONY: build-web
build-web:
	@if [ ! -f .env_selected ]; then \
		$(MAKE) choice-env; \
	fi; \
	if [ ! -f .build_mode_selected ]; then \
		$(MAKE) choice-build-mode; \
	fi; \
	echo "Build Web"; \
	$(build_config) \
	echo "App: $${ENV_APP_NAME} [$$BUILD_MODE]"; \
	echo "Build Name: $${BUILD_NAME_FULL}"; \
	echo "Env: $$ENV"; \
	echo "Build Number: $${BUILD_NUMBER}"; \
	echo "Base HREF: $${BASE_HREF}"; \
	echo "Apple Team: $${APPLE_DEVELOPMENT_TEAM}"; \
	mkdir -p "releases/$$ENV_APP_NAME/$$BUILD_FOLDER"; \
	$(MAKE) clean; \
	$(MAKE) analyze || exit 1; \
	$(MAKE) test || exit 1; \
	flutter build web $$ARGS --wasm --base-href $${BASE_HREF} --build-name=$(BUILD_NAME) --build-number=$$BUILD_NUMBER || exit 1; \
	if [ -d "build/web" ]; then \
		cp -r build/web releases/$$ENV_APP_NAME/$$BUILD_FOLDER/; \
		cd releases/$$ENV_APP_NAME/$$BUILD_FOLDER && zip -r web.zip web; \
	fi; \
	open "releases/$$ENV_APP_NAME/$$BUILD_FOLDER"

.PHONY: install
install:
	@echo ""
	@echo "Please choose an project:"; \
	projects=$$(ls releases); \
	i=1; for option in $${projects}; do \
		echo "$$i) $$option"; \
		i=$$((i + 1)); \
	done; \
	echo ""; \
	read -p "Enter the number of the project: " project_choice; \
	echo ""; \
	if [ -z "$$project_choice" ]; then \
		echo "Error: No project was selected."; \
		rm -rf .project_selected; \
	else \
		CHOICE_SELECTED=$$(echo $${projects} | cut -d ' ' -f $$project_choice); \
		echo "$$CHOICE_SELECTED" > .project_selected; \
		$(MAKE) install-version; \
	fi;

.PHONY: install-version
install-version:
	@if [ ! -f .project_selected ]; then \
		$(MAKE) install; \
	fi; \
	PROJECT=$$(cat .project_selected); \
	echo "Please choose an project version:"; \
	versions=$$(ls releases/$${PROJECT}); \
	i=1; for option in $${versions}; do \
		echo "$$i) $$option"; \
		i=$$((i + 1)); \
	done; \
	echo ""; \
	read -p "Enter the number of the project version: " version_choice; \
	echo ""; \
	if [ -z "$$version_choice" ]; then \
		echo "Error: No version was selected."; \
		rm -rf .project_selected; \
	else \
		CHOICE_SELECTED=$$(echo $${versions} | cut -d ' ' -f $$version_choice); \
		echo "$$CHOICE_SELECTED" > .version_selected; \
		$(MAKE) install-platform; \
	fi;

.PHONY: install-platform
install-platform:
	@if [ ! -f .project_selected ]; then \
		$(MAKE) install-version; \
	fi; \
	PROJECT=$$(cat .project_selected); \
	VERSION=$$(cat .version_selected); \
	echo "Please choose an platform:"; \
	platforms=$$(ls releases/$${PROJECT}/$${VERSION}); \
	i=1; for option in $${platforms}; do \
		echo "$$i) $$option"; \
		i=$$((i + 1)); \
	done; \
	echo ""; \
	read -p "Enter the number of platform: " platform_choice; \
	echo ""; \
	if [ -z "$$platform_choice" ]; then \
		echo "Error: No platform was selected."; \
		rm -rf .project_selected; \
		rm -rf .version_selected; \
	else \
		CHOICE_SELECTED=$$(echo $${platforms} | cut -d ' ' -f $$platform_choice); \
		echo "$$CHOICE_SELECTED" > .platform_selected; \
		$(MAKE) install-app; \
	fi;

.PHONY: install-app
install-app:
	@if [ ! -f .project_selected ]; then \
		$(MAKE) install-platform; \
	fi; \
	PROJECT=$$(cat .project_selected); \
	VERSION=$$(cat .version_selected); \
	PLATFORM=$$(cat .platform_selected); \
	echo "Please choose an App to install:"; \
	apps=$$(ls releases/$${PROJECT}/$${VERSION}/$${PLATFORM}); \
	i=1; for option in $${apps}; do \
		echo "$$i) $$option"; \
		i=$$((i + 1)); \
	done; \
	echo ""; \
	read -p "Enter the number of App: " app_choice; \
	echo ""; \
	if [ -z "$$app_choice" ]; then \
		echo "Error: No App was selected."; \
		rm -rf .project_selected; \
		rm -rf .version_selected; \
		rm -rf .platform_selected; \
	else \
		CHOICE_SELECTED=$$(echo $${apps} | cut -d ' ' -f $$app_choice); \
		echo "$$CHOICE_SELECTED" > .app_selected; \
		if [ "$$PLATFORM" = "iOS" ]; then \
			$(MAKE) install-ios; \
		fi; \
		if [ "$$PLATFORM" = "Android" ]; then \
			$(MAKE) install-android; \
		fi; \
	fi;

.PHONY: install-android
install-android:
	@if [ ! -f .project_selected ]; then \
		$(MAKE) install-platform; \
	fi; \
	PROJECT=$$(cat .project_selected); \
	VERSION=$$(cat .version_selected); \
	PLATFORM=$$(cat .platform_selected); \
	APP=$$(cat .app_selected); \
	echo "Please choose an Android device to install:"; \
	androidDevices=$$(adb devices | grep -v "List" | grep -o "^[^[:space:]]*"); \
	i=1; for option in $${androidDevices}; do \
		device=$$(adb -s "$$option" shell getprop ro.product.model 2>/dev/null | tr -d '\r'); \
		if [ -z "$$device" ]; then \
			device="$$option"; \
		fi; \
		echo "$$i) $$device"; \
		i=$$((i + 1)); \
	done; \
	echo ""; \
	read -p "Enter the number of Android device: " android_device_choice; \
	echo ""; \
	if [ -z "$$android_device_choice" ]; then \
		echo "Error: No Android device was selected."; \
	else \
		CHOICE_SELECTED=$$(echo $${androidDevices} | cut -d ' ' -f $$android_device_choice); \
		adb -s $${CHOICE_SELECTED} install -r releases/$${PROJECT}/$${VERSION}/$${PLATFORM}/$${APP}; \
		echo ""; \
		echo "App installed ✅"; \
		echo "\u2022 file: $${APP}"; \
		echo "\u2022 device: $$(adb -s $$CHOICE_SELECTED shell getprop ro.product.model 2>/dev/null | tr -d '\r')"; \
		echo ""; \
	fi; \
	rm -rf .project_selected .version_selected .platform_selected .app_selected

.PHONY: install-ios
install-ios:
	@if [ ! -f .project_selected ]; then \
		$(MAKE) install-platform; \
	fi; \
	PROJECT=$$(cat .project_selected); \
	VERSION=$$(cat .version_selected); \
	PLATFORM=$$(cat .platform_selected); \
	APP=$$(cat .app_selected); \
	echo "Please choose an iOS device to install:"; \
	iOSDevices=$$(xcrun devicectl list devices 2>/dev/null | grep -E '\| [A-F0-9-]{25,}' | awk -F'|' '{gsub(/ /,"",$$2); print $$2}' | paste -sd ' ' -); \
	if [ -z "$$iOSDevices" ]; then \
		iOSDevices="00008020-00061D693A08003A 00008140-000849993E81801C"; \
	fi; \
	i=1; for option in $${iOSDevices}; do \
		if [ "$$option" = "00008020-00061D693A08003A" ]; then \
			device="iPhoneXS - $${option}"; \
		elif [ "$$option" = "00008140-000849993E81801C" ]; then \
			device="iPhone16e - $${option}"; \
		else \
			device="$$option"; \
		fi; \
		echo "$$i) $$device"; \
		i=$$((i + 1)); \
	done; \
	echo ""; \
	read -p "Enter the number of iOS device: " ios_device_choice; \
	echo ""; \
	if [ -z "$$ios_device_choice" ]; then \
		echo "Error: No iOS device was selected."; \
	else \
		CHOICE_SELECTED=$$(echo $${iOSDevices} | cut -d ' ' -f $$ios_device_choice); \
		xcrun devicectl device install app --device $${CHOICE_SELECTED} releases/$${PROJECT}/$${VERSION}/$${PLATFORM}/$${APP}; \
		echo ""; \
	fi; \
	rm -rf .project_selected .version_selected .platform_selected .app_selected

.PHONY: upload-firebase
upload-firebase:
	@echo "Uploading App to Firebase Distribution"; \
	if [ ! -f .build_chosen_app ] || [ ! -f .build_app_path ]; then \
		echo "Error: Build artifacts not found."; \
		echo "Run a build target first (e.g. build-android, build-ios) to generate:"; \
		echo "  - .build_chosen_app (app name)"; \
		echo "  - .build_app_path (full path to the app file)"; \
		exit 1; \
	fi; \
	commitsCount=$$(git rev-list --count HEAD ^develop 2>/dev/null || echo 0); \
	commitsLogs=$$(git log -n $$commitsCount --pretty=format:"- %s" 2>/dev/null); \
	developerName=$$(git config --global user.name); \
	echo "RELEASE CANDIDATE - [$$commitsCount] $$developerName \n\n$$commitsLogs" > release-notes.txt; \
	APP_NAME=$$(cat .build_chosen_app); \
	filePath=$$(cat .build_app_path); \
	echo "App: $$APP_NAME"; \
	echo "File: $$filePath"; \
	read -p "Enter the Firebase platform (android/ios): " platform; \
	if [ -z "$$platform" ]; then \
		echo "Error: Platform is required."; \
		rm -rf release-notes.txt; \
		exit 1; \
	fi; \
	firebaseAppId=$$(firebase apps:list --project app-base-conteudo $$platform 2>/dev/null | grep -i "$$APP_NAME" | awk -F '│' '{print $$3}' | tr -d '[:space:]'); \
	appID=$$(echo $$firebaseAppId | sed 's/\x1b\[[0-9;]*m//g'); \
	if [ -z "$$appID" ]; then \
		echo "Error: Could not find Firebase app ID for '$$APP_NAME' on platform '$$platform'"; \
		rm -rf release-notes.txt; \
		exit 1; \
	fi; \
	firebase appdistribution:distribute "$$filePath" \
		--app "$$appID" \
		--release-notes-file release-notes.txt \
		--groups "l-dev-pd-apps"; \
	rm -rf .build_app_path .build_chosen_app release-notes.txt


.PHONY: release-version
release-version:
	@echo ""; \
	echo "=============================================="; \
	echo "  Release Version Generator"; \
	echo "=============================================="; \
	current_version=$$(grep 'version: ' pubspec.yaml | sed -E 's/version: ([0-9]+\.[0-9]+\.[0-9]+).*/\1/'); \
	major=$$(echo "$$current_version" | cut -d. -f1); \
	minor=$$(echo "$$current_version" | cut -d. -f2); \
	patch=$$(echo "$$current_version" | cut -d. -f3); \
	echo "  Current version : $$current_version"; \
	\
	current_branch=$$(git rev-parse --abbrev-ref HEAD); \
	project_name=$$(echo "$$current_branch" | sed -E 's#^(developments|releases)/##'); \
	first_char=$$(echo "$$project_name" | cut -c1 | tr '[:lower:]' '[:upper:]'); \
	rest=$$(echo "$$project_name" | cut -c2-); \
	project_title="$$first_char$$rest"; \
	echo "  Branch          : $$current_branch"; \
	echo "  Project         : $$project_name"; \
	\
	commits_count=$$(git rev-list --count HEAD ^master 2>/dev/null || echo "0"); \
	if [ "$$commits_count" -eq 0 ]; then \
		echo ""; \
		echo "  ⚠ No new commits since master. Nothing to release."; \
		exit 1; \
	fi; \
	commits_logs=$$(git log -n "$$commits_count" --pretty=format:"- %s" --grep="^\\[$${project_name}\\]" 2>/dev/null || true); \
	if [ -z "$$commits_logs" ]; then \
		echo ""; \
		echo "  ⚠ No matching commits found for [$$project_name]."; \
		exit 1; \
	fi; \
	printf '%s\n' "$$commits_logs" > /tmp/_release_commits_log; \
	\
	echo "  $$(printf '%s\n' "$$commits_logs" | wc -l | tr -d ' ') matching commit(s) found"; \
	\
	has_breaking=false; \
	has_feat=false; \
	has_fix=false; \
	echo ""; \
	echo "  Commits:"; \
	while IFS= read -r commit; do \
		clean=$$(echo "$$commit" | sed 's/\[.*\] //'); \
		echo "    • $$clean"; \
		commit_lower=$$(echo "$$commit" | tr '[:upper:]' '[:lower:]'); \
		if echo "$$commit_lower" | grep -qE "!\s*:|breaking change|break-change"; then \
			has_breaking=true; \
		fi; \
		if echo "$$commit" | grep -qE "^\-\s*\[.*\]\s*feat\b"; then \
			has_feat=true; \
		fi; \
		if echo "$$commit" | grep -qE "^\-\s*\[.*\]\s*fix\b"; then \
			has_fix=true; \
		fi; \
	done < /tmp/_release_commits_log; \
	\
	echo ""; \
	if [ "$$has_breaking" = true ]; then \
		major=$$((major + 1)); \
		minor=0; \
		patch=0; \
		echo "  Type: BREAKING CHANGE → major bump"; \
	elif [ "$$has_feat" = true ]; then \
		minor=$$((minor + 1)); \
		patch=0; \
		echo "  Type: NEW FEATURE(S) → minor bump"; \
	elif [ "$$has_fix" = true ]; then \
		patch=$$((patch + 1)); \
		echo "  Type: FIX(ES) → patch bump"; \
	else \
		patch=$$((patch + 1)); \
		echo "  Type: OTHER CHANGES → patch bump"; \
	fi; \
	\
	new_version="$$major.$$minor.$$patch"; \
	new_version_dev="$${new_version}-dev"; \
	echo ""; \
	echo "  New version     : $$new_version_dev"; \
	\
	sed -i '' -E "s/^(version: ).*/\\1$$new_version_dev/" pubspec.yaml; \
	echo ""; \
	echo "  ✅ pubspec.yaml updated → version: $$new_version_dev"; \
	\
	today=$$(date '+%d-%m-%Y'); \
	changelog_title="# $$project_title v$$new_version [$$today]"; \
	echo "  ✅ Changelog title : $$changelog_title"; \
	\
	changelog_lines=""; \
	while IFS= read -r commit; do \
		cleaned=$$(echo "$$commit" | sed 's/\[.*\] //'); \
		if [ -z "$$changelog_lines" ]; then \
			changelog_lines="$$cleaned"; \
		else \
			changelog_lines="$$changelog_lines"$$'\n'"$$cleaned"; \
		fi; \
	done < /tmp/_release_commits_log; \
	rm -f /tmp/_release_commits_log; \
	\
	{ \
		echo "$$changelog_title"; \
		echo ""; \
		echo "$$changelog_lines"; \
		echo ""; \
		if [ -f CHANGELOG.md ]; then \
			cat CHANGELOG.md; \
		fi; \
	} > CHANGELOG.md.tmp && mv CHANGELOG.md.tmp CHANGELOG.md; \
	echo "  ✅ CHANGELOG.md updated"; \
	echo ""; \
	echo "=============================================="; \
	echo "  Release $$new_version_dev ready!"; \
	echo "=============================================="; \
	echo ""; \
	echo "  Git commit suggestion: \n"; \
	echo "  [$$project_name] chore: bump version to $$new_version_dev"; \
	echo "";
