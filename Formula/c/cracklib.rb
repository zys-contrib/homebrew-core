class Cracklib < Formula
  desc "LibCrack password checking library"
  homepage "https://github.com/cracklib/cracklib"
  url "https://github.com/cracklib/cracklib/releases/download/v2.10.2/cracklib-2.10.2.tar.bz2"
  sha256 "e157c78e6f26a97d05e04b6fe9ced468e91fa015cc2b2b7584889d667a958887"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "0f231f48c8024fbf45ae1b8a15964bf1800388a38c6c531b63186ff70703252c"
    sha256 arm64_ventura:  "e7d7c13b6c64b85343bb3a63e8d4f36bc73558b6c71d9a3a9c0a2d7a985690af"
    sha256 arm64_monterey: "17727e4efe900789f4d4a2cf6a5be19c7a4cc96a2cde1153b95c454b0c8a936e"
    sha256 sonoma:         "597400935abe1f841d1208c22bfc36e2f2f6e851b5af57c00c4c7c7e8eca4c50"
    sha256 ventura:        "95547fe0db7ff728800cd10e1ced9534505bfdf11a3e9243f62c50b0b0abbf1f"
    sha256 monterey:       "a5869de4d658a2da346aa9ebdc1a2a389bda5a1415ae66a850b3dc174b0273de"
    sha256 x86_64_linux:   "95dfd460b7aa55d174a75a0248814ccca7770314b012368840790220b74ca9d9"
  end

  head do
    url "https://github.com/cracklib/cracklib.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gettext"

  uses_from_macos "zlib"

  resource "cracklib-words" do
    url "https://github.com/cracklib/cracklib/releases/download/v2.10.2/cracklib-words-2.10.2.bz2"
    sha256 "ec25ac4a474588c58d901715512d8902b276542b27b8dd197e9c2ad373739ec4"
  end

  def install
    buildpath.install (buildpath/"src").children if build.head?
    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--sbindir=#{bin}",
                          "--without-python",
                          "--with-default-dict=#{var}/cracklib/cracklib-words"
    system "make", "install"

    share.install resource("cracklib-words")
  end

  def post_install
    (var/"cracklib").mkpath
    cp share/"cracklib-words-#{resource("cracklib-words").version}", var/"cracklib/cracklib-words"
    system "#{bin}/cracklib-packer < #{var}/cracklib/cracklib-words"
  end

  test do
    assert_match "password: it is based on a dictionary word", pipe_output(bin/"cracklib-check", "password", 0)
  end
end
