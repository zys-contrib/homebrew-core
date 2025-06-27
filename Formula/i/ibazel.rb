class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/V0.26.4.tar.gz"
  sha256 "343d0b2d125a34244ff208722b8beb504dd0c97feb9c57107ae6064299a2a9bb"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazel-watcher.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c12651e6c9cbc680f6e787336fc2f2af53ccdd09cc7fafc8ee27a9317f507df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c12651e6c9cbc680f6e787336fc2f2af53ccdd09cc7fafc8ee27a9317f507df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3244d3623fc940b32da49370e3b4d78edae09fa66fc336a80dc5a2a6bfca08d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2a7ca0a10912f7e99064fa84f76e4c05a0d1e1aefc026572187c66064872f37"
    sha256 cellar: :any_skip_relocation, ventura:       "74d628872158223d2254232f97bc08654db611958b4269ed5b60aa91d8c3ec50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dd9fbcb138b56677b3123f7194cb5d13675a5cdd6f8dcfd9a41f218b3b67828"
  end

  depends_on "go" => [:build, :test]
  depends_on "bazel" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/ibazel"
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/ibazel --help 2>&1")

    # Write MODULE.bazel with Bazel module dependencies
    (testpath/"MODULE.bazel").write <<~STARLARK
      bazel_dep(name = "rules_go", version = "0.55.1")

      # Register the Go SDK extension properly
      go_sdk = use_extension("@rules_go//go:extensions.bzl", "go_sdk")

      # Register the Go SDK installed on the host.
      go_sdk.host()
    STARLARK

    (testpath/"BUILD.bazel").write <<~STARLARK
      load("@rules_go//go:def.bzl", "go_binary")

      go_binary(
          name = "bazel-test",
          srcs = ["test.go"],
      )
    STARLARK

    (testpath/"test.go").write <<~GO
      package main
      import "fmt"
      func main() {
        fmt.Println("Hi!")
      }
    GO

    pid = spawn bin/"ibazel", "build", "//:bazel-test", "--repo_contents_cache="
    out_file = "bazel-bin/bazel-test_/bazel-test"
    sleep 1 until File.exist?(out_file)
    assert_equal "Hi!\n", shell_output(out_file)
  ensure
    Process.kill("TERM", pid) unless pid.nil?
  end
end
