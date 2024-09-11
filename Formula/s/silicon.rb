class Silicon < Formula
  desc "Create beautiful image of your source code"
  homepage "https://github.com/Aloxaf/silicon/"
  url "https://github.com/Aloxaf/silicon/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "815d41775dd9cd399650addf8056f803f3f57e68438e8b38445ee727a56b4b2d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "88fa342ff94f00149044ecd6f5fb126e104f13058b784e17cfe344eb6ca50b6b"
    sha256 cellar: :any,                 arm64_ventura:  "766d31b996f3b41dd4a8b1dd34e7ff6a7fe68d6f05dd27f7e7205f7176b892c5"
    sha256 cellar: :any,                 arm64_monterey: "ca9541fb80cb28ef973767d8dd0f1db2979f40653ca253b67491f3ea9f984259"
    sha256 cellar: :any,                 sonoma:         "218d94bdbf0f5c1e6ceff4bad2a5945094b1a7baadef0177c1ad3f9cde18fc1b"
    sha256 cellar: :any,                 ventura:        "051ac7f4d0d21dda5cb5a9372b0d9dedacf3c8b37fe7ae35b1860101c8ec7aa3"
    sha256 cellar: :any,                 monterey:       "310caff3239a9e6b7bd16db58bf203224d51ea7f0b12fdf5acfe3f0522e72b12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fa0cec538c14c858cd237c54b4660861fd9f0d60807134fde42fe971f6b8ee6"
  end

  depends_on "rust" => :build
  depends_on "harfbuzz"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "libxcb"
    depends_on "xclip"
  end

  # rust 1.80 build patch, upstream pr ref, https://github.com/Aloxaf/silicon/pull/253
  patch :DATA

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

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 0133214..a02f140 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -823,6 +823,12 @@ dependencies = [
  "num-traits",
 ]

+[[package]]
+name = "num-conv"
+version = "0.1.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "51d515d32fb182ee37cda2ccdcb92950d6a3c2893aa280e540671c2cd0f3b1d9"
+
 [[package]]
 name = "num-integer"
 version = "0.1.45"
@@ -1474,12 +1480,13 @@ dependencies = [

 [[package]]
 name = "time"
-version = "0.3.30"
+version = "0.3.36"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c4a34ab300f2dee6e562c10a046fc05e358b29f9bf92277f30c3c8d82275f6f5"
+checksum = "5dfd88e563464686c916c7e46e623e520ddc6d79fa6641390f2e3fa86e83e885"
 dependencies = [
  "deranged",
  "itoa",
+ "num-conv",
  "powerfmt",
  "serde",
  "time-core",
@@ -1494,10 +1501,11 @@ checksum = "ef927ca75afb808a4d64dd374f00a2adf8d0fcff8e7b184af886c3c87ec4a3f3"

 [[package]]
 name = "time-macros"
-version = "0.2.15"
+version = "0.2.18"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "4ad70d68dba9e1f8aceda7aa6711965dfec1cac869f311a51bd08b3a2ccbce20"
+checksum = "3f252a68540fde3a3877aeea552b832b40ab9a69e318efd078774a01ddee1ccf"
 dependencies = [
+ "num-conv",
  "time-core",
 ]
