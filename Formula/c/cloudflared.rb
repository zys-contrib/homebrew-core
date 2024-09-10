class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2024.9.0.tar.gz"
  sha256 "2e982337ee11a5137b0bed764aa7389ff1a7ad37be72efd6a72f8ae61cc19398"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "862e180417d73b6d0371120e9f791198f04ec379ec8f04c909473b82a7822171"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c726acb183ce686923bcdc422dcc06c23df66773b8426608a2e5834abd6ad9de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29c963bedbf7dd67a1c6c38a377a63e5fb54e15b5d768f74c451af02c49f7be3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "872dcb023f8ba97fb5ffc7da433e640aa382c385a480a0a60fc26bb4dd47a929"
    sha256 cellar: :any_skip_relocation, sonoma:         "276dc24621e601ac1112633b9c2dfe81c6a7d2542043f668a3cf819abbee47d0"
    sha256 cellar: :any_skip_relocation, ventura:        "d17468c94a7c5d6564135f8e738c0f11a9ae1db60e4482527394f48f37b073f3"
    sha256 cellar: :any_skip_relocation, monterey:       "a78c5a0d2e5b9ba7bb14935a988658428002103fa82c9dd1d21e9ac7aab2ed0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3537b19344c197bef17467bf4c7e9d9a87edb6a339c5d4fd695e92bd3433ecbb"
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
