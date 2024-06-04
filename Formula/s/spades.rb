class Spades < Formula
  include Language::Python::Shebang

  desc "De novo genome sequence assembly"
  homepage "https://github.com/ablab/spades"
  url "https://github.com/ablab/spades/releases/download/v4.0.0/SPAdes-4.0.0.tar.gz"
  sha256 "07c02eb1d9d90f611ac73bdd30ddc242ed51b00c8a3757189e8a8137ad8cfb8b"
  license "GPL-2.0-only"
  head "https://github.com/ablab/spades.git", branch: "next"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 3
    sha256 cellar: :any,                 sonoma:       "596f3c88c276179428ce87c7801b6e41483bdaca32f97e809d1e74c6ab656104"
    sha256 cellar: :any,                 ventura:      "f03d022acc5928a400a57d56815a314cdbe2b72c5600eb952096e57fd4abd85a"
    sha256 cellar: :any,                 monterey:     "c4da4be23d91abf193367765d6bee9cbd758add046aee900caec845d1bed243b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c284a1b00ebca8794f3f4396f481c09228aedc0ea4b6d2ad364a4efb29115a7e"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12"

  uses_from_macos "bzip2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "jemalloc"
    depends_on "readline"
  end

  def install
    system "cmake", "-S", "src", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    assert_match "TEST PASSED CORRECTLY", shell_output("#{bin}/spades.py --test")
  end
end
