class Mmv < Formula
  desc "Move, copy, append, and link multiple files"
  homepage "https://github.com/rrthomas/mmv"
  url "https://github.com/rrthomas/mmv/releases/download/v2.9.1/mmv-2.9.1.tar.gz"
  sha256 "7d18332e62a3ffb021121bd1bbad1e93183f36318206899bdf909a473275f3d0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d5c872b93e2dd226026ddc2696dddefcd977f95b15d8d2408540d20c6e535ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "598637443d4ba250a2437dd1413297d103830cab8a3bbf13f378c4d87cacefd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "462d37188b6db67f3b9486a10de61eaa13066abf17203a64035e2a9ee6a4fa6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8d74d5b3d0b773a63ab440db2d329754a7a217dce6cba2f7acb98b1cb7a37ca"
    sha256 cellar: :any_skip_relocation, ventura:       "6c2d6eecdd78b36a44971b06f7ad56bb1883cd2c88fc32232d7e9497e26aa2c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f05e28c1dda1438f9c0481c4339fc9c300d7c76cd7888e3a6490cbefb6a7d98"
  end

  depends_on "help2man" => :build # for patch
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"a").write "1"
    (testpath/"b").write "2"

    assert_match "a -> b : old b would have to be deleted", shell_output("#{bin}/mmv -p a b 2>&1", 1)
    assert_predicate testpath/"a", :exist?
    assert_match "a -> b (*) : done", shell_output("#{bin}/mmv -d -v a b")
    refute_predicate testpath/"a", :exist?
    assert_equal "1", (testpath/"b").read

    assert_match "b -> c : done", shell_output("#{bin}/mmv -s -v b c")
    assert_predicate testpath/"b", :exist?
    assert_predicate testpath/"c", :symlink?
    assert_equal "1", (testpath/"c").read
  end
end
