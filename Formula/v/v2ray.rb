class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.22.0.tar.gz"
  sha256 "df25a873c8f7fb30f44cb6d26b18db264dfa209df5aeb6116fc43df7157fb4b8"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "558c6bccde42c4dcb7a6d7eb57dad73afa5734cc7a26ecf894490e59f241bf2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "558c6bccde42c4dcb7a6d7eb57dad73afa5734cc7a26ecf894490e59f241bf2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "558c6bccde42c4dcb7a6d7eb57dad73afa5734cc7a26ecf894490e59f241bf2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c78cf5df23f9e12ffd062388be3cc2854dfe086d30f3c8ef3237277e4b0e685"
    sha256 cellar: :any_skip_relocation, ventura:       "7c78cf5df23f9e12ffd062388be3cc2854dfe086d30f3c8ef3237277e4b0e685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8d48ba94394072931a225c3099361411deb8123b2003fadd3fbf3677430b5f3"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202411140052/geoip.dat"
    sha256 "c9114fd3157e44f1234976a3cba6d8ffee28fb8331890f0909d64e5b6677494e"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202411140052/geoip-only-cn-private.dat"
    sha256 "9c437ba446690a2c9be5343ec1c4ab904578a164212fb8c3ea2808d7e78518f7"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20241112092643/dlc.dat"
    sha256 "f04433837b88a3f49d7cd6517c91e8f5de4e4496f3d88ef3b7c6be5bb63f4c6f"
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
    (testpath/"config.json").write <<~JSON
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
    JSON
    output = shell_output "#{bin}/v2ray test -c #{testpath}/config.json"

    assert_match "Configuration OK", output
    assert_predicate testpath/"log", :exist?
  end
end
