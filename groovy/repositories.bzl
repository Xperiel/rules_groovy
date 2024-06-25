# Copyright 2019 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:jvm.bzl", "jvm_maven_import_external")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def rules_groovy_dependencies():
    maybe(
        http_archive,
        name = "rules_java",
        urls = [
            "https://github.com/bazelbuild/rules_java/releases/download/7.6.4/rules_java-7.6.4.tar.gz",
        ],
        sha256 = "1d154ff89708d457f5e8d93f74cf5bb88b80506b0239e16db9b34a6e13a0299c",
    )

    http_archive(
        name = "groovy_sdk_artifact",
        urls = [
            "https://repo1.maven.org/maven2/org/codehaus/groovy/groovy-binary/3.0.9/groovy-binary-3.0.9.zip",
        ],
        sha256 = "eb34f4ee229b1a424adb87df5b999f66d1b1285694e5332d0800896744c2e421",
        build_file_content = """
filegroup(
    name = "sdk",
    srcs = glob(["groovy-3.0.9/**"]),
    visibility = ["//visibility:public"],
)
java_import(
    name = "groovy",
    jars = ["groovy-3.0.9/lib/groovy-3.0.9.jar"],
    visibility = ["//visibility:public"],
)
""",
    )
    native.bind(
        name = "groovy-sdk",
        actual = "@groovy_sdk_artifact//:sdk",
    )
    native.bind(
        name = "groovy",
        actual = "@groovy_sdk_artifact//:groovy",
    )

    jvm_maven_import_external(
        name = "junit_artifact",
        artifact = "junit:junit:4.13.2",
        server_urls = ["https://repo1.maven.org/maven2"],
        licenses = ["notice"],
        artifact_sha256 = "8e495b634469d64fb8acfa3495a065cbacc8a0fff55ce1e31007be4c16dc57d3",
    )
    native.bind(
        name = "junit",
        actual = "@junit_artifact//jar",
    )

    jvm_maven_import_external(
        name = "spock_artifact",
        artifact = "org.spockframework:spock-core:2.0-M5-groovy-3.0",
        server_urls = ["https://repo1.maven.org/maven2"],
        licenses = ["notice"],
        artifact_sha256 = "694b91f73d7f50fd30cea595774a7284e0e8964fbc2f93e121cc92b09016aff8",
    )
    native.bind(
        name = "spock",
        actual = "@spock_artifact//jar",
    )
