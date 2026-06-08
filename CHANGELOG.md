# Master v2.0.0 [08-06-2026]

- fix: release-version makefile function
- feat: add interactive branch selection to recreate-branch
- feat: allow release commits in commit-msg hook
- chore: remove unused flutter_contacts dependency
- fix: use dynamic build mode path instead of hardcoded release
- fix: improve push token null handling and switch reactivity
- chore: add build artifact files to gitignore
- feat: integrate app_purchase module with routes and translations
- refactor: improve makefile with POSIX compliance and DRY build config
- refactor: restructure webview lifecycle and navigation logic
- docs: add release homologation process guide
- refactor: migrate from RxBool to ValueNotifier across packages
- refactor: replace setState with ValueNotifier in widgets
- chore: break-change update dependencies and Gradle to 8.14
- fix: break-change adapt to flutter_local_notifications v20 API
- chore: add build-flag enableImpeller
- chore: update makefile targets and build configuration
- docs: reorganize and restructure project documentation
- chore: add pre-commit hook to enforce dart analyze and dart fix
- docs: update agent documentation references to docs/ directory
- refactor: rename ErrorCallbacksExtension and remove unused code
- refactor: centralize internet connection lifecycle management
- chore: add install-hooks and release-version targets
- chore: add commit-msg hook and git message command
- docs: add and update project documentation
- refactor: add stash only files ready to commit option
- refactor: update stash-pop to delete or keep stash on stack
- feat: add stash and stash-pop makefile functions
- feat: add new diagrams and git skills
- refactor: upgrade flutter 3.44.0 o packages and change analysis_options
- refactor: dart fix flutter 3.44.0
- refactor: remove growth_book libs
- refactor: remove icons_plus lib and use native flutter icons
- refactor: update makefile clean-build and rebase functions
- refactor: remove disable Impeller
- refactor: update dart analysis options
- upgrade to flutter 3.44.0
- refactor: update variable name
- fix: integration test selectedIndex closed error
- fix: unit tests, dependency injection
- refactor: add override on purchase use case
- refactor: add local database from DI
- refactor: remove UserModel parser
- refactor: migrate usecases from data to domain on UserAccount module
- refactor: migrate usecases from data to domain on Settings module
- refactor: migrate usecases from data to domain on Security module
- refactor: migrate usecases from data to domain on Notifications module
- refactor: migrate usecases from data to domain on Faq module
- refactor: migrate usecases from data to domain on AppPurchase module
- refactor: migrate usecases from data to domain on Admin module
- refactor: update usecases on domain module
- refactor: update domain services interfaces
- refactor: migrate Result from domain to core module
- refactor: delete usecases implementation from clean_code_data
- refactor: add environment entities on infra bindings
- refactor: webvisithistory
- refactor: import from correctly package
- refactor: add imports from design_system, clean_code_data and clean_code_domain
- remove usecases from data
- remove clean_code_* export from core
- remove default model on opencode commands
- fix: webview load_callbacks_mixin_test
- feat: init SDD integration speckit development
- refactor: update webview and add darkmode
- refactor: update webview headless
- refactor: remove asBroadcastStream and update onStreamListeners
- fix: home controller unit test
- refactor: webview module
- fix: internet subscription on HomeController
- fix: intro bugfix
- refactor: not show tracking log on integration test
- feat: app purchase module
- fix: update logs
- feat: add widget rebuild log
- fix: update intro controller test
- refactor: update crashlytics ensureInitialized
- refactor: add logs on change status
- fix: use getx bindings
- refactor: update home controller
- fix: intro total pageLength
- fix: update makefile
- refactor: update app navigator
- refactor: update app bindings
- refactor: update flutter libs
- refactor: add program on Flutter App launch.json
- refactor: update flutter AI agent
- test: add new unit tests
- fix: choice-env make file function
- refactor: update unit tests
- refactor: disable param useHistory on Talker Logger
- feat: add reset and testMode functions
- fix: replace bindings getx
- fix: makefile rebase function
- fix: makefile logs function

# Master v1.4.0 [09-05-2026]

- fix: find envs
- refactor: remove delay
- refactor: add --reapply-cherry-picks on rebase
- refactor: update translates
- refactor: add expire time on invalid session dialog
- fix: app theme icon size
- fix: other fixes
- feat: add and update unit tests
- fix: memory leak
- feat: add get it dependency
- feat: add new command
- fix: unit tests
- fix: open-worktree function
- feat: add open-worktree make file function
- refactor: disable logs when is integrationTest
- refactor: update files
- refactor: update admin package
- refactor: update user_account package
- feat: add design system example
- refactor: add secretOTP on security env
- feat: new packages unit tests
- feat: update opencode agents and commands
- refactor: update vscode extensions and launch
- refactor entity and models
- refactor: integration tests gherkin steps
- feat: add models unit tests
- project documentation
- init setup opencode
- update README project and design system buttons
- refactor onboarding intro module
- feat: add permissions env
- feat: add intro integration tests
- update integration test features
- fix: integration delete account tests
- fix: integration tests fixes
- feat: integration tests
- refactor: update vscode settings
- refactor: initialize crashlytics services
- refactor: update analytics
- refactor: signup page and widget test
- refactor: always enable crashlytics module
- feat: add and update new unit tests
- refactor: use cases and services
- feat: setup environments from app
- feat: add test-file function
- feat: add upload-firebase make file function
- update feature flag services
- refactor: update make file
- feat: enable user feedback offline-first with repository
- feat: add feedback module
- refactor: update make file, fix: webApp footer, add nameValidator
- refactor: inject deviceInfoEntity on bindings
- fix: other fixes
- refactor: update logs
- remove isolate from encrypt use cases
- refactor: update unit tests
- refactor: update make file functions
- feat: add git worktree functions
- dart fix
- fix: add default values for android params
- refactor: update error page and log catch exceptions
- feat: add flutter native splash

# Master v1.3.0 [31-03-2026]

- refactor: update crashlytics logs
- feat: add android launcher icon adaptive
- feat: add hive local database

# Master v1.2.4 [27-02-2026]

- refactor: update makefile tag function
- refactor: update clipboard use case
- fix: async encrypt function
- refactor: update version to v1.2.4

# Master v1.2.3 [26-02-2026]

- fix: catch when has no internet connection
- refactor: change function to uploadDeviceTraits
- refactor: update error message
- refactor: remove try catch from managers
- feat: add throwReport on base exceptions
- refactor: show BaseException message
- feat: add local aptabase storage manager
- feat: add divider, datePicker and timePicker themes
- fix: show web visit history
- refactor: update init update feature flags after login
- feat: update default translations
- fix: update catch and throw exceptions
- feat: create android notification channel
- feat: update perform metrics
- fix: not await aptabase analytics init
- fix: findRoute page
- fix: keyboard visibility widget
- feat: debug buttons
- feat: add cardPadding and debug static color
- feat: add clipboard use case
- feat: add autoClear params
- refactor: mv ThemeController to data bindings
- fix: crashlytics initialize error
- refactor: update pubspec
- refactor: update make file
- refactor: reduce delay to replace binding

# Master v1.2.2 [18-02-2026]

- fix: remover pubspec.lock, Podfile.lock

# Master v1.2.1 [18-02-2026]

- fix: remover logger lib
- refactor: updates
- fix: set UploadInstallationAppUseCase permanent binding
- fix: set ListUserInstallationsUseCase permanent binding

# Master v1.2.0 [16-02-2026]

- feat: add force update images
- fix: transalate bottom nav items title
- feat: add analysis option on packages
- feat: update push messaging package
- feat: update push notifications package
- fix: feature flag package

# Master v1.1.0 [03-01-2026]

- feat: update make file functions
- feat: update flutter libs
- fix: navigation pop gesture
- feat: add web app deeplink settings
- feat: add WebApp package
- fix: remove bottom sheet open and close animation
- feat: add in_app_review lib
- fix: remove workpoint locales

# Master v1.0.0 [30-12-2025]

- first release flutter demo app
