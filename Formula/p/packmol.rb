class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/refs/tags/v21.0.0.tar.gz"
  sha256 "5c751ec7f4e6960837c3579237d36449d1b37cfa240fb9590f74f558dc1fe155"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6eb3c35cd1a8d58b488850c7338e0aff09abfd931c31d8a271200b72cc32f5dd"
    sha256 cellar: :any,                 arm64_sonoma:  "02eeeda6b6fb3893af6e67e4ef7eb36bc0a9da0bab889762c2682a6a3b3857ab"
    sha256 cellar: :any,                 arm64_ventura: "e5cee14accfb1add0bf05e6029cef4dd31e6fbb7bbc8446eb76942e4bd5b1337"
    sha256 cellar: :any,                 sonoma:        "2cc6974a4d92632a5d6b8361389c0df9acc349621295315a13220658d09dd7e0"
    sha256 cellar: :any,                 ventura:       "04bbb576e2bda906234d4d52945f0537c91c39f170ef01c739b2050fac1aeaf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "368f18f1021be07bc6f7355610babbdf1d38e578cbbfc7d72ecd1faaef3d2f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d04056434173fec7d1ca461ec4dc312a0322116b84a21280cdc5fc080c25f3fd"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran

  resource "homebrew-testdata" do
    url "https://www.ime.unicamp.br/~martinez/packmol/examples/examples.tar.gz"
    sha256 "97ae64bf5833827320a8ab4ac39ce56138889f320c7782a64cd00cdfea1cf422"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "solvate.tcl"
    (pkgshare/"examples").install resource("homebrew-testdata")
  end

  test do
    cp Dir["#{pkgshare}/examples/*"], testpath
    system bin/"packmol < interface.inp"
  end
end
