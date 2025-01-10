class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "afc854ecef0d877f5b56ae93b9e9b115964d8fa1a9762b5e40fc9ef4f0e2f1d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af0d7a456fd99d58ad4e40fea746b9d8046d4056774a34ed07ab88ff60cceed7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af0d7a456fd99d58ad4e40fea746b9d8046d4056774a34ed07ab88ff60cceed7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af0d7a456fd99d58ad4e40fea746b9d8046d4056774a34ed07ab88ff60cceed7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8451126da2b60edd8bee5cfe55a5e9cdab80d5100eeacfcfaac87896cd7197ff"
    sha256 cellar: :any_skip_relocation, ventura:       "8451126da2b60edd8bee5cfe55a5e9cdab80d5100eeacfcfaac87896cd7197ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8a4d3e093aad48b5a51ac7ab7ca41429aef982337de8f61672d8336bfa0962a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-cli --version")

    output = shell_output("#{bin}/osctrl-cli check-db 2>&1", 1)
    assert_match "Failed to execute - Failed to create backend", output
  end
end
