class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1231.3.tar.gz"
  sha256 "ec5459db9cba71e14431ec8f8c5b5d30db956ea16a0cad839886480fa2350225"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3eee3ae6d13f59a9967d5d29f7e6b3a0f9c181caa2cd174d820e5c4c8e6e8356"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
