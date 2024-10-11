class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.20.0.tar.gz"
  sha256 "2de8ac3429705f594ca1a75a2a0fca09820938c94e912370902f87bd72680693"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60855abefe1df6ad0596a1a93aff27fd3016b040fadc75063d0ad2089a17878b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60855abefe1df6ad0596a1a93aff27fd3016b040fadc75063d0ad2089a17878b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60855abefe1df6ad0596a1a93aff27fd3016b040fadc75063d0ad2089a17878b"
    sha256 cellar: :any_skip_relocation, sonoma:        "94a27ac68ac7df40f44e05816f8f371dc42ea8a2320e969d4ed177ac4a6d26f5"
    sha256 cellar: :any_skip_relocation, ventura:       "94a27ac68ac7df40f44e05816f8f371dc42ea8a2320e969d4ed177ac4a6d26f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12c474530f91cb0670f964b61f8976b61c9a2e65f5568b3adbddb2eb1789d404"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202410100052/geoip.dat"
    sha256 "384c0143e551dae3022b78d9e42e7d3c9c9df428710467598c258312333c88ff"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202410100052/geoip-only-cn-private.dat"
    sha256 "56a5649fb701aeea0adb9ce29163b4ec75f9c60853e44ffc5cf6450664e41e16"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20241007202930/dlc.dat"
    sha256 "03a097fe913113941878898cde9d48f3c89f7b8f3c493631fcff354ed845f1d3"
  end

  def install
    ldflags = "-s -w -buildid="
    system "go", "build", *std_go_args(ldflags:, output: libexec/"v2ray"), "./main"

    (bin/"v2ray").write_env_script libexec/"v2ray",
      V2RAY_LOCATION_ASSET: "${V2RAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgetc.install "release/config/config.json"

    resource("geoip").stage do
      pkgshare.install "geoip.dat"
    end

    resource("geoip-only-cn-private").stage do
      pkgshare.install "geoip-only-cn-private.dat"
    end

    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
  end

  service do
    run [opt_bin/"v2ray", "run", "-config", etc/"v2ray/config.json"]
    keep_alive true
  end

  test do
    (testpath/"config.json").write <<~EOS
      {
        "log": {
          "access": "#{testpath}/log"
        },
        "outbounds": [
          {
            "protocol": "freedom",
            "tag": "direct"
          }
        ],
        "routing": {
          "rules": [
            {
              "ip": [
                "geoip:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            },
            {
              "domains": [
                "geosite:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            }
          ]
        }
      }
    EOS
    output = shell_output "#{bin}/v2ray test -c #{testpath}/config.json"

    assert_match "Configuration OK", output
    assert_predicate testpath/"log", :exist?
  end
end
