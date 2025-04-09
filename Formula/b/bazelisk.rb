class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "d55ea90acb6da4cacdfad0eeecf55e58da9d3fd4b88d58502ddd34e48bb28f70"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d565925eab24c61cc0f0c39730709eedb9bda9400066c085b21c499f6edd0dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d565925eab24c61cc0f0c39730709eedb9bda9400066c085b21c499f6edd0dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d565925eab24c61cc0f0c39730709eedb9bda9400066c085b21c499f6edd0dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c110fa9b4817650ec875cd2cbac9f5463be023bdb2eadb5f7f721e079aba73f6"
    sha256 cellar: :any_skip_relocation, ventura:       "c110fa9b4817650ec875cd2cbac9f5463be023bdb2eadb5f7f721e079aba73f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "750d4a82e5cd69c786226cfaff23eb3b7331629c5cdb6b3bd396258da62f5295"
  end

  depends_on "go" => :build

  conflicts_with "bazel", because: "Bazelisk replaces the bazel binary"

  resource "bazel_zsh_completion" do
    url "https://raw.githubusercontent.com/bazelbuild/bazel/036e5337f63d967bb4f5fea78dc928d16d0b213c/scripts/zsh_completion/_bazel"
    sha256 "4094dc84add2f23823bc341186adf6b8487fbd5d4164bd52d98891c41511eba4"
  end

  # bump go to 1.23.0, upstream pr ref, https://github.com/bazelbuild/bazelisk/pull/680
  patch do
    url "https://github.com/bazelbuild/bazelisk/commit/160cdf5e1387a74e7f31f988f4ebe20c617e85fc.patch?full_index=1"
    sha256 "0a83579d9f108727bdbbb073dfab000b5c817659fd044812cb3651bc6ec58c42"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/bazelbuild/bazelisk/core.BazeliskVersion=#{version}")

    bin.install_symlink "bazelisk" => "bazel"

    resource("bazel_zsh_completion").stage do
      zsh_completion.install "_bazel"
    end
  end

  test do
    ENV["USE_BAZEL_VERSION"] = Formula["bazel"].version
    output = shell_output("#{bin}/bazelisk version")
    assert_match "Bazelisk version: #{version}", output
    assert_match "Build label: #{Formula["bazel"].version}", output

    # This is an older than current version, so that we can test that bazelisk
    # will target an explicit version we specify. This version shouldn't need to
    # be bumped.
    bazel_version = Hardware::CPU.arm? ? "7.1.0" : "7.0.0"
    ENV["USE_BAZEL_VERSION"] = bazel_version
    assert_match "Build label: #{bazel_version}", shell_output("#{bin}/bazelisk version")
  end
end
