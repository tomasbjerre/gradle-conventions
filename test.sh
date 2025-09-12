#!/bin/bash
set -e

scriptdir=$(pwd)

rm -rf ~/.m2/repository/se/bjurr/gradle
find . -name build | xargs rm -rf

./gradlew build publishToMavenLocal -Pversion=latest-SNAPSHOT

subprojects=(
"command-gr8|./gradlew build publishToMavenLocal -Pversion=latest-SNAPSHOT -s && jar tf build/libs/command-gr8-latest-SNAPSHOT.jar && java -jar build/libs/command-gr8-latest-SNAPSHOT.jar"
"command-shadow|./gradlew build publishToMavenLocal -Pversion=0.0.0 -s && jar tf build/libs/command-shadow-0.0.0.jar && npm install && node index.js"
"gradle-binaryplugin-plugin|./gradlew build publishToMavenLocal validatePlugins -Pversion=latest-SNAPSHOT -s"
"gradle-binaryplugin-plugin-usage|./gradlew exampleBinaryPluginTask"
"gradle-precompiled-script-plugin|./gradlew build publishToMavenLocal -Pversion=latest-SNAPSHOT -s"
"gradle-precompiled-script-plugin-usage|./gradlew build"
"jar|./gradlew build publishToMavenLocal -Pversion=latest-SNAPSHOT -s"
"jar-gr8|./gradlew build publishToMavenLocal -Pversion=latest-SNAPSHOT -s && jar tf build/libs/jar-gr8-latest-SNAPSHOT.jar"
"jar-shadow|./gradlew build publishToMavenLocal -Pversion=latest-SNAPSHOT -s && jar tf build/libs/jar-shadow-latest-SNAPSHOT.jar"
"multiproject|./gradlew build publishToMavenLocal -Pversion=latest-SNAPSHOT -s && jar tf project1-shadow/build/libs/project1-shadow-latest-SNAPSHOT.jar && jar tf project1/build/libs/project1-latest-SNAPSHOT.jar"
)

run_subproject() {
    local name="$1"
    local cmds="$2"
    local testitem="examples/$name"

    echo
    echo "|"
    echo "| Testing $testitem"
    echo "|"

    pushd "$testitem" >/dev/null

    cp -r "$scriptdir/gradle" .
    cp "$scriptdir/gradlew" .
    cp "$scriptdir/gradlew.bat" .

    while IFS= read -r c || [ -n "$c" ]; do
        c=$(echo "$c" | xargs)
        if [ -n "$c" ]; then
            echo "| Running: $c"
            bash -c "$c"
            echo
        fi
    done <<< "$cmds"

    popd >/dev/null
}

for entry in "${subprojects[@]}"; do
    IFS="|" read -r sub cmd <<< "$entry"
    run_subproject "$sub" "$cmd"
done

echo -e "File\tSize"
while IFS= read -r jar; do
    size=$(stat -c "%s" "$jar" 2>/dev/null || stat -f "%z" "$jar")
    hr_size=$(numfmt --to=iec-i --suffix=B "$size")
    echo -e "$jar\t$hr_size"
done < <(find . -type f -name "*.jar") | column -t -s $'\t'

echo "OK"
echo
