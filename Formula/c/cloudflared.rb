class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2024.9.0.tar.gz"
  sha256 "2e982337ee11a5137b0bed764aa7389ff1a7ad37be72efd6a72f8ae61cc19398"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03459e21be9f6e8f754b01a084a943946672510b6e2f026a8873cfa4a23019da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d52a7e5d59adab4f55b1ad84fc4bc8904116559ff7097c47e335abcaaeffb013"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d53e1543e11ecb25cfd5ab27989e4291f0878c99638c4a1ed04e93d356f99c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a7b549d3c9bc092235ce5559e6b6c9781aa6ddf3c34fbd156eddde3cb04244f"
    sha256 cellar: :any_skip_relocation, ventura:        "f2d704e3d9a5f023ed39b036d1d73689af0122c32d5865bd67a70cec794c0e82"
    sha256 cellar: :any_skip_relocation, monterey:       "8bac7926747e082753c76d3b966c29798656e82f1dd1e06b0304d30f24d4a43a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "326e81094b0514f62318d408ebedddaa586a8f8e090b9dca572c0e496020d9e3"
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
