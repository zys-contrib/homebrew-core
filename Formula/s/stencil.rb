class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://github.com/rgst-io/stencil/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "3a281bca9d895e8b1945e441f3671dacdbc8651bb02685e52019ac0333b0f374"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8dc046cc95bb71c79805b47df3a912787bcbfe344e9b843120a709ecf55aafb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8dc046cc95bb71c79805b47df3a912787bcbfe344e9b843120a709ecf55aafb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8dc046cc95bb71c79805b47df3a912787bcbfe344e9b843120a709ecf55aafb"
    sha256 cellar: :any_skip_relocation, sonoma:        "60ab1ba8e76fa5ba290df0dd525c9440c0089121d634ee537480911e736d6c4a"
    sha256 cellar: :any_skip_relocation, ventura:       "60ab1ba8e76fa5ba290df0dd525c9440c0089121d634ee537480911e736d6c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c87dea0908875edc52e6bb3d2f7a65582e20162180c48f927050d2572d794f9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X go.rgst.io/stencil/v2/internal/version.version=#{version}
      -X go.rgst.io/stencil/v2/internal/version.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/stencil"
  end

  test do
    (testpath/"service.yaml").write "name: test"
    system bin/"stencil"
    assert_predicate testpath/"stencil.lock", :exist?
  end
end
