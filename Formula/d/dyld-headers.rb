class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1284.13.tar.gz"
  sha256 "583a6ac254698f17feb7c8a83c364d242ab9185aaf4f73478056579da6bce968"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1b92b46f229d62fc227aca770f009e930a89dce01a90a90cf3f88fb4cdef3fd3"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
