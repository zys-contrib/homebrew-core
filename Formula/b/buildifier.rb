class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v8.0.3.tar.gz"
  sha256 "573345c2039889a4001b9933a7ebde8dcaf910c47787993aecccebc3117a4425"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe6474b8639b7485c46e897d0a7c2f259c9f59a8e0df6d90852bdd8e410be97a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe6474b8639b7485c46e897d0a7c2f259c9f59a8e0df6d90852bdd8e410be97a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe6474b8639b7485c46e897d0a7c2f259c9f59a8e0df6d90852bdd8e410be97a"
    sha256 cellar: :any_skip_relocation, sonoma:        "930c8a8751895aaf5606ccfdfc4e6ad278975a6975cbc811f0e0967d2146c567"
    sha256 cellar: :any_skip_relocation, ventura:       "930c8a8751895aaf5606ccfdfc4e6ad278975a6975cbc811f0e0967d2146c567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01502e3eddb7b6072f8b31f07c0ef8d1be83c3f94e47ea91b640a093f9cd3b75"
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
