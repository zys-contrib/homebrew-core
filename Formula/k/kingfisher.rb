class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "04a948795651c2ba0c58efcc68391977efbc9bfb9f8cc28fc95d9134b6b486e8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4648d841a8ff951b48fb893e8bf79cd0bf4e874126fb3328e53b877c04eee105"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94c9f2bbfc3da9d91d894556a2c284421d74f7a2938a25ef3855646d51011b1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01c789956d6e287266193c2aff456aad1973e7fe1a9bf0b3cf99c34ebd1c8a42"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2a9186fbb9311a0b1ae9114abd017250ed97a74e1ebfd8b57c779de4a4a4f68"
    sha256 cellar: :any_skip_relocation, ventura:       "35853adbcc7094931ff3a87db0af9f8962ef868e4efbcc83f91358b17ee245f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0192595d50ea0fb6bce2c5974ca5c5f6589b410d48a7824d3e46a0992eccf928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15d2c216a56dd5c6a60f8eae4175ee2b91c44fa319b372bd6af642da0638e311"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kingfisher --version")

    output = shell_output(bin/"kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
