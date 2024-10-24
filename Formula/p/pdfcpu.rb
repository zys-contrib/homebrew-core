class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "5d18e52c70ebd75e1cc6c88faf18679a009560e781d9a29d171ae2639c1759ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f568cbcdf2966ce531feef12300cb79fd53a243a1c209a71ec32074b87f526b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f568cbcdf2966ce531feef12300cb79fd53a243a1c209a71ec32074b87f526b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f568cbcdf2966ce531feef12300cb79fd53a243a1c209a71ec32074b87f526b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e63b31f5dca0b8f6be79daec2758fdcf8a73479293311fc73a0ab10328e0a5e"
    sha256 cellar: :any_skip_relocation, ventura:       "7e63b31f5dca0b8f6be79daec2758fdcf8a73479293311fc73a0ab10328e0a5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d417220e2279d76dd8637e57501a2149ebd0b123532202bd934291180f03c1e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/pdfcpu/pdfcpu/pkg/pdfcpu.VersionStr=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pdfcpu"
  end

  test do
    info_output = shell_output("#{bin}/pdfcpu info #{test_fixtures("test.pdf")}")
    assert_match <<~EOS, info_output
      installing user font:
      Roboto-Regular
      validating URIs..

      #{test_fixtures("test.pdf")}:
                    Source: #{test_fixtures("test.pdf")}
               PDF version: 1.6
                Page count: 1
                Page sizes: 500.00 x 800.00 points
    EOS

    assert_match "validation ok", shell_output("#{bin}/pdfcpu validate #{test_fixtures("test.pdf")}")
  end
end
