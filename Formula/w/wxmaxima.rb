class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/refs/tags/Version-24.11.0.tar.gz"
  sha256 "e01fd8ca9bb8054e38f6d973f619e2549ab6ab9d0aaebae70c4ed73580258055"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^Version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "0eeda3a7b713fd21cb1e016f65d73f5affd0b3d6785c0259d8c8ed1abf383cd9"
    sha256 arm64_ventura:  "68800dc51d4e13f01814472d80b906f5976487d3c4c77156f6bf67b039e6f5b3"
    sha256 arm64_monterey: "639c86d978ddaee16e23c0f5dc892ba3cc282a66dd11337eb9e6e42a9337b7a1"
    sha256 sonoma:         "9ef91f92fc84d0f06743bb449f2e89621dbab5b45a30fecf8b44d7d26b19df6e"
    sha256 ventura:        "fe84da6ef807ee8bda2dc98ce1bdd4a378efa66805d88908c02f1d1b90c812ed"
    sha256 monterey:       "ea1ad330fa139f2e9c0c2657a84e1a788301bc2ca430941338b28693240aeee4"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "ninja" => :build

  depends_on "maxima"
  depends_on "wxwidgets"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1300
  end

  fails_with :clang do
    build 1300
    cause <<~EOS
      .../src/MathParser.cpp:1239:10: error: no viable conversion from returned value
      of type 'CellListBuilder<>' to function return type 'std::unique_ptr<Cell>'
        return tree;
               ^~~~
    EOS
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1300)

    # Disable CMake fixup_bundle to prevent copying dylibs
    inreplace "src/CMakeLists.txt", "fixup_bundle(", "# \\0"

    system "cmake", "-S", ".", "-B", "build-wxm", "-G", "Ninja", *std_cmake_args
    system "cmake", "--build", "build-wxm"
    system "cmake", "--install", "build-wxm"
    bash_completion.install "data/wxmaxima"

    return unless OS.mac?

    bin.write_exec_script prefix/"wxmaxima.app/Contents/MacOS/wxmaxima"
  end

  def caveats
    <<~EOS
      When you start wxMaxima the first time, set the path to Maxima
      (e.g. #{HOMEBREW_PREFIX}/bin/maxima) in the Preferences.

      Enable gnuplot functionality by setting the following variables
      in ~/.maxima/maxima-init.mac:
        gnuplot_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
        draw_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
    EOS
  end

  test do
    # Error: Unable to initialize GTK+, is DISPLAY set properly
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_equal "wxMaxima #{version}", shell_output(bin/"wxmaxima --version 2>&1").chomp
    assert_match "extra Maxima arguments", shell_output("#{bin}/wxmaxima --help 2>&1", 1)
  end
end
