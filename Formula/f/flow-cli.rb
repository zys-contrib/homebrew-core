class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "c760c3f6f132de051497e2b13f86a41af454c5a852065ac343ed49078abb2a1f"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5452ee542921dfe9ea210cfed3b342bebd29cd4cd205128d182dddfcb51af5cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ebc9e5cf4cd2d2ffe235db66a57e33068839b0b1e64456b66478efabb64c423"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27b1a54c80ad62a184aa16b14c7e613ce266059008a1649e42280ba847b78f28"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ae3a70e69057cf82d5f78a29d4d0faeac82339910667bd4357e954e0380890f"
    sha256 cellar: :any_skip_relocation, ventura:       "b9d1e63fbafa3eac215b4f70bdeb5952d69b0c970c74adbf8b9eeee97b58cf4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cae7c52fb6208762eca7f61128c890eb9176e536a870327f0024dd6a53dac25"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion", base_name: "flow")
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
