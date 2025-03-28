class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://github.com/ddddddO/gtree/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "3b7ae07dfbac1a58058c6f8497198d539db0cfa2e4fac589a129586e17660e93"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53d75b44102838d7ad1b16d5097801201f2d049b49d706b489460347870f4576"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53d75b44102838d7ad1b16d5097801201f2d049b49d706b489460347870f4576"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53d75b44102838d7ad1b16d5097801201f2d049b49d706b489460347870f4576"
    sha256 cellar: :any_skip_relocation, sonoma:        "25b62b1da53f2458a5e5b17536c5490d869a2d684c74004ac3d706948813a9ca"
    sha256 cellar: :any_skip_relocation, ventura:       "25b62b1da53f2458a5e5b17536c5490d869a2d684c74004ac3d706948813a9ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b55dc9dd498966e36d7b01b6b25fdc65484a8556f288314fa44a00bcdb565d99"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gtree"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gtree version")

    assert_match "testdata", shell_output("#{bin}/gtree template")
  end
end
