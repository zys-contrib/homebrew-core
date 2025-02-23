class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/refs/tags/0.20.1.tar.gz"
  sha256 "d5038e5c981149e35833e36184f46513bdc674d54bbf654dabd1f7652e65b0be"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ca747b9bf1119959ed5ddcbabb7bb44ebba82528a4e60722c101c839a5a954c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fc7a9f4fae79506c918485aa94bcf741f7a2f976193321b14a6e5a765709677"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "026e31936ac8f2d54c360b09ae6b82d4d41b6b4c7ca256538035440b5135ee3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4345336e22701897238692f12bbc7422db66594e5689d9467642bc15f07d02e9"
    sha256 cellar: :any_skip_relocation, ventura:       "dae95a102bc2a0d24b72629ca1ac38005e829865abc3758302093e1899da2138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab6aba2678a45ffc7c453212ac877e79a8e1c87810eff5d765a36853c2a0611a"
  end

  depends_on xcode: ["14.0", :build]

  uses_from_macos "swift" => :build
  uses_from_macos "libxml2"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".build/release/swiftdrawcli" => "swiftdraw"
  end

  test do
    (testpath/"fish.svg").write <<~EOS
      <?xml version="1.0" encoding="utf-8"?>
      <svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="160" height="160">
        <path d="m 80 20 a 50 50 0 1 0 50 50 h -50 z" fill="pink" stroke="black" stroke-width="2" transform="rotate(45, 80, 80)"/>
      </svg>
    EOS
    system bin/"swiftdraw", testpath/"fish.svg", "--format", "sfsymbol"
    assert_path_exists testpath/"fish-symbol.svg"
  end
end
