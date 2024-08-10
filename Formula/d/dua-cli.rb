class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.29.1.tar.gz"
  sha256 "f818175cc675af37361c8800b298bb0d87be4e5354d964cfe8e36e478f739b7d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47950a4b0405e6b26f47461a0c3b643bab40e998f09dfadea724ce1bc57d72b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2bffadb5b61e48d8a4245d12a711ab9e5a621bdfe784cf0eb824252b8d3dc9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d97ba8789cdb37c1efd06249684e14fe6233a11e51e01e26ddc0b58868ac64d"
    sha256 cellar: :any_skip_relocation, sonoma:         "83d582779acff171e70f27380514363b71fccdc27aecefe1e26b6bbbbaba27c2"
    sha256 cellar: :any_skip_relocation, ventura:        "e411d97f41803f1053c998c4669e0df7e2284c745b5dcfe3f3bb88d7bf002321"
    sha256 cellar: :any_skip_relocation, monterey:       "592a84d65e33e48385bc848fc80dfc4e268608d8d8685a644cb3f4480ab42b21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "302833f0e0e3356ba21ef23989b1408e7764dcf7254b55ad7ab4bf3a4f143bf7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    expected = %r{
      \e\[32m\s*0\s*B\e\[39m\ #{testpath}/empty.txt\n
      \e\[32m\s*2\s*B\e\[39m\ #{testpath}/file.txt\n
      \e\[32m\s*2\s*B\e\[39m\ total\n
    }x
    assert_match expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end
