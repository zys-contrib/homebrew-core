class ArgpStandalone < Formula
  desc "Standalone version of arguments parsing functions from GLIBC"
  homepage "https://github.com/argp-standalone/argp-standalone"
  url "https://github.com/argp-standalone/argp-standalone/archive/refs/tags/1.5.0.tar.gz"
  sha256 "c29eae929dfebd575c38174f2c8c315766092cec99a8f987569d0cad3c6d64f6"
  license all_of: [
    "LGPL-2.1-or-later",
    "LGPL-2.0-or-later", # argp.h, argp-parse.c
    :public_domain,      # mempcpy.c, strchrnul.c
  ]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88b85bef2eec548b9fc529359bb389449b781659ef08e65bc7e1bc2d72b918ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34e7f7393c3ceb901ca2a3d9b9b306db734dd5cbfc168da7976ebf9bcd02d1f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d538d7be595c57c757670fbcd922b9335f9a4a47ef16662233e84b2260eb387b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88d3f4bfb3ab27ec4105a6853fa34b94342ab2ad0d7b79248461b3bea52649a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5c202821e24b6fc6f4228fb2f56ee9038689affcdd509aba131cb94b1f184fa"
    sha256 cellar: :any_skip_relocation, ventura:        "f8f4bde836513ed713a4c9ceb2ea072c8271138de48f992366d058466e8782a0"
    sha256 cellar: :any_skip_relocation, monterey:       "f0ed596672be7b1b893ea07d341bce448470b3448b55e0b5d90f68e7895de7b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "65a3586ad4399576aeb46e497b4ec08577f84764b7a28448ae6882a2c422068d"
    sha256 cellar: :any_skip_relocation, catalina:       "560e1829dce7113479d755380e0e65318a996f0d04d8e0761f24810e9e019e7d"
    sha256 cellar: :any_skip_relocation, mojave:         "fb60d10ba68efda61d1dfdb161bcf9bfa0474c82b03e0579517cb10608aa9aea"
    sha256 cellar: :any_skip_relocation, high_sierra:    "92532fafd8c2cc86b33de0f347496746d8049bb4d1a6ce0948148e0f3c4bca5a"
    sha256 cellar: :any_skip_relocation, sierra:         "10627e72c0e0eb66cbd03a2beb767c06b8edad4bef01914de7f7c6c1be33a356"
    sha256 cellar: :any_skip_relocation, el_capitan:     "798e6ddb78957f9ad33662287b5971aaf3a43f3646e84691d56b3b85ca06d47f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on :macos # argp is provided by glibc on Linux

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <argp.h>

      int main(int argc, char ** argv)
      {
        return argp_parse(0, argc, argv, 0, 0, 0);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-largp", "-o", "test"
    system "./test"
  end
end
