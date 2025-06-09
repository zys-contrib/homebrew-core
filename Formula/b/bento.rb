class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "71ef02ede93738288d97cbacc3629bf054882d27e8edf81eadfe2924b7105f24"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "feea11f28ae911337a3ff0713d84c29ebc5fdbe23dca0df36cf983d57ebb6fa3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46ebbae99da9d29c2bf8899f4ec218beeab12f9ceac8a878d791a8e8a2d9dad7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad7393aebb6f15304929e1182cc95732e45a330dfc10e5025ab3acd1ccaa532f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac95ae1d71f4fcc432d41779e9ef87d21819cfd21135b9ed51938b48e920c1b6"
    sha256 cellar: :any_skip_relocation, ventura:       "b8e7176ad43b21fad767d3ec23629a6734504b046b31aa9f3bf03a6f18a1e3a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a6d018079116e10230582e43feb86c6e3bfa375a8d88796720a754a1f032cdc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w  -X github.com/warpstreamlabs/bento/internal/cli.Version=#{version} -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bento"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bento --version")

    (testpath/"config.yaml").write <<~YAML
      input:
        stdin: {}#{" "}

      pipeline:
        processors:
          - mapping: root = content().uppercase()

      output:
        stdout: {}
    YAML

    output = shell_output("echo foobar | bento -c #{testpath}/config.yaml")
    assert_match "FOOBAR", output
  end
end
