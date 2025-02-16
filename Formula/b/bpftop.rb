class Bpftop < Formula
  desc "Dynamic real-time view of running eBPF programs"
  homepage "https://github.com/Netflix/bpftop"
  url "https://github.com/Netflix/bpftop/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "a73718d8cfa5f6698e36c4b87ad7e93210a0aafd2a170e741eb8c84bb226b23b"
  license "Apache-2.0"
  head "https://github.com/Netflix/bpftop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6436c5d9cb27720a647795181aa3cd37f49f7346340eb5cce6f3481a240a279e"
  end

  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "elfutils"
  depends_on :linux
  depends_on "zlib"

  fails_with :gcc do
    cause "build.rs needs to run clang and not shim for gcc"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/bpftop 2>&1", 1)
    assert_match "Error: This program must be run as root", output
  end
end
