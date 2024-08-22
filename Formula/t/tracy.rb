class Tracy < Formula
  desc "Real-time, nanosecond resolution frame profiler"
  homepage "https://github.com/wolfpld/tracy"
  url "https://github.com/wolfpld/tracy/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "2c11ca816f2b756be2730f86b0092920419f3dabc7a7173829ffd897d91888a1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dd1a741539f0c65f5871567157edc2aa4269703fb37079919c5043d1039c261a"
    sha256 cellar: :any,                 arm64_ventura:  "37ee1281141ecfb2a47315d41cfcf365e9faffc6166e1ac02f400a87bf0ad52c"
    sha256 cellar: :any,                 arm64_monterey: "da06ed8c0f859a1270ac08c4aef7f99691fa17cddbe03a8e1364cf4f3f7a2241"
    sha256 cellar: :any,                 sonoma:         "10d6d0b13a1387b809bd0298ac5103cfe901335167b87fc6740f3d7515c5288a"
    sha256 cellar: :any,                 ventura:        "70ff96b45cad523508fbff0f5e70c8577d6e4ad335399005e262effd89350ed5"
    sha256 cellar: :any,                 monterey:       "e8973f9aa0f62a989cfd4ea08893dd01aa463015b5d61e18d703263a085821f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8ee49d32d243d29e7fe206afd278a496e38a6456329b1d7ab42cb35ed552e12"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "capstone"
  depends_on "freetype"
  depends_on "glfw"

  on_linux do
    depends_on "dbus"
    depends_on "libxkbcommon"
    depends_on "mesa"
    depends_on "tbb"
    depends_on "wayland"
  end

  fails_with gcc: "5" # C++17

  def install
    args = %w[CAPSTONE GLFW FREETYPE].map { |arg| "-DDOWNLOAD_#{arg}=OFF" }

    buildpath.each_child do |child|
      next unless child.directory?
      next unless (child/"CMakeLists.txt").exist?
      next if %w[python test].include?(child.basename.to_s)

      system "cmake", "-S", child, "-B", child/"build", *args, *std_cmake_args
      system "cmake", "--build", child/"build"
      bin.install child.glob("build/tracy-*").select(&:executable?)
    end

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install_symlink "tracy-profiler" => "tracy"
  end

  test do
    assert_match "Tracy Profiler #{version}", shell_output("#{bin}/tracy --help")

    port = free_port
    pid = fork do
      exec bin/"tracy", "-p", port.to_s
    end
    sleep 1
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
