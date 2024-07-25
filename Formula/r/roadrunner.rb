class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://roadrunner.dev/"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2024.2.0.tar.gz"
  sha256 "b61dd97459b7d4bb88b6bd7e37552b5e84795442024fd78725ee1b3cc1bf887c"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff9f5ee82bcb8b623803b73abf9e7711fd44bb04b6a5dfd08afa7ff1063c7736"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae50e8a1c643ce7019b6e08d93575a47d86e943951d225a1889792fda281bab8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba604d2052478cab5a6e391e79bee57ee2b46df72b50d4009d22c2f76b5e4a31"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a04c7544ce997a4d282b0b402af8405dee8a4a89019323bfd272fbb63b02fb1"
    sha256 cellar: :any_skip_relocation, ventura:        "290cb63a76b844b7e8f2fe65c09868b7ddbd4992fbc8c87064b82b8b33aaf127"
    sha256 cellar: :any_skip_relocation, monterey:       "6b3f20b932143ca9d7d834269c5c2f8da8bd026c9645f78e207bfcbbcb3d175c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd209534401085d37f370013cfb81f325f208a13005759a94d5d20ca090400fb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.version=#{version}
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.buildTime=#{time.iso8601}
    ]
    system "go", "build", "-tags", "aws", *std_go_args(ldflags:, output: bin/"rr"), "./cmd/rr"

    generate_completions_from_executable(bin/"rr", "completion")
  end

  test do
    port = free_port
    (testpath/".rr.yaml").write <<~EOS
      # RR configuration version
      version: '3'
      rpc:
        listen: tcp://127.0.0.1:#{port}
    EOS

    output = shell_output("#{bin}/rr jobs list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/rr --version")
  end
end
