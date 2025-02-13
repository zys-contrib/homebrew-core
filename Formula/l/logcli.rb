class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "022c9b3db7afb0d0dec6f13ddeb44ebccf84c4697c184a4fc36991e995d3a14f"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dce69272b54928607529f663167b470d82a2642a8430399743cb5ad2ac803ec0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efd200cf4f0998fb6a416f9a2a80c7d421f44e1b30565bd8456ad7c9276ed40b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef166730753870a6619b0d083d8f3377852fda96a7570d7cb98399a8ec46131c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3429f2b5ef6b42b5bc092ed82b5f107f681bd02807d87ce322f82a04e8e3bac4"
    sha256 cellar: :any_skip_relocation, ventura:       "674e6ab1ac18ecc269150db16402160aec637a63d5786113334be11b42b0dc29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23fea237d17209fb630a340680bf31a13e4aecbb081ff2c402568e7576148faf"
  end

  depends_on "go" => :build
  depends_on "loki" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/grafana/loki/pkg/util/build.Branch=main
      -X github.com/grafana/loki/pkg/util/build.Version=#{version}
      -X github.com/grafana/loki/pkg/util/build.BuildUser=homebrew
      -X github.com/grafana/loki/pkg/util/build.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/logcli"

    generate_completions_from_executable(
      bin/"logcli",
      shell_parameter_format: "--completion-script-", shells: [:bash, :zsh],
    )
  end

  test do
    resource "homebrew-testdata" do
      url "https://raw.githubusercontent.com/grafana/loki/5c8542036609f157fee45da7efafbba72308e829/cmd/loki/loki-local-config.yaml"
      sha256 "14557cd65634314d4eec22cf1bac212f3281854156f669b61b17f2784c895ab1"
    end

    port = free_port

    testpath.install resource("homebrew-testdata")
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! "/tmp", testpath
    end

    fork { exec Formula["loki"].bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    assert_empty shell_output("#{bin}/logcli --addr=http://localhost:#{port} labels")
  end
end
