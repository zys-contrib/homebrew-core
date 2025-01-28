class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1241.17.tar.gz"
  sha256 "77bf760f55880bb96759b4a4596c1021bc69cdfa4af72d6b65f90b65ba67c23c"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "62cd7fb6666667cca92cbd4022ca0a0232fcbcb1e50a33d4394e05779be60473"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
