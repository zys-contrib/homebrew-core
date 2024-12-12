class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.3.4/proteinortho-v6.3.4.tar.gz"
  sha256 "d38514e8d5a08cc99b0539348fff89a200325d46241af8ad13037ad57151c161"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1444ec3713935622b7aaf07a7ca29a28f6c27d1154753e7b31f025342d1b593a"
    sha256 cellar: :any,                 arm64_sonoma:  "e34209e2425ccbe1130818bd1d9111d84476bdc21be46828a99bfc053001e47f"
    sha256 cellar: :any,                 arm64_ventura: "bf6d29cd976aeff17d7799f80d6bfb5135f680ebaa7b649153e79fab9d74f079"
    sha256 cellar: :any,                 sonoma:        "7b5d83605750429e37ae21bafac91c2413d2259fc3d3ce06d68b16e281e3a8c3"
    sha256 cellar: :any,                 ventura:       "fe4ed96a1a283d33c1ca6b607803fc61af421168769b0800bad0e457afa2744b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8318a08820d036bab2221812211395b38348d5d4b7349d73fcc60109bf8bcdbc"
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
