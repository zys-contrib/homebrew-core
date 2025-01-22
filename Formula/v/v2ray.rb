class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.25.1.tar.gz"
  sha256 "18def3901c18eb5b24d4037d880a9d487ac94cee0e87549ec63a954658b2d47c"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dad0d48d31c2766373234e90ce91b71876c81b80cdd46b4685d1b169ac67193f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dad0d48d31c2766373234e90ce91b71876c81b80cdd46b4685d1b169ac67193f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dad0d48d31c2766373234e90ce91b71876c81b80cdd46b4685d1b169ac67193f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd6648c66205bf578b9887b56edc33dbcb5d114a5d669a9b5c584169c31887ed"
    sha256 cellar: :any_skip_relocation, ventura:       "fd6648c66205bf578b9887b56edc33dbcb5d114a5d669a9b5c584169c31887ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c8b27ab1f1641d02a47e995affb1f01e85ecd23117367730a112630dcedbb86"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202501190004/geoip.dat"
    sha256 "4f8d16184b6938e635519bc91cb978dcea6884878e39f592f7144135401d6bb6"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202501190004/geoip-only-cn-private.dat"
    sha256 "96d09ba875524044156e33406e72638523c7152377c10d1994028475462b173f"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20241221105938/dlc.dat"
    sha256 "aa65cee72dd6afbf9dd4c474b4ff28ceb063f6abf99249a084091adb4f282f09"
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
