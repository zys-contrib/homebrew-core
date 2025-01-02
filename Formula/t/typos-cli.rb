class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.29.3.tar.gz"
  sha256 "f7c8ef65193e4537475addde8e3e9ea0c83515b1f478ad07915250ae05263258"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a06f7bbc87449d1406edd115468b2b98539b64d0cf57285468a2341a0ebcd0dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b73e7af28b87a211430e105f16d5c3c36c992b0caddaf060532306480a309e0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d42eaf1db1718cf3ba96a604088f328869f274aa74407a423a030d67c1a08429"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b98b1c5a39bf545f52a70ae5300255f46c651b4136cd1d8236a4199af81e49a"
    sha256 cellar: :any_skip_relocation, ventura:       "0f5cac3ed3bc593350bcb1e4b60bb2a7f86e298def096bdc954155309b0e18e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cca0d6a54eff4e86d139d465df004eb7cf4ce317326170cd964dc69f6df6c61d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
