class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2024.12.1.tar.gz"
  sha256 "74794fbcdd7b71131799100d493cf70a8e126cb109f3d9e2abce55593df6a737"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef636cbb78e5a8abdd08a1553bf9100d80246769f7b583c61939c3578702ed58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8db2bd13965f04c385e92db5b5f97333e52c2612d4f937108eaad091b9bddd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "654293e705e10e04c895d59cb11e228221922aceceffc12097950cb8e3cbf723"
    sha256 cellar: :any_skip_relocation, sonoma:        "c91b305cec0015d1fd73329d771d11ecbb2c746a4d1125e4094b80a6ac5f631d"
    sha256 cellar: :any_skip_relocation, ventura:       "feeaa09735ea40ef9032c68bc23977ce3543f26f177a3b06677cc60f8dd14150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfc2bd27a842e47513926109fce95ffcaf8363b2ed64ca97ceeaf438ef16a853"
  end

  depends_on "go" => :build

  def install
    system "make", "install",
      "VERSION=#{version}",
      "DATE=#{time.iso8601}",
      "PACKAGE_MANAGER=#{tap.user}",
      "PREFIX=#{prefix}"
  end

  service do
    run [opt_bin/"cloudflared"]
    keep_alive successful_exit: false
    log_path var/"log/cloudflared.log"
    error_log_path var/"log/cloudflared.log"
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
