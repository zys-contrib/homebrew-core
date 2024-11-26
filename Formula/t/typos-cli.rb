class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "da02a027d8779e598e0fa77df0674968a70f5b1f895a2ecb9d47c702dd6f64cf"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51f4ec0473bb4b426e760367d34c6255979eb296d2b8f2ac0f962abb167d5d29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "410132b527226cadcdee6430c3f159b19473672c133c25129b5837b774c9fd1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b932ebcc93d8de40f734d1e21c7cecbf4c6b8c5afffce54224665ff83baf3015"
    sha256 cellar: :any_skip_relocation, sonoma:        "99e1fca427e95c41cc45a524f3b532a72303081b64f7063894a62e07df46eeff"
    sha256 cellar: :any_skip_relocation, ventura:       "fbdeab742098f71ff4f8f11e1a8898e1d63f9737a131f4b19dadb48083e750f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f996b6bf863599989091e678c6b4a5d71b1c9ef6273d010dd851dee4f2790034"
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
