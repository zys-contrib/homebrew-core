class Cbonsai < Formula
  desc "Console Bonsai is a bonsai tree generator, written in C using ncurses"
  homepage "https://gitlab.com/jallbrit/cbonsai"
  url "https://gitlab.com/jallbrit/cbonsai/-/archive/v1.4.0/cbonsai-v1.4.0.tar.gz"
  sha256 "670a463f26a8e1e9d0cfde41079526c9fa73f1dda0625fc1fa6b8f4d2544a17b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9abcb2f41fe481c2522e5ee67650e2b8f9aa0e1281a5cd311e0c6f29db259251"
    sha256 cellar: :any,                 arm64_sonoma:  "6447b5054c28f1eca9782d0f58ee3056a8a1b79f80d097e7821475b36b7f478e"
    sha256 cellar: :any,                 arm64_ventura: "e7555b1fb2aa994da464e734321b0819bc1171701e62bc7998400d1e626fb412"
    sha256 cellar: :any,                 sonoma:        "7c8ef6356003a372111ff02172d3f2363d575065877c03e7c2db674b3204bfcb"
    sha256 cellar: :any,                 ventura:       "34c2975c245adf3fb965b472b1a29cdbb33b5b9f449da68fb784ca1898065dc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab26fdd20156b40ab3b187f26e6c6b3b8dcaa5668884cf9a66d425daac6886cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d07b32aa776db453df164c9090a2dc078af5e060e17bb9148f3b9a2b87dcb74"
  end

  depends_on "pkgconf" => :build
  depends_on "scdoc" => :build
  depends_on "ncurses"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"cbonsai", "-p"
  end
end
