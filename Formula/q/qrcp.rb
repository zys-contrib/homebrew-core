class Qrcp < Formula
  desc "Transfer files to and from your computer by scanning a QR code"
  homepage "https://qrcp.sh"
  url "https://github.com/claudiodangelis/qrcp/archive/refs/tags/v0.11.5.tar.gz"
  sha256 "3eb98c08062c3056425ec997c25cd0c7de9492f016c083d540bd83bf68ed914f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15adbe49e05094652fa17a1b6099f6e2e213d2bad52e5952ac65a57f57066322"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15adbe49e05094652fa17a1b6099f6e2e213d2bad52e5952ac65a57f57066322"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15adbe49e05094652fa17a1b6099f6e2e213d2bad52e5952ac65a57f57066322"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd6ab4e941c7b5b82b0f09ea0667899877925020a9cb1bb5ff6e7939d745819b"
    sha256 cellar: :any_skip_relocation, ventura:       "cd6ab4e941c7b5b82b0f09ea0667899877925020a9cb1bb5ff6e7939d745819b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f66311bb89610d7cf99b367ca4383514c660e4bba980d192fb6b2fe948aeb097"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/claudiodangelis/qrcp/version.version=#{version}
      -X github.com/claudiodangelis/qrcp/version.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"qrcp", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qrcp version")

    (testpath/"test_data.txt").write <<~EOS
      Hello there, big world
    EOS

    port = free_port
    server_url = "http://localhost:#{port}/send/testing"

    (testpath/"config.json").write <<~JSON
      {
        "interface": "any",
        "fqdn": "localhost",
        "port": #{port}
      }
    JSON

    fork do
      exec bin/"qrcp", "-c", testpath/"config.json", "--path", "testing", testpath/"test_data.txt"
    end
    sleep 1

    # User-Agent header needed in order for curl to be able to receive file
    assert_equal "Hello there, big world\n", shell_output("curl -H \"User-Agent: Mozilla\" #{server_url}")
  end
end
