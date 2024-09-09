#!/bin/bash

args="--dart-define-from-file=.env"

name=`grep 'name: ' pubspec.yaml | sed 's/name: //'`
projectName=($(echo "$name" | tr '+' '\n'))
version=`grep 'version: ' pubspec.yaml | sed 's/version: //'`
buildNameVersion=($(echo "$version" | tr '+' '\n'))

echo "\nLet's release ${name} (currently at ${version})\n"

echo "Changelog:"

echo "\nSelect increment (next version):"
echo "patch (1.0.1)"
echo "minor (1.1.0)"
echo "major (2.0.1)"
echo "current (1.0.1)"

buildNumberVersions=$(git rev-list HEAD --count)

echo "Build APK ${name} v${buildNameVersion}+${buildNumberVersions}"

flutter clean && rm -rf build

perl -i -pe 's/^(version:\s+\d+\.\d+\.\d+\+)(\d+)$/$1.('$buildNumberVersions')/e' pubspec.yaml

flutter pub get

if [ ! -d "releases" ]; then
  mkdir "releases"
fi

# build Android APK
# flutter build apk --release $args && cp -r build/app/outputs/flutter-apk/*.apk releases/${projectName}_v${buildNameVersion}+${buildNumberVersions}.apk

# build Web App
# flutter build web $args && cp -r build/web/ releases/${projectName}_v${buildNameVersion}+${buildNumberVersions}/

# build iOS IPA
# flutter build ipa --release $args --export-method ad-hoc && cp -r build/ios/ipa releases/${projectName}_v${buildNameVersion}+${buildNumberVersions}.ipa

# echo "Gerando TAG versão [v${buildNameVersion}+${buildNumberVersions}]"
# git add --all
# git commit -m "New version ${buildNameVersion}+${buildNumberVersions}"
# git push

# git checkout main
# git fetch origin devel:devel
# git pull origin devel:devel
# git push

# git branch release/${buildNameVersion}+${buildNumberVersions}
# git checkout release/${buildNameVersion}+${buildNumberVersions}
# git push --set-upstream origin release/${buildNameVersion}+${buildNumberVersions}
# git tag "v${buildNameVersion}+${buildNumberVersions}"
# git push --tags
# git tag -n
# git checkout devel