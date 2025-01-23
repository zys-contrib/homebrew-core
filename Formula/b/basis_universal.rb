class BasisUniversal < Formula
  desc "Basis Universal GPU texture codec command-line compression tool"
  homepage "https://github.com/BinomialLLC/basis_universal"
  url "https://github.com/BinomialLLC/basis_universal/archive/refs/tags/v1_60.tar.gz"
  sha256 "64ac9363656dc3eb41c59ee52af7e939abe574a92c85fd0ba27008c4a7ec9f40"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebcd8c592a1947d4e93cb14f267b1597ab31e287235719f0a45c97060cdb7016"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c646119bc9142de2a5061c365320ba8e5cf9ea9fb1383ada79e0cb08cdd0b2d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81a8aae4f552f430183574fcb2c93292b828fa9fc0e59d04571e7cabba68c3de"
    sha256 cellar: :any_skip_relocation, sonoma:        "92738bf15ddb3decbe553026401d1df2d0c5a855a5a5ba8a919c8083e05b10c6"
    sha256 cellar: :any_skip_relocation, ventura:       "7467f56b85351044a9511937d6038995bfc7c2483a583b4966d6e11cf2194b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62ad815a0def4683e48999723ef9c4d0dac6116e3471de0f6920584eedfb41f0"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "bin/basisu"
    bin.install "bin/examples" => "basisu_examples"
  end

  test do
    system bin/"basisu", test_fixtures("test.png")
    assert_predicate testpath/"test.ktx2", :exist?
  end
end
