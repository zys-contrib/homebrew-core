class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v8.0.0.tar.gz"
  sha256 "1a9eaa51b2507eac7fe396811bc15dad4d15533acc61cc5b0d71004e1d0488cb"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "778a3d2f8e3f9d635b719dd6dbd69deb61ec5350c8bfa62e586d0165246dbe32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1166ae3c40a598be78f7c95e0d1a7c9d76a6c611202cd39c5d3d9a3b17b75f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1166ae3c40a598be78f7c95e0d1a7c9d76a6c611202cd39c5d3d9a3b17b75f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1166ae3c40a598be78f7c95e0d1a7c9d76a6c611202cd39c5d3d9a3b17b75f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "a245b991ebf0f1abc37be1efd2334ba03a418400ad39f75ea91553f0e34c4a81"
    sha256 cellar: :any_skip_relocation, ventura:        "a245b991ebf0f1abc37be1efd2334ba03a418400ad39f75ea91553f0e34c4a81"
    sha256 cellar: :any_skip_relocation, monterey:       "a245b991ebf0f1abc37be1efd2334ba03a418400ad39f75ea91553f0e34c4a81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f807df31511f08e0ac64c2ab60636e98c0bae2d4caef00f6e600f214690efec1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./buildifier"
  end

  test do
    touch testpath/"BUILD"
    system bin/"buildifier", "-mode=check", "BUILD"
  end
end
