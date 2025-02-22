class Zns < Formula
  desc "CLI tool for querying DNS records with readable, colored output"
  homepage "https://github.com/znscli/zns"
  url "https://github.com/znscli/zns/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "4a54ccbc0d2d027ea6a56ccef0f3b40c284cc2ad014467181dc2c7c74641314d"
  license "MIT"
  head "https://github.com/znscli/zns.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/znscli/zns/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zns --version")
    assert_match "a.iana-servers.net.", shell_output("#{bin}/zns example.com -q NS --server 1.1.1.1")
  end
end
