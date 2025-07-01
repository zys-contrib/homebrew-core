class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "4e935319a9e6760f683c0310a56d8720700bb7e66e5ccd60291efa93c7bf78ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35c66e54243a8ecc47e5e1bf028541461fe136b31c2234fc72e3623d5bcbd8da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41fb293bf17f1b0c96efc53fe08d68df45efaedec0dd99d54563188f26520ad6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a7f5c95f81f8f872ec42d8b446b214fc867ea3500a8a02f7b54d66da883d996"
    sha256 cellar: :any_skip_relocation, sonoma:        "f77813a283bb541873ab8c4ee00b370da04e3455607f9792ef7099dd5793f108"
    sha256 cellar: :any_skip_relocation, ventura:       "4057278b7acc29ad2b1a02a7191b52c1bbe7c110796fd02ff2511fba42005a17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5632f7b110a70e93702f7012cc2bd2444d8fb473079311f05b1784922e4fd102"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03f59c93e4f552c9cb124fa45f4cece10cd771c5ea4172a8bc25b812e36396e2"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output(bin/"kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
