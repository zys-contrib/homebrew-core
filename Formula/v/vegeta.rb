class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/refs/tags/v12.11.3.tar.gz"
  sha256 "7106d7e81a03d32a58391b18921d69d54e710b9052b59fa4943c1b552500196f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb7a71b57fe22f9e6e43210dfbf221c7642613dfb7f4585427449ad792d5cc75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46b208e8f50824c5a847a1896eca058b705edf63c25e0013c37389b9266c462a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a777b58efb752c08e1b0c0432fdf8bd221520105cbf01138628a166412f4d8a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b0e452d79cc5123d9ce4d7d2d74e3367737183f6ba9cd4fcbbd92f8680cad1c"
    sha256 cellar: :any_skip_relocation, ventura:        "b501b39899483e884c73e4e546256f8f06eddbfd7984ba5c0a532b65ba8bda3e"
    sha256 cellar: :any_skip_relocation, monterey:       "a671d8e4b67cdcc83ddea5bd29a7e55e45b24e04e82d4705c3f3105807db83a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92f717d5e6bba690c712ec8414dd2017cd826d752d7498d753d426d1b9d6fad1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    input = "GET https://example.com"
    output = pipe_output("#{bin}/vegeta attack -duration=1s -rate=1", input, 0)
    report = pipe_output("#{bin}/vegeta report", output, 0)
    assert_match "Requests      [total, rate, throughput]", report
  end
end
