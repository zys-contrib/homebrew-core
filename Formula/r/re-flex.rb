class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "42bb511b6d7e12faf2972c4311534d3cca71cc84d2e9f3dd433e0eefb3b46fd1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0391567b0004d9f3dc666925585fa66ff5456ffd69aabfd86c4806210c101d02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3bbc1d5c80d249444e4e8b78f231ce9df3a88df46c40b6e993a6e2bec12b1ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "331fcd3fa95fec4dee453d989c316cd389382b05d35ec59b8626b55982425117"
    sha256 cellar: :any_skip_relocation, sonoma:        "a34892a8aa14f7ca2f3323533e940a4f348706246f54f8850bc7ddbc13d2d106"
    sha256 cellar: :any_skip_relocation, ventura:       "7eb55d5adaeca42c12bf2c67840899443db4cd924b0aa3298d468c5627c3a9cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51d548da31dcbebeec82ada8cf0d2e66b8c087b5f7e179af96fb0bf52f32ce5f"
  end

  depends_on "pcre2"

  conflicts_with "reflex", because: "both install `reflex` binaries"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"echo.l").write <<~EOS
      %{
      #include <stdio.h>
      %}
      %option noyywrap main
      %%
      .+  ECHO;
      %%
    EOS
    system bin/"reflex", "--flex", "echo.l"
    assert_predicate testpath/"lex.yy.cpp", :exist?
  end
end
