class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.com"
  url "https://github.com/nzbgetcom/nzbget/archive/refs/tags/v24.5.tar.gz"
  sha256 "d8a26fef9f92d63258251c69af01f39073a479e48c14114dc96d285470312c83"
  license "GPL-2.0-or-later"
  head "https://github.com/nzbgetcom/nzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0478991b7ae356aca4c35a7d036fdcb188988b57811fd2bb1a1d678e9dbc33fc"
    sha256 cellar: :any,                 arm64_sonoma:  "7af9e5cee1dabae64cd660cbe0fb9bde0aaf3607f80ee798d052483a436f5492"
    sha256 cellar: :any,                 arm64_ventura: "e353ce5f208b56a48f41656ee35784f74dabe71759e1f676f426f7b67d7694d1"
    sha256                               sonoma:        "d0ffe0849e5e2135a7405402a55b6787cfe546e7dac732024e1cd9b7737fb103"
    sha256                               ventura:       "df3636cf74641699384be7edf44b9d7126ec3fa9cf44b81812cfdada38bf3e66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea5ef2b5e097844f99a180ccd6c2b9508354c1d8ecf0dcd228de3b71a69173ea"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "openssl@3"
  depends_on "sevenzip"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      # Set upstream's recommended values for file systems without
      # sparse-file support (e.g., HFS+); see Homebrew/homebrew-core#972
      inreplace "nzbget.conf", "DirectWrite=yes", "DirectWrite=no"
      inreplace "nzbget.conf", "ArticleCache=0", "ArticleCache=700"
      # Update 7z cmd to match homebrew binary
      inreplace "nzbget.conf", "SevenZipCmd=7z", "SevenZipCmd=7zz"
    end

    etc.install "nzbget.conf"
  end

  service do
    run [opt_bin/"nzbget", "-c", HOMEBREW_PREFIX/"etc/nzbget.conf", "-s", "-o", "OutputMode=Log",
         "-o", "ConfigTemplate=#{HOMEBREW_PREFIX}/share/nzbget/nzbget.conf",
         "-o", "WebDir=#{HOMEBREW_PREFIX}/share/nzbget/webui"]
    keep_alive true
    environment_variables PATH: "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin"
  end

  test do
    (testpath/"downloads/dst").mkpath
    # Start nzbget as a server in daemon-mode
    system bin/"nzbget", "-D", "-c", etc/"nzbget.conf"
    # Query server for version information
    system bin/"nzbget", "-V", "-c", etc/"nzbget.conf"
    # Shutdown server daemon
    system bin/"nzbget", "-Q", "-c", etc/"nzbget.conf"
  end
end
