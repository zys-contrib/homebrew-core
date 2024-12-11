class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.78.2",
      revision: "3037dc793c6e738fee3cf36d8da24a9f54b1790d"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a67b5784c37a4f9091c46f15e98034ab1a9c5e49cc671b49e3ed14e8a2abca51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bd3d6ef295cb81fd661989c292477a24ad6c6a93c074e59815d6c5d17955224"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5519ad33ff6ca341117b328e8020e667e1dc3755cfe9ffe1fe063e4bfda14e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "48f664da27b2ae7e7421bc7796be16bbac481c11cf8256224e67c0546a307246"
    sha256 cellar: :any_skip_relocation, ventura:       "17a29166ed62c2d2fbfdb704bfd8743033c23bf8999db4b04246bb1390848341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "941eac980af5405a57a7e09731e402782a3b2d46b336383048057a029ba5a7fd"
  end

  depends_on "go" => :build

  def install
    vars = Utils.safe_popen_read("./build_dist.sh", "shellvars")
    ldflags = %W[
      -s -w
      -X tailscale.com/version.longStamp=#{vars.match(/VERSION_LONG="(.*)"/)[1]}
      -X tailscale.com/version.shortStamp=#{vars.match(/VERSION_SHORT="(.*)"/)[1]}
      -X tailscale.com/version.gitCommitStamp=#{vars.match(/VERSION_GIT_HASH="(.*)"/)[1]}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tailscale"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tailscaled"), "./cmd/tailscaled"

    generate_completions_from_executable(bin/"tailscale", "completion")
  end

  service do
    run opt_bin/"tailscaled"
    keep_alive true
    log_path var/"log/tailscaled.log"
    error_log_path var/"log/tailscaled.log"
  end

  test do
    version_text = shell_output("#{bin}/tailscale version")
    assert_match version.to_s, version_text
    assert_match(/commit: [a-f0-9]{40}/, version_text)

    fork do
      system bin/"tailscaled", "-tun=userspace-networking", "-socket=#{testpath}/tailscaled.socket"
    end

    sleep 2
    assert_match "Logged out.", shell_output("#{bin}/tailscale --socket=#{testpath}/tailscaled.socket status", 1)
  end
end
