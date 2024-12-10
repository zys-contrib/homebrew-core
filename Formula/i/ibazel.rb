class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.25.3.tar.gz"
  sha256 "064e313f2e2fa39ebd71a8f6b5eb44e7c832b713c0fc4077811d88830aa2e68e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0205534d6a69777bc71584978ec7c5d8dff4dc16827e3e4fef4b3757f427334c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a6a3d2eaa8749318a9a9149d34bf01bed82aa3a32664c7cfac0536d2a44f250"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99edde73148166f0f1738662507a13738df09f301322e2297b8e9e7c5ffaa88e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de1b88603188daf5036f5e5ada068d962c270fcca96baf2cd291d0efdb4057bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "993c286e8f3e90429297e8d00ba069ae23e1a9ab9f5aafcec0a74bd2d0da7e60"
    sha256 cellar: :any_skip_relocation, ventura:        "e25598ecd6f211262b59640362024ea38f84b2a9cde86dd541aaea9ef030690a"
    sha256 cellar: :any_skip_relocation, monterey:       "cbb955a9601fc9bfe2f7ff6091488e457262466e67f7f0e01a1d7fe3b8a50f48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d66f94440f2ec1b6fef9b11e46776c2654b61b8c648ac8b6d275e4f0aebedf49"
  end

  depends_on "bazelisk" => [:build, :test]
  depends_on "go" => [:build, :test]

  # bazel 6.x support issue, https://github.com/bazelbuild/bazel-watcher/issues/616
  # patch to use bazel 6.4.0, upstream PR, https://github.com/bazelbuild/bazel-watcher/pull/575
  patch :DATA

  def install
    system "bazel", "build", "--config=release", "--workspace_status_command", "echo STABLE_GIT_VERSION #{version}", "//cmd/ibazel:ibazel"
    bin.install "bazel-bin/cmd/ibazel/ibazel_/ibazel"
  end

  test do
    # Write MODULE.bazel with Bazel module dependencies
    (testpath/"MODULE.bazel").write <<~BAZEL
      bazel_dep(name = "rules_go", version = "0.50.1")
      bazel_dep(name = "gazelle", version = "0.40.0")

      # Register the Go SDK extension properly
      go_sdk = use_extension("@rules_go//go:extensions.bzl", "go_sdk")

      # Register the Go SDK installed on the host.
      go_sdk.host()
    BAZEL

    (testpath/"BUILD.bazel").write <<~BAZEL
      load("@rules_go//go:def.bzl", "go_binary")

      go_binary(
          name = "bazel-test",
          srcs = ["test.go"],
      )
    BAZEL

    (testpath/"test.go").write <<~GO
      package main
      import "fmt"
      func main() {
        fmt.Println("Hi!")
      }
    GO

    pid = fork { exec("ibazel", "build", "//:bazel-test") }
    out_file = "bazel-bin/bazel-test_/bazel-test"
    sleep 1 until File.exist?(out_file)
    assert_equal "Hi!\n", shell_output(out_file)
  ensure
    Process.kill("TERM", pid)
    sleep 1
    Process.kill("TERM", pid)
  end
end

__END__
diff --git a/.bazelversion b/.bazelversion
index 8a30e8f..09b254e 100644
--- a/.bazelversion
+++ b/.bazelversion
@@ -1 +1 @@
-5.4.0
+6.4.0
