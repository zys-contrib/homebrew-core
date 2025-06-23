class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "https://www.mujs.com/"
  url "https://mujs.com/downloads/mujs-1.3.7.tar.gz"
  sha256 "fa15735edc4b3d27675d954b5703e36a158f19cfa4f265aa5388cd33aede1c70"
  license "ISC"
  head "https://github.com/ccxvii/mujs.git", branch: "master"

  livecheck do
    url "https://mujs.com/downloads/"
    regex(/href=.*?mujs[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "839b3fa73f32ef2b53a2e52af833fa2257786dd32bf6094f19dba18d4d47f274"
    sha256 cellar: :any,                 arm64_sonoma:  "84220bdaa3fc8a2e33185fb4e1b0426cf37a31f83bcfdeed90a2fb37e50780c1"
    sha256 cellar: :any,                 arm64_ventura: "0765c40d6deb118da5f0f8edd014bd4de89d889bee4fed10a7b7c64c23affcee"
    sha256 cellar: :any,                 sonoma:        "8a354ea3d674b092ead9ed37be5d584c2ef8470ebbbad298c00af7fb7fbc0f8e"
    sha256 cellar: :any,                 ventura:       "20a7ee4f3d183a7fcae93ecedfd9562485b3462a6cc013e74e0cc66a5ad34ace"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e7bab595f2280b58d8c3193370ed5d9f12e864b60ec18aec64c70e0122ad6c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16f8f85b13a69a0962fab110a0215ebd002220ab84878bd164cd3dd7171cf9db"
  end

  depends_on "pkgconf" => :test

  on_linux do
    depends_on "readline"
  end

  # update build for `utfdata.h`, upstream pr ref, https://github.com/ccxvii/mujs/pull/203
  patch do
    url "https://github.com/ccxvii/mujs/commit/e21c6bfdce374e19800f2455f45828a90fce39da.patch?full_index=1"
    sha256 "e10de8b9c3a62ffe121b61fe60b67ba8faa68eaace9a3b17a13f46a2cc795a11"
  end

  def install
    system "make", "prefix=#{prefix}", "release"
    system "make", "prefix=#{prefix}", "install"
    system "make", "prefix=#{prefix}", "install-shared" if build.stable?
  end

  test do
    (testpath/"test.js").write <<~JAVASCRIPT
      print('hello, world'.split().reduce(function (sum, char) {
        return sum + char.charCodeAt(0);
      }, 0));
    JAVASCRIPT
    assert_equal "104", shell_output("#{bin}/mujs test.js").chomp
    # test pkg-config setup correctly
    assert_match "-I#{include}", shell_output("pkgconf --cflags mujs")
    assert_match "-L#{lib}", shell_output("pkgconf --libs mujs")
    system "pkgconf", "--atleast-version=#{version}", "mujs"
  end
end
