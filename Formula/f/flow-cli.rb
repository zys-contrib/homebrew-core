class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "a23f8154034b16c2e364d8e0362d2a34d74882f4055185c4d83c67a973375deb"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6fe88c6f55f14b9dc240dfba8dec1cdb2bbede4ff0999363f368d3900ea4d05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ee7865f8f6d8b000f29b3f6df6b893da3067a5f769e33ba49e5e573a5889a13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2d31a54d4484d01e71be888df52ae85ba03318ac33f6068390279889d6126b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e6c0b4479772b0e00bc128e7920090bcfb4c5c1acf0eb95fe948e5447dca075"
    sha256 cellar: :any_skip_relocation, ventura:       "ea60fbc63f5278e9f5f559e68357c8569705ff42a406953d38b63ffd5543057a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0d0f807539e86faa879701b1c2e0ecc99bca79c42ab1db49c8ff678d97a0642"
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
