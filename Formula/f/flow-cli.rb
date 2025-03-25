class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.2.8.tar.gz"
  sha256 "2e6dba770478a9a68dfaee11d754831267bc3131bf285c9f0e45d5c25286f867"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b1be84cdcc448bb6afe00b5224664c7e14717cdfac4eef68669dcbeb354d7bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56ba2af01e2831f9cfb7475d959ab40d18f34a5efac146fbc34fdb73ceee888c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ee2d2308760142a818c81c36dd123a63b5c275c4558fcaf1f5ef0b905daa07a"
    sha256 cellar: :any_skip_relocation, sonoma:        "00a466d041c32b4e57936987ddc73f410e9868216a9faa54b024927662c69973"
    sha256 cellar: :any_skip_relocation, ventura:       "c583c6d6ed66ca85ab93f84c41680547651c7d5754d588179bc1866ebb1f6449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8498ded64d623c24ff23acc19f15c6df4ce357ba6095c6bce8611a419f58342b"
  end

  depends_on "go@1.23" => :build # crashes with go 1.24, see https://github.com/onflow/flow-cli/issues/1902

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion")
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      access(all) fun main() {
        log("Hello, world!")
      }
    EOS

    system bin/"flow", "cadence", "hello.cdc"
  end
end
