class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1245.1.tar.gz"
  sha256 "5d3f663a084086d2096b9b7681209922716f940c8bd895ffd13be3da7fde2f17"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1c1a120eeac00f9b11df5efd8d6e97ab3a424b9bc74fb5a6b65c55cd0162ed34"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
