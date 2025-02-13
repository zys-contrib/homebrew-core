class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "022c9b3db7afb0d0dec6f13ddeb44ebccf84c4697c184a4fc36991e995d3a14f"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ff3d92a0f16eef8330153d6ea6b1c0047bb3620358fc9bd82452611a70c7cda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fc4df2d1b0f08ec0b5a0f97a9eb8299360bad1ab6b1b2c9744019482d1f62f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da275644211d95fe71fa98e3f85701b4723b850976a95bd1e3187ceb77dd3b6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7da0231c105ed10dd8dc57673e2fd888d1b66e1eeeba71d417286c6fa148c512"
    sha256 cellar: :any_skip_relocation, ventura:       "4691cda0dfe1871a23d401e9b9ec8c8a2faf01c9442369f842776777355d90c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c521a6eb0e5e828c1deed985e0b02113883d879f7df319c0ca68c0c0e935e95e"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "systemd"
  end

  def install
    cd "clients/cmd/promtail" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
      etc.install "promtail-local-config.yaml"
    end
  end

  service do
    run [opt_bin/"promtail", "-config.file=#{etc}/promtail-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var/"log/promtail.log"
    error_log_path var/"log/promtail.log"
  end

  test do
    port = free_port

    cp etc/"promtail-local-config.yaml", testpath
    inreplace "promtail-local-config.yaml" do |s|
      s.gsub! "9080", port.to_s
      s.gsub!(/__path__: .+$/, "__path__: #{testpath}")
    end

    fork { exec bin/"promtail", "-config.file=promtail-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
