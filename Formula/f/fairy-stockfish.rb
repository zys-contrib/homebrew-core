class FairyStockfish < Formula
  desc "Strong open source chess variant engine"
  homepage "https://fairy-stockfish.github.io/"
  url "https://github.com/fairy-stockfish/Fairy-Stockfish/archive/refs/tags/fairy_sf_14.tar.gz"
  sha256 "db5e96cf47faf4bfd4a500f58ae86e46fee92c2f5544e78750fc01ad098cbad2"
  license "GPL-3.0-or-later"
  head "https://github.com/fairy-stockfish/Fairy-Stockfish.git", branch: "master"

  livecheck do
    url :stable
    regex(/^fairy_sf[._-]v?(\d+(?:\.\d+)*)$/i)
  end

  def install
    arch = Hardware::CPU.arm? ? "apple-silicon" : "x86-64-modern"

    system "make", "-C", "src", "build", "ARCH=#{arch}"
    bin.install "src/stockfish" => "fairy-stockfish"
  end

  test do
    system bin/"fairy-stockfish", "go", "depth", "20"
  end
end
