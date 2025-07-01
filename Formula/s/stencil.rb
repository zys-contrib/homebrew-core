class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://github.com/rgst-io/stencil/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "ff6c5ef042b5273f4799a4e4b9ae360ebfd20183151a6d59c41b47d81cfee31b"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ef9a76d7b1187558e2e2e548a86f21d116c7188a19318debf90dfc1eb7da65b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11c9cfb6a7e9eaeefe89431d1e15ab27e3ae6ee758b6c2371479ba6ba90f6ef9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "458c416958051e90ebc648a5d6e5300bb345eef0d2af682718adc21195e49bc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7262b6eb393593ff73b153e83afe9154a8b8742b907f7e219e5590b622efb2b2"
    sha256 cellar: :any_skip_relocation, ventura:       "3f70a6dcb1a99d8b3f4be6f1e78fb7d5e416eb167df45aa19c742583dfbb7e32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0239e6634ac8ae5766c8e50eff0c206bf222fd31e60e650cbfbc7949d3471226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8abbee13c3bfd532037ea18bd5d1aa8006a39b2d5a5a8e5c391d3610ccd8d84c"
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
