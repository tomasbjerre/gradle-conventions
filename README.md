# Gradle Conventions

[![Maven Central](https://img.shields.io/maven-central/v/se.bjurr.gradle/gradle-conventions.svg?label=Maven%20Central)](https://central.sonatype.com/artifact/se.bjurr.gradle/gradle-conventions)

Conventional Gradle plugins that I use in my projects. The ones named with `bundle` are intended to each fulfill a general use case and the others are smaller features that make up those use cases.

See documentation [in the code](/src/main/groovy) and also [running examples](/examples).

Release with `./gradlew updateVersion && ./gradlew release`.

## Requirements

Gradle wrapper can be downloaded with:

```sh
GRADLE_VERSION=9.1.0

cat > gradle/wrapper/gradle-wrapper.properties << EOL
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip
networkTimeout=10000
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
EOL

./gradlew wrapper \
  --gradle-version="${GRADLE_VERSION}" \
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
