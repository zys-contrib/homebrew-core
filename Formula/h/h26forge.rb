class H26forge < Formula
  desc "Tool for making syntactically valid but semantically spec-noncompliant videos"
  homepage "https://github.com/h26forge/h26forge"
  url "https://github.com/h26forge/h26forge/archive/refs/tags/2024-07-06.tar.gz"
  sha256 "66e3bd1f63e6c70db334d103107ced2b2924aaee6472c71682ed34c8276203b0"
  license "MIT"

  depends_on "rust" => :build

  uses_from_macos "llvm" # for libclang

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"h26forge", "generate", "-o", "out.h264", "--seed", "264", "--small"
  end
end
