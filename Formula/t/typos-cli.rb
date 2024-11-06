class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "33b2bc9734ea4ac82f4b72a9ecfaf1923465f1fc7bfc22eef5b002fcd4b922ae"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "510afe472637f08391810f15e8e1203927e1856eb9d71d079b3e5a72bc5d7aad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54465d6a0543f1b2f0f3e1cfb3037778d02c131a6d1e0c0fabc27782ba4ef82e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d47ab3cac0c7fa0e2beda0b885c1f4792261cd7619cd3bb1ffb899e7c851ba94"
    sha256 cellar: :any_skip_relocation, sonoma:        "50827b8e85272ba5330f11d197b0256cb70ff8fad036cba5188d56d185fcf474"
    sha256 cellar: :any_skip_relocation, ventura:       "67053d8e377ae6b11b70b8b934c6d81315cfb96a4a289f3ab5aca9e1c7e76824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9126d2aa30df5bf3e04f5cda2a8226d496018734a3337f71d68b9a6cda643c19"
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
