class Nave < Formula
  desc "Virtual environments for Node.js"
  homepage "https://github.com/isaacs/nave"
  url "https://github.com/isaacs/nave/archive/refs/tags/v3.5.5.tar.gz"
  sha256 "102b1fced7aad7746cbe9c1871984cea2560747f0369fb777857c1992dc09a7a"
  license "ISC"
  head "https://github.com/isaacs/nave.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4087fa452d7171010ab7cbceb255e705115d8b5eb65601e1993a2554aae644cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4087fa452d7171010ab7cbceb255e705115d8b5eb65601e1993a2554aae644cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4087fa452d7171010ab7cbceb255e705115d8b5eb65601e1993a2554aae644cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b568361104024a9adab2f50103a82850d3eb1aa8f35dc89133cde8485c2860d"
    sha256 cellar: :any_skip_relocation, ventura:       "6b568361104024a9adab2f50103a82850d3eb1aa8f35dc89133cde8485c2860d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4087fa452d7171010ab7cbceb255e705115d8b5eb65601e1993a2554aae644cb"
  end

  def install
    bin.install "nave.sh" => "nave"
  end

  test do
    assert_match "0.10.30", shell_output("#{bin}/nave ls-remote")
  end
end
