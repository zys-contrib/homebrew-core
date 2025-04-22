class LolHtml < Formula
  desc "Low output latency streaming HTML parser/rewriter with CSS selector-based API"
  homepage "https://github.com/cloudflare/lol-html"
  url "https://github.com/cloudflare/lol-html/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "b36ad8ccafce9da350f4d9c32bb31bf46dddae0798d4ad6213cabd7e166e159e"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/lol-html.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "45df0bd8f2d9ffbe6e35d78c28460153c7ea027d85a7099a47b1230d8534b028"
    sha256 cellar: :any,                 arm64_sonoma:  "36a82c0cc34a08b53271a474f07b252b99e023fc575d2c6324c82aee09baaf1c"
    sha256 cellar: :any,                 arm64_ventura: "2d06a9212960f7f3bb2476917e940a91798d7b8d691a58897341d45f654cba68"
    sha256 cellar: :any,                 sonoma:        "8a0ca1ae6536161cc06fca2e6114a1eb705ff7d4e4628de76689cd7837a2fd10"
    sha256 cellar: :any,                 ventura:       "5b28644fd53619b3a41a9f851326fd18476db1c2a031149dbf62367122db1873"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfca2de58efc4cf2e9730f5b317038b61583ca4a377df0f0562f0b92e97a2620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0462c13b05648e3e4080101d9f10b111a9c7cd3826e8059e749f2d713d44bde2"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build
  depends_on "pkgconf" => :test

  # update cargo.lock, upstream pr ref, https://github.com/cloudflare/lol-html/pull/266
  patch :DATA

  def install
    system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--release", "--locked",
                    "--manifest-path", "c-api/Cargo.toml",
                    "--prefix", prefix, "--libdir", lib
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <lol_html.h>

      int main() {
        lol_html_str_t err = lol_html_take_last_error();
        if (err.data == NULL && err.len == 0) {
          return 0;
        }

        return 1;
      }
    C

    flags = shell_output("pkgconf --cflags --libs lol-html").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/c-api/Cargo.lock b/c-api/Cargo.lock
index 954418c..14d2c9c 100644
--- a/c-api/Cargo.lock
+++ b/c-api/Cargo.lock
@@ -176,7 +176,7 @@ checksum = "a7a70ba024b9dc04c27ea2f0c0548feb474ec5c54bba33a7f72f873a39d07b24"
 
 [[package]]
 name = "lol_html"
-version = "2.2.0"
+version = "2.3.0"
 dependencies = [
  "bitflags 2.6.0",
  "cfg-if",
@@ -191,7 +191,7 @@ dependencies = [
 
 [[package]]
 name = "lol_html_c_api"
-version = "1.1.2"
+version = "1.3.0"
 dependencies = [
  "encoding_rs",
  "libc",
