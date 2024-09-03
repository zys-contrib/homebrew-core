class Lightning < Formula
  desc "Generates assembly language code at run-time"
  homepage "https://www.gnu.org/software/lightning/"
  url "https://ftp.gnu.org/gnu/lightning/lightning-2.2.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/lightning/lightning-2.2.3.tar.gz"
  sha256 "c045c7a33a00affbfeb11066fa502c03992e474a62ba95977aad06dbc14c6829"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "03e7b47e11af958f1a769127fa8e35ad59f5afff480b8d44ddfe7c8fe31e304b"
    sha256 cellar: :any,                 arm64_ventura:  "d45442dd593390a87aa9140d97e3216c80392faa0b88df8a30f5c529769af256"
    sha256 cellar: :any,                 arm64_monterey: "73efb22bdbb69fc14b207e6aba847c52fefd24b9728b1c94161694a1e0f71c9c"
    sha256 cellar: :any,                 sonoma:         "048b01bc31083e2dba41297f22823890ae784df85de6318cc5e6aafd68b04204"
    sha256 cellar: :any,                 ventura:        "9236fbc0c2fb3de9ac732b6c8e43fa349e18b4f6469e23778e1f5838be252091"
    sha256 cellar: :any,                 monterey:       "b09858738b810b2ee638b8e2025dc52af93a1be7a6aec673c4dfbe13d6677c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93c3f2e1f8ff6e8d199007ed205b51042066b1d4c67be1b39a41e6fa4b2e02fd"
  end

  depends_on "binutils" => :build

  # upstream patch for fixing `Correct wrong ifdef causing missing mprotect call if NDEBUG is not defined`
  patch do
    url "https://git.savannah.gnu.org/cgit/lightning.git/patch/?id=bfd695a94668861a9447b29d2666f8b9c5dcd5bf"
    sha256 "a049de1c08a3d2d364e7f10e9c412c69a68cbf30877705406cf1ee7c4448f3c5"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    # from https://www.gnu.org/software/lightning/manual/lightning.html#incr
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <lightning.h>
      static jit_state_t *_jit;
      typedef int (*pifi)(int);
      int main(int argc, char *argv[]) {
        jit_node_t  *in;
        pifi incr;
        init_jit(argv[0]);
        _jit = jit_new_state();
        jit_prolog();
        in = jit_arg();
        jit_getarg(JIT_R0, in);
        jit_addi(JIT_R0, JIT_R0, 1);
        jit_retr(JIT_R0);
        incr = jit_emit();
        jit_clear_state();
        printf("%d + 1 = %d\\n", 5, incr(5));
        jit_destroy_state();
        finish_jit();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-llightning", "-o", "test"
    system "./test"
  end
end
