class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2024.7.1.tar.gz"
  sha256 "9eb4bd66888746fc1920bf98889b29c2ce98a7719e2c090d6b31740e397105de"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8dc54f46d08111b74f0bfdf0bac4735543eb33d281c498b54d8285874fcb9614"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afb522f2797c165b7a403d46d7b1389c7491a54ef887b5590381c5c8c173c8bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2af6b10fe97bb7bdb6a381c5e60f84424f5aaf2a3d8ea038135a323dfaca2a80"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2860a52841e7913460ed2b4d8c2cb67ddb2f9cbb08b56407a94364e940c52a4"
    sha256 cellar: :any_skip_relocation, ventura:        "061244441131d52a7096fd2721cc53ba0192a1272943d898147b7ab2bb946121"
    sha256 cellar: :any_skip_relocation, monterey:       "2f14da1f608436abf4a89667fea31639b7d474436ad6846721a017dde4c82868"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49810ee0eab30ff85b70248aa273ec6e249bc766106711144dd3c5ea5339e214"
  end

  depends_on "go" => :build

  def install
    system "make", "install",
      "VERSION=#{version}",
      "DATE=#{time.iso8601}",
      "PACKAGE_MANAGER=#{tap.user}",
      "PREFIX=#{prefix}"
  end

  test do
    help_output = shell_output("#{bin}/cloudflared help")
    assert_match "cloudflared - Cloudflare's command-line tool and agent", help_output
    assert_match version.to_s, help_output
    assert_equal "unable to find config file\n", shell_output("#{bin}/cloudflared 2>&1", 1)
    assert_match "Error locating origin cert", shell_output("#{bin}/cloudflared tunnel run abcd 2>&1", 1)
    assert_match "cloudflared was installed by #{tap.user}. Please update using the same method.",
      shell_output("#{bin}/cloudflared update 2>&1")
  end
end
