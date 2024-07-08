class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-3.5.0.tar.xz"
  sha256 "67e8dae1ca2468d90de4e601c87d5f31ff492b38e8ab8bcbd02ddf7104ed8a9f"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "62e552684c8e60b8a9e8ded197763bc30a915ea6ebd1e5c5758461736cf3e00c"
    sha256 arm64_ventura:  "310e7b07d00742e098ffb07e390d7b65dc5e46b4b4dcf2d755ca22f6beff5da3"
    sha256 arm64_monterey: "5abbe804a669848b477c41d4e686a2f60d989e863bcbd3d131045d0e22d5c3b6"
    sha256 sonoma:         "1ff4c56187ff11925e3a933ced7d5d760bb5cc02a6b305a35a48b5dcd74a65dd"
    sha256 ventura:        "1c76422e4bd105544bddcb4d7da9f4426588c3f9ba227c5fe705c7b2259634e6"
    sha256 monterey:       "1c1b8de720877f9c6ce3be9358a01bb59f66af53927b03540e263316c57224b1"
    sha256 x86_64_linux:   "c72357eb490ac89c8c0ea089e618ac90e48c84c469ca0280387b83e05a973e7f"
  end

  depends_on "pkg-config" => :build
  depends_on "ca-certificates"
  depends_on "python@3.12"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1400
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  fails_with gcc: "5"

  def python3
    which("python3.12")
  end

  def install
    ENV.runtime_cpu_detection

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --with-zlib
      --with-bzip2
      --with-sqlite3
      --system-cert-bundle=#{Formula["ca-certificates"].pkgetc}/cert.pem
    ]
    args << "--with-commoncrypto" if OS.mac?

    if OS.mac? && DevelopmentTools.clang_build_version <= 1400
      ENV.llvm_clang

      ldflags = %W[-L#{Formula["llvm"].opt_lib}/c++ -L#{Formula["llvm"].opt_lib} -lunwind]
      args << "--ldflags=#{ldflags.join(" ")}"
    end

    system python3, "configure.py", *args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write shell_output("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
