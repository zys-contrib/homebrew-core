class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "ac0d2371bf69d5136de7e9470c6fb286cbee2e16b4c7a6d2cd48a14796e86650"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f76d7eca541e60c73957142e22f2807f92b1545f07c7973e284b4e93e21e4e51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bd504ec986b32636796a79aaf5b61b3928a9743708bbcfaaebb563352a705fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23d6f6c5b51c5ae88c2d10c67cfc51f182a0ea4c3bdf520308a507d4e475e7b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "858589c4006102be15e6520a56d5fedd69c3150eaf7ed7a9e8767d0dc382d1e9"
    sha256 cellar: :any_skip_relocation, ventura:       "9375a4c70a6a96d67d5a217b239084b1c69d4ef6dc2fadd70a2d45243bb0f253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ca04de8aa0aec9273a889b0914f1466d34ab8ec70616d7a6814aa67166a084a"
  end

  on_macos do
    depends_on "coreutils" => :build
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1499
  end

  on_ventura do
    # Ventura seems to be missing the `source_location` header.
    depends_on "llvm" => :build
  end

  # -ftree-loop-vectorize -flto=12 -s
  # Needs Clang 16 / Xcode 15+
  fails_with :clang do
    build 1499
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "9"
    cause "requires GCC 10+"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1499 || MacOS.version == :ventura)
    system "make", "CXX=#{ENV.cxx}", "STRIP=true"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    require "pty"
    require "io/console"

    config = (testpath/".config/btop")
    mkdir config/"themes"
    begin
      (config/"btop.conf").write <<~EOS
        #? Config file for btop v. #{version}

        update_ms=2000
        log_level=DEBUG
      EOS

      r, w, pid = PTY.spawn(bin/"btop")
      r.winsize = [80, 130]
      sleep 5
      w.write "q"
    rescue Errno::EIO
      # Apple silicon raises EIO
    end

    log = (config/"btop.log").read
    # SMC is not available in VMs.
    log = log.lines.grep_v(/ERROR:.* SMC /).join if Hardware::CPU.virtualized?
    assert_match "===> btop++ v.#{version}", log
    refute_match(/ERROR:/, log)
  ensure
    Process.kill("TERM", pid)
  end
end
