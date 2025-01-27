class C2048 < Formula
  desc "Console version of 2048"
  homepage "https://github.com/mevdschee/2048.c"
  url "https://github.com/mevdschee/2048.c/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "c594b0fa5f40a991ca4b77d1905bb59f73071684afc245ad0df2c6c42e514f43"
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
