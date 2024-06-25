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
            "https://repo1.maven.org/maven2/org/codehaus/groovy/groovy-binary/4.0.21/groovy-binary-4.0.21.zip",
        ],
        sha256 = "a5f27a4b3a8eb2f16ed6e73cf8b04a69b86dbf2ff6e67691d3f1df6f870bcb5f",
        build_file_content = """
filegroup(
    name = "sdk",
    srcs = glob(["groovy-4.0.21/**"]),
    visibility = ["//visibility:public"],
)
java_import(
    name = "groovy",
    jars = ["groovy-4.0.21/lib/groovy-4.0.21.jar"],
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
        artifact_sha256 = "28c2d23134dd1e1c34ba0c8c16fa12a548ec2d7f7d1e3f1e8f7d573b82c15120",
    )
    native.bind(
        name = "spock",
        actual = "@spock_artifact//jar",
    )
