class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https://glasskube.dev/"
  url "https://github.com/glasskube/glasskube/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "6eb54f51a1c3a44803bdfb5f69d62f874ce5b5fcca8c92e57425ec0c7da2f8f1"
  license "Apache-2.0"
  head "https://github.com/glasskube/glasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15ff82c77bd3a8286058ec387f54c6f0a101baa4f7e34ffdad0729e07cdc2c70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15ff82c77bd3a8286058ec387f54c6f0a101baa4f7e34ffdad0729e07cdc2c70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15ff82c77bd3a8286058ec387f54c6f0a101baa4f7e34ffdad0729e07cdc2c70"
    sha256 cellar: :any_skip_relocation, sonoma:         "0dbc4025d6e283b495f27eb9f00037f2eee93646fb4038957e3a193d2ac69204"
    sha256 cellar: :any_skip_relocation, ventura:        "0dbc4025d6e283b495f27eb9f00037f2eee93646fb4038957e3a193d2ac69204"
    sha256 cellar: :any_skip_relocation, monterey:       "0dbc4025d6e283b495f27eb9f00037f2eee93646fb4038957e3a193d2ac69204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6afe0a108a5d3995f0e07e8504d9514f1dc56cdffb012cc07f2823df02d14217"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/glasskube/glasskube/internal/config.Version=#{version}
      -X github.com/glasskube/glasskube/internal/config.Commit=#{tap.user}
      -X github.com/glasskube/glasskube/internal/config.Date=#{time.iso8601}
    ]

    system "make", "web"
    system "go", "build", *std_go_args(ldflags:), "./cmd/glasskube"

    generate_completions_from_executable(bin/"glasskube", "completion")
  end

  test do
    output = shell_output("#{bin}/glasskube bootstrap --type slim 2>&1", 1)
    assert_match "Your kubeconfig file is either empty or missing!", output

    assert_match version.to_s, shell_output("#{bin}/glasskube --version")
  end
end
