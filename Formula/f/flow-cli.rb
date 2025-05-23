class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.2.16.tar.gz"
  sha256 "ef827f6a6c1b12ad5609d5aecc0af49c50b454d5fd85c022b1c960d3ff29af39"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88d8ef7b47b22733a9241ae70d4b847ae3c491adc8346c4a00beb4feb1b38dee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1879b3b8e0ccfb78aa1d660609a5325baa6def280f23c5f63f2fbca44958789e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fac6f4f109262635b2b9b58852bc058411325414566e0aba9364bed5d770efe4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4599c04920f727298a5a85897f0128ead53fc076f9ec6a442090b4b15f5d0e3"
    sha256 cellar: :any_skip_relocation, ventura:       "c6bb9b50704da24352f0bd6a1acb22958b738cdd667397546db956ee56a26aca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4abe4c51479d6c4dfd435594bc0b1fb5f8ca2729756a2edde51f4ecc9066ea16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da4feb4d84154c150b8934b534d16f0f23c5a1adb204c179957015c652a87b56"
  end

  depends_on "go" => :build

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
