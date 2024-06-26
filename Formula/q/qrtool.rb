class Qrtool < Formula
  desc "Utility for encoding or decoding QR code"
  homepage "https://sorairolake.github.io/qrtool/"
  url "https://github.com/sorairolake/qrtool/archive/refs/tags/v0.10.11.tar.gz"
  sha256 "9e3c65805045bbcc70a3106586b5246a6a7e84a2c1237bb957965c3d000836cb"
  license all_of: [
    "CC-BY-4.0",
    any_of: ["Apache-2.0", "MIT"],
  ]
  head "https://github.com/sorairolake/qrtool.git", branch: "develop"

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    outdir = Dir["target/release/build/qrtool-*/out"].first
    man1.install Dir["#{outdir}/*.1"]
  end

  test do
    (testpath/"output.png").write shell_output("#{bin}/qrtool encode 'QR code'")
    assert_predicate testpath/"output.png", :exist?
    assert_equal "QR code", shell_output("#{bin}/qrtool decode output.png")
  end
end
