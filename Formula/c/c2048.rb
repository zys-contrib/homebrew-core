class C2048 < Formula
  desc "Console version of 2048"
  homepage "https://github.com/mevdschee/2048.c"
  url "https://github.com/mevdschee/2048.c/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "f26b2af87c03e30139e6a509ef9512203f4e5647f3225b969b112841a9967087"
  license "MIT"
  head "https://github.com/mevdschee/2048.c.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42f45739dd7914283f571c1c9f019fa41f0364110be7bb638f8c444f3638478c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2558b6e88ade9cfbd6650af8e3df2fec47afba1c5eabb799684c1e156d86ba92"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ac0c931a854d9d4f0d94bd5e729b85dd702c22739780341570679fc0fbfdbdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "46f063e7bbe544a0ac619a39ab1edda6e16fe7a72150c830d82d6ed2a11fecf6"
    sha256 cellar: :any_skip_relocation, ventura:       "06006da3d1403977e11399aa2c25eaf583c0b20648f6ddeb2510bea7e65549e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bf732ef1884150bc27c66d5e167f6de841ca282663e1b9f8ea1e531fcdb630d"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/2048 test")
    assert_match "All 13 tests executed successfully", output
  end
end
