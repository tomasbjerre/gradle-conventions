# Conventional Release Gradle Plugin

[![Maven Central](https://maven-badges.herokuapp.com/maven-central/se.bjurr.gradle.conventional-release/se.bjurr.gradle.conventional-release.gradle.plugin/badge.svg)](https://search.maven.org/artifact/se.bjurr.gradle.conventional-release/se.bjurr.gradle.conventional-release.gradle.plugin)

Bundle of plugins and some Gradle DSL that can:

- Get version from [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/)
- Tag commit
- Update `CHANGELOG.md`
- Publish JAR:s to Maven Central
- Publish command line tools to Maven Central and NPM
- Publish Gradle plugins to Gradle Plugin Portal or Central

## Usage

Apply it with:

```groovy
plugins {
 id "se.bjurr.gradle.conventional-release" version "X"
}
```

Run it with:

```groovy
./gradlew release
```

## Publish JAR:s

The default setting, no need to change any properties.

Will publish the JAR to [Central](https://central.sonatype.com/).

## Publish command line tools

In `gradle.properties`:

```properties
repoType=COMMAND
```

Will publish the JAR to [Central](https://central.sonatype.com/).

Will package the JAR inside an NPM package and publish that to [NPM](https://plugins.gradle.org/).

## Publish Gradle plugins

In `gradle.properties`:

```properties
repoType=GRADLE
tags=tag1,tag2,tag3
implementationClass=a.b.c.ImplClass
```

Will publish the plugin to [Plugin Portal](https://plugins.gradle.org/).

## Properties

It can be tweaked in `gradle.properties` with some properties, the plugin reads them like this:

```groovy
// ---- default config ----
// repoType: JAR # JAR, GRADLE, COMMAND
repoType: project.getProperties().getOrDefault("repoType", "JAR"),
// relocate: org:org,com:com # Empty by default will.
relocate: project.getProperties().getOrDefault("relocate", ""),
updateChangelog: project.getProperties().getOrDefault("updateChangelog", "true") == "true",
setVersionConventional: project.getProperties().getOrDefault("updateChangelog", "true") == "true",
website: project.getProperties().getOrDefault("website", "https://github.com/tomasbjerre/" + project.name),
vcsUrl: project.getProperties().getOrDefault("vcsUrl", "https://github.com/tomasbjerre/" + project.name),
licenseName: project.getProperties().getOrDefault("licenseName", "The Apache Software License, Version 2.0"),
licenseUrl: project.getProperties().getOrDefault("licenseUrl", "http://www.apache.org/licenses/LICENSE-2.0.txt"),
developerId: project.getProperties().getOrDefault("developerId", "tomasbjerre"),
developerName: project.getProperties().getOrDefault("developerName", "Tomas Bjerre"),
developerEmail: project.getProperties().getOrDefault("developerEmail", "tomas.bjerre85@gmail.com"),
mavenRepositoryName: project.getProperties().getOrDefault("mavenRepositoryName", "nexus"),
mavenRepositoryUrl: project.getProperties().getOrDefault("mavenRepositoryUrl", "https://oss.sonatype.org/service/local/"),
nexusUsernameEnvOrProp: project.getProperties().getOrDefault("nexusUsernameEnvOrProp", "nexusUsername"),
nexusPasswordEnvOrProp: project.getProperties().getOrDefault("nexusPasswordEnvOrProp", "nexusPassword"),
signingKeyEnvOrProp: project.getProperties().getOrDefault("signingKeyEnvOrProp", "signing.keyId"),
signingPasswordEnvOrProp: project.getProperties().getOrDefault("signingPasswordEnvOrProp", "signing.password"),
// tags: a,b,c # Empty by default
tags: project.getProperties().getOrDefault("tags", ""),
implementationClass: project.getProperties().getOrDefault("implementationClass", ""),
stripGradlePluginSuffix: project.getProperties().getOrDefault("stripGradlePluginSuffix", "true") == "true",
// If it should be published to Plugin Portal or Central
publishGradlePluginToGradlePortal: project.getProperties().getOrDefault("publishGradlePluginToGradlePortal", "true") == "true",
// ---- default config ----
```

## Requirements

Gradle wrapper can be downloaded with:

```sh
cat > gradle/wrapper/gradle-wrapper.properties << EOL
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.10.2-bin.zip
networkTimeout=10000
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
EOL

./gradlew wrapper \
 --gradle-version=8.10.2 \
 --distribution-type=bin
```

In many cases you can just run the `gradlew wrapper` task. But there are cases where this does not work. On such case is if you are using Java version X and the current wrapper only support version Y, the current wrapper cannot run. Se example error below:

```sh
$ java -version

openjdk version "21.0.2" 2024-01-16
OpenJDK Runtime Environment (build 21.0.2+13-Ubuntu-122.04.1)
OpenJDK 64-Bit Server VM (build 21.0.2+13-Ubuntu-122.04.1, mixed mode, sharing)
```

```sh
$ ./gradlew wrapper --gradle-version=8.6 --distribution-type=bin

Downloading https://X/distributions/gradle-6.8.3-bin.zip

...

FAILURE: Build failed with an exception.

* Where:
Build file 'X/build.gradle'

* What went wrong:
Could not compile build file 'X/build.gradle'.
> startup failed:
  General error during semantic analysis: Unsupported class file major version 65

  java.lang.IllegalArgumentException: Unsupported class file major version 65
        at groovyjarjarasm.asm.ClassReader.<init>(ClassReader.java:196)
```
