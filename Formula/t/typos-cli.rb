class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.26.3.tar.gz"
  sha256 "6f257c26a318f4474a534b778842b680bf87422bc8a62be56e7e46c464a9b4ea"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d45119d2ebf5f0207d085bf7004f0e509c0745a3c20e81e6ab2879d011db5022"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "146d7b919feb387bdec618711575b25eefcd8165b9d6b067c4a16fc30137c30f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57a10c191ed73c00402b13f0e5cbbd6a8deee6be793ad6f34e1459edb407765a"
    sha256 cellar: :any_skip_relocation, sonoma:        "44ebc540c52df04cbafd4f68b8c8f38beb56f033811eaa3637cb9f3a4d4cce37"
    sha256 cellar: :any_skip_relocation, ventura:       "4306ac6224901ec494da39dba71ca534e24b7d7e0ec685f68059d03431d30977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5147f7c229d7b56cb95a73d752ee5a3ec3f7196ad69f8120215416843a730e0e"
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
