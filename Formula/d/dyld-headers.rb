class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1285.19.tar.gz"
  sha256 "6f8671e2bdeed7545b454909b97dafcb5b5bc3f5bf0e715d9bdee79d9adabdcb"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fcb398c76d5ef67211d4f30bea2475f9e60ceaa2d1351e133e3e0c12bbcb3554"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
