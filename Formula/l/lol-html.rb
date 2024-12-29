class LolHtml < Formula
  desc "Low output latency streaming HTML parser/rewriter with CSS selector-based API"
  homepage "https://github.com/cloudflare/lol-html"
  url "https://github.com/cloudflare/lol-html/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "fbc4eefbffb570f92d1133f092d93a5d2b993777e00bb4f612c17ac79a6e021b"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/lol-html.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--locked", "--lib", "--manifest-path", "c-api/Cargo.toml", "--release"
    include.install "c-api/include/lol_html.h"
    lib.install "c-api/target/release/#{shared_library("liblolhtml")}", "c-api/target/release/liblolhtml.a"
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

    system ENV.cc, "test.c", "-L#{lib}", "-llolhtml", "-o", "test"
    system "./test"
  end
end
