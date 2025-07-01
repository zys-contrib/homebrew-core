class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://github.com/rgst-io/stencil/archive/refs/tags/v2.5.3.tar.gz"
  sha256 "80a418cf2413e744495daf5ebd6fec0f86d1aa25ee2f35e2fc39ad9fc0e33135"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa101b222ff5d267a90cda63048c51c8b6855591c4fc601e7f91b2abf689797e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39845f95598ea113ce69027b818aa7a20eba07281e060bc42b3faf448eaf3971"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ab9910f5670fa3898eacfce42fdc63b4cc667324a4107ff5bf8313fb370330c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b697461b2ebaeb6ef3990d2f1dbf85e53517f9be0c622dafdb3cd6f62fff3ebb"
    sha256 cellar: :any_skip_relocation, ventura:       "a29f210529d0af53a9038a8b6f7726a0a2fc0a2baa7ea23f4ec71e7b316aadc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b6edcc24e73a13ca8bd468fc0536a59ea21b30d64f78e6793a70ed6c2dd461d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f1b665cb214d9fd772f3496cf7e4549745937abfaa07583f8047759aa727985"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X go.rgst.io/stencil/v2/internal/version.version=#{version}
      -X go.rgst.io/stencil/v2/internal/version.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/stencil"
  end

  test do
    (testpath/"service.yaml").write "name: test"
    system bin/"stencil"
    assert_path_exists testpath/"stencil.lock"
  end
end
