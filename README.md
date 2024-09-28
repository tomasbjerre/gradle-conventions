# Conventional Release Gradle Pluigin

Bundle of plugins and some Gradle DSL that can publish:

- JAR:s to Maven Central
- Command line tools to Maven Central and NPM
- Gradle plugins to Maven Central and Gradle Plugin Portal
- Get version from [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/)
- Update `CHANGELOG.md`

```groovy
plugins {
    id 'se.bjurr.gradle.conventional-release' version 'X'
}
```

<https://plugins.gradle.org/plugin/se.bjurr.gradle.conventional-release>

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

Will publish the plugin to [Plugin Portal](https://plugins.gradle.org/) and [Central](https://central.sonatype.com/).

## Properties

It can be tweaked in `gradle.properties` with some properties:

<!-- start default config -->
```groovy

def givenConfig = [
	// repoType: JAR # JAR, GRADLE, COMMAND
	repoType: gradleProps.getProperty("repoType", "JAR"),
	// relocate: org:org,com:com # Empty by default
	relocate: gradleProps.getProperty("relocate", ""),
	website: gradleProps.getProperty("website", "https://github.com/tomasbjerre/" + project.name),
	vcsUrl: gradleProps.getProperty("vcsUrl", "https://github.com/tomasbjerre/" + project.name),
	licenseName: gradleProps.getProperty("licenseName", "The Apache Software License, Version 2.0"),
	licenseUrl: gradleProps.getProperty("licenseUrl", "http://www.apache.org/licenses/LICENSE-2.0.txt"),
	developerId: gradleProps.getProperty("developerId", "tomasbjerre"),
	developerName: gradleProps.getProperty("developerName", "Tomas Bjerre"),
	developerEmail: gradleProps.getProperty("developerEmail", "tomas.bjerre85@gmail.com"),
	mavenRepositoryName: gradleProps.getProperty("mavenRepositoryName", "nexus"),
	mavenRepositoryUrl: gradleProps.getProperty("mavenRepositoryUrl", "https://oss.sonatype.org/service/local/staging/deploy/maven2/"),
	nexusCloseAndRelease: gradleProps.getProperty("relnexusCloseAndReleaseocate", "true"),
	sign: gradleProps.getProperty("sign", "true") == "true",
	// tags: a,b,c # Empty by default
	tags: gradleProps.getProperty("tags", ""),
	implementationClass: gradleProps.getProperty("implementationClass", ""),
	stripGradlePluginSuffix: gradleProps.getProperty("stripGradlePluginSuffix", "true") == "true",
]

```
<!-- end default config -->

## Requirements

Gradle wrapper can be downloaded with:

```sh
cat > gradle/wrapper/gradle-wrapper.properties << EOL
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.6-bin.zip
networkTimeout=10000
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
EOL

./gradlew wrapper \
 --gradle-version=8.6 \
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
