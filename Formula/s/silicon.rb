class Silicon < Formula
  desc "Create beautiful image of your source code"
  homepage "https://github.com/Aloxaf/silicon/"
  url "https://github.com/Aloxaf/silicon/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "56e7f3be4118320b64e37a174cc2294484e27b019c59908c0a96680a5ae3ad58"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "3cad4ec20ab16b1a2d1040416723bae123955facbe599350fb9bb81f716aecb7"
    sha256 cellar: :any,                 arm64_sonoma:   "8b022877b17b6066bc489492515fe08152bacca5328f2432820fd044050fe416"
    sha256 cellar: :any,                 arm64_ventura:  "5efeb8cbcdd20ef78104a7e7193f5da0426c661fa173a5efe7682e72e856b014"
    sha256 cellar: :any,                 arm64_monterey: "71bcf12d642e3902b8be7f0ea4b553e6e088756dbb40d381f744b10b845bc0da"
    sha256 cellar: :any,                 sonoma:         "20ee4179a8d037ad0ce0feae5643e20b2bf6f67718253a3f0022fb5fb701e8e0"
    sha256 cellar: :any,                 ventura:        "bf3cfafcd40201eae34dd09491b39a35de15006ec165f7ed82a126dc175f96c9"
    sha256 cellar: :any,                 monterey:       "8b51904d6783f059bd75861408e70131e4f8798ce2bd8158d706676a0170e27b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a94bbc93480f99ed069fec1e7f86dee27922e2b0c1d00ba8f6a6c79f42da3f5"
  end

  depends_on "rust" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "harfbuzz"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libxcb"
    depends_on "xclip"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.rs").write <<~EOF
      fn factorial(n: u64) -> u64 {
          match n {
              0 => 1,
              _ => n * factorial(n - 1),
          }
      }

      fn main() {
          println!("10! = {}", factorial(10));
      }
    EOF

    system bin/"silicon", "-o", "output.png", "test.rs"
    assert_predicate testpath/"output.png", :exist?
    expected_size = [894, 630]
    assert_equal expected_size, File.read("output.png")[0x10..0x18].unpack("NN")
  end
end
