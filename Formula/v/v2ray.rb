class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.27.0.tar.gz"
  sha256 "6b0849902c2e08068101e19b101b6c534bad08a3525da393a595cfd9673bf54b"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d837ca658c727b583e2cf61603979b4ceee5726bad7c180dbba587189a65353d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d837ca658c727b583e2cf61603979b4ceee5726bad7c180dbba587189a65353d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d837ca658c727b583e2cf61603979b4ceee5726bad7c180dbba587189a65353d"
    sha256 cellar: :any_skip_relocation, sonoma:        "20f1078905b5f9a245cdad21857f74e4af2e874ce9678565d476a29837cb1a86"
    sha256 cellar: :any_skip_relocation, ventura:       "20f1078905b5f9a245cdad21857f74e4af2e874ce9678565d476a29837cb1a86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbb4b341e67734517ef7ca1d291c36bf3e322b382cacbc1adc864b6299a71817"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202502050123/geoip.dat"
    sha256 "f2f5f03da44d007fa91fb6a37c077c9efae8ad0269ef0e4130cf90b0822873e3"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202502050123/geoip-only-cn-private.dat"
    sha256 "0341eb8d85837e4b0f353f5558fd8bddd53383fb416a92f491360bb84c0ed36a"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20250209081110/dlc.dat"
    sha256 "797e75a9cf898b45101510b809a8cf8d1b0ea939c0cf57e889a703146a6ae3c5"
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
