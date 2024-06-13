class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.29.tar.gz"
  sha256 "97a9a226cac3793b5a6cabc430721037af158c77c6bee60fe3864dd4f4923386"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "265118720af46c261eb6d2b1ecb560017cd0524b48016cd8978cce1eaa60e5fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f20a4d0f9fe31364f423c2b694cd2bb3b6befe43c24eaf01c0cf90dae4b374ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "710cc181cded817b3866277f926e28f9969ae3df087ecf6863d36a3a88afd170"
    sha256 cellar: :any_skip_relocation, sonoma:         "33f090c1675ecadb6ad7d42bd1ecc7e8fe3b23f78bb1c492386c4e10b25f05d9"
    sha256 cellar: :any_skip_relocation, ventura:        "5f17a3c8d839e3e250529e63575019bc30b4bc3a7ef32071d97aa0eb3f87a817"
    sha256 cellar: :any_skip_relocation, monterey:       "062a4a16492080fe7974c57d42bbc04157461260d1e6adba4bd1df8a778f5807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88f40d5a68e60c5eec56fa754fe43e450260de19bfe36a19a432e89e4df75b8d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cli/cmd/neosync"

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
