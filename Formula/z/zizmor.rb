class Zizmor < Formula
  desc "CLI tool for finding security issues in GitHub Actions setups"
  homepage "https://github.com/woodruffw/zizmor"
  url "https://github.com/woodruffw/zizmor/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "e76db16b7f4157a1381cbc3b3cc5d3236379294e3e0b9cd0551d54725bf8ea8b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94b500eeef144a39d45dd2c64bcc4a7c038ac6e95b1547bbbe9e239aa2115ef2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aae6e1e0b06334ba258ed8c0260c19dd18a121f908eed621eb99379db8b138ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7b195eddd29d8ace5ea9bed88110a01289b701729012a659db877b6b1c83a85"
    sha256 cellar: :any_skip_relocation, sonoma:        "04d2c86f225b71b76bf83f24825fb262ed9df49f9f0fd559c4723e6e6509cb9d"
    sha256 cellar: :any_skip_relocation, ventura:       "ce38eace22b227caffc1ac5f58bdcd6f31c7398fe4013f9cb83f798eedf6d5d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b636fb59115540ce9bfa1f9e84d7118c8d5903a85cebf6fe7d5dd7a76bc3a20c"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"action.yaml").write <<~YAML
      on: push
      jobs:
        vulnerable:
          runs-on: ubuntu-latest
          steps:
            - name: Checkout
              uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/zizmor --format plain #{testpath}/action.yaml")
    assert_match "does not set persist-credentials: false", output
  end
end
