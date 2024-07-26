class Kcov < Formula
  desc "Code coverage tester for compiled programs, Python, and shell scripts"
  homepage "https://simonkagstrom.github.io/kcov/"
  url "https://github.com/SimonKagstrom/kcov/archive/refs/tags/v43.tar.gz"
  sha256 "4cbba86af11f72de0c7514e09d59c7927ed25df7cebdad087f6d3623213b95bf"
  license "GPL-2.0-or-later"
  head "https://github.com/SimonKagstrom/kcov.git", branch: "master"

  # We check the Git tags because, as of writing, the "latest" release on GitHub
  # is a prerelease version (`pre-v40`), so we can't rely on it being correct.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "476ce484dd142076f04dad5584324d7598b7ec364c03077c39487739d508702d"
    sha256 arm64_monterey: "bf315702b4328a6cd4acc2da03d867309af69a3d1a8fa418355a756300edae6d"
    sha256 ventura:        "9c25df1dfe0c2d36848105ad8339f39febc2880df838de7cb047ae4f437753bd"
    sha256 monterey:       "f2b4facad420ed243fd15a776ba46e4f2eb98769c0d95735a9840b3be1028c7d"
    sha256 x86_64_linux:   "c1b0c02c2c91e11096b2cdebaf1e388349e5d78ddd1922cff70aaf30899db411"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "dwarfutils"
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "elfutils"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DSPECIFY_RPATH=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello.bash").write <<~EOS
      #!/bin/bash
      echo "Hello, world!"
    EOS

    system bin/"kcov", testpath/"out", testpath/"hello.bash"
    assert_predicate testpath/"out/hello.bash/coverage.json", :exist?
  end
end
