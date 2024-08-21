class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1165.3.tar.gz"
  sha256 "f2cd78cdcf9d63011d0cee0047033b0815355a9f5d25df2a0690b47a05602e5f"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cbeb8be1288879abb472b2b761a88d4252c68c8334cdac79faa036e413e2ce62"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
