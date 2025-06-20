class Cbonsai < Formula
  desc "Console Bonsai is a bonsai tree generator, written in C using ncurses"
  homepage "https://gitlab.com/jallbrit/cbonsai"
  url "https://gitlab.com/jallbrit/cbonsai/-/archive/v1.4.2/cbonsai-v1.4.2.tar.gz"
  sha256 "75cf844940e5ef825a74f2d5b1551fe81883551b600fecd00748c6aa325f5ab0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "87acaebbc9ccbfa0498afe372a9e5929e517d1101db0c810934f8a207b723ee8"
    sha256 cellar: :any,                 arm64_sonoma:  "258a8ec97fa1633d7d2afb8175e3231ba3f71a71bb65d9355ce53ef03dc76601"
    sha256 cellar: :any,                 arm64_ventura: "fabbe949cd5b6269de61806f6d35db18d06c7741713545dd80edaf1ab6963cd4"
    sha256 cellar: :any,                 sonoma:        "e871751b77d3bd14012d40e23c7c95eecd7490b671514cbc91aa7baa42281d47"
    sha256 cellar: :any,                 ventura:       "99596c38d7af3904b2b9fd0fc1b66fb3bb7bb1a7fb9419fb3af075522df84a3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b17b5ec41467258a18fa8054cb97f97e330fc86cc5b6daf36516d41af8d6bf67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67d4b19d09853ab041fa86b89cf288e4ad38655f516ef784f3ab40feb35d6ce5"
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
