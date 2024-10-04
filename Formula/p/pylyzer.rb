class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https://github.com/mtshiba/pylyzer"
  url "https://github.com/mtshiba/pylyzer/archive/refs/tags/v0.0.64.tar.gz"
  sha256 "9288ebf9d6442764d3f5761497c62813a3590094b2c56032741a51d6fb9962c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1de7225745ae6e0db8fb3509bf014f1b023e9b33ff49b83968e22f22947bda37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be7e4b5fde9dde269e79bba61b7641da7012dd6ee36df941994a52f00557569b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1dddc603ecfc73bc82dbb27a7160b6ddafa9bc1e207fae8b65f15b8288376297"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4b9a219efcf3f81e451048676e9eefc93d318f902390b0c410610fa3faed3fe"
    sha256 cellar: :any_skip_relocation, ventura:       "d38e184d8d145f333ea1207ca146e214f7e0d8bcc1d44edd8c03767a3b8c2f76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3b6c0fdc66db09df73dd94153166ddcf8cd029fdb150b4233503af8ad2b06b5"
  end

  depends_on "rust" => :build

  def install
    ENV["HOME"] = buildpath # The build will write to HOME/.erg
    system "cargo", "install", *std_cargo_args(root: libexec)
    erg_path = libexec/"erg"
    erg_path.install Dir[buildpath/".erg/*"]
    (bin/"pylyzer").write_env_script(libexec/"bin/pylyzer", ERG_PATH: erg_path)
  end

  test do
    (testpath/"test.py").write <<~EOS
      print("test")
    EOS

    expected = <<~EOS
      \e[94mStart checking\e[m: test.py
      \e[92mAll checks OK\e[m: test.py
    EOS

    assert_equal expected, shell_output("#{bin}/pylyzer #{testpath}/test.py")

    assert_match "pylyzer #{version}", shell_output("#{bin}/pylyzer --version")
  end
end
