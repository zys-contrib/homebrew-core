class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.3.5/proteinortho-v6.3.5.tar.gz"
  sha256 "1b477657c44eeba304d3ec6d5179733d4c2b3857ad92dcbfe151564790328ce0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ab1f22b01cfc07a670899ed269a5be76b7a991b85c9c5f5f56dc7de05284a444"
    sha256 cellar: :any,                 arm64_sonoma:  "8e2599dd5ab127cf9b60a909327a5358285fb941d594491b176b25ac796c53b2"
    sha256 cellar: :any,                 arm64_ventura: "f14f92ee384b488e968e5cded89ec08387285b96e1d925ca2fe2d5d2cff57aa1"
    sha256 cellar: :any,                 sonoma:        "d19e5fa55ae03aaf19c9299dc4d575ade198b4ea50ba58a48206f1f7f738782b"
    sha256 cellar: :any,                 ventura:       "1c282b335913eb836cc6854b3f0a3cdb971e381e80a63d8978ddf16c89684bb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5c144cc8298e774bf04fc81c79da88a37ed15733886313710c12abce7cafb1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f32a54de7c62301afa12bab82924266855662010de36ea55a7190cd1aaf6a6c"
  end

  depends_on "diamond"
  depends_on "openblas"

  def install
    ENV.cxx11

    bin.mkpath
    system "make", "install", "PREFIX=#{bin}"
    doc.install "manual.html"
  end

  test do
    system bin/"proteinortho", "-test"
    system bin/"proteinortho_clustering", "-test"
  end
end
