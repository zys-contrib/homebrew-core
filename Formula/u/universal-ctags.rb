class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.1.20240811.0.tar.gz"
  version "p6.1.20240811.0"
  sha256 "55ae91e2f720896d81e2df6f49f10c166a38b89b84dfb86efdda6eee75557f5b"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ca085e1d6c94f1c79edd691f7ccb0a340d3d66eeee305f56fc99ffe0082bc300"
    sha256 cellar: :any,                 arm64_ventura:  "37e4b0fd21a755104f1cbd636216644f80c0ebd035b44742b08eee05e645bb58"
    sha256 cellar: :any,                 arm64_monterey: "4337d46678daaad954ef469a65126540731d032c0fd872ec4fa8c415c85955e0"
    sha256 cellar: :any,                 sonoma:         "cbaed9e03b39746a0077b1e0eb042f4500ae055fb8a6b0cc2df30b12cd3bbd3d"
    sha256 cellar: :any,                 ventura:        "d9aa79c509597261a69b7db98df54caa7b319aeee5e782b0569dc803348aaf35"
    sha256 cellar: :any,                 monterey:       "5723e3b351e5e5b75e270caabb4d8ea0c5e954452d8452915962623fe3a79846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d7687c6e5beeb98d112b041ba9fbd4bc17052c3e97b9d3d1d8c17e131171f0c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "jansson"
  depends_on "libyaml"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  conflicts_with "ctags", because: "this formula installs the same executable as the ctags formula"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>

      void func()
      {
        printf("Hello World!");
      }

      int main()
      {
        func();
        return 0;
      }
    EOS
    system bin/"ctags", "-R", "."
    assert_match(/func.*test\.c/, File.read("tags"))
  end
end
