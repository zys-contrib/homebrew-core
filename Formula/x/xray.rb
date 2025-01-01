class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v24.12.31.tar.gz"
  sha256 "e3c24b561ab422785ee8b7d4a15e44db159d9aa249eb29a36ad1519c15267be0"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a3f4e333a11469099cd52678f79af2ac97acb10dc338b0e79e53a67af61ce26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a3f4e333a11469099cd52678f79af2ac97acb10dc338b0e79e53a67af61ce26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a3f4e333a11469099cd52678f79af2ac97acb10dc338b0e79e53a67af61ce26"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb9d6eea49785c8b4764de022abf14967c2c39117a024ffba9df32a72d47bde1"
    sha256 cellar: :any_skip_relocation, ventura:       "cb9d6eea49785c8b4764de022abf14967c2c39117a024ffba9df32a72d47bde1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e723e98859e229d56e852407bb70c3d2eef194591bad0bbb78d8e1b778093523"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202412260052/geoip.dat"
    sha256 "139100814bdf9a6823b85783fdedce3a5e62d1432965b5c3f97541e117a7f83f"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20241221105938/dlc.dat"
    sha256 "aa65cee72dd6afbf9dd4c474b4ff28ceb063f6abf99249a084091adb4f282f09"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v5.22.0/release/config/config.json"
    sha256 "15a66415d72df4cd77fcd037121f36604db244dcfa7d45d82a0c33de065c6a87"
  end

  def install
    ldflags = "-s -w -buildid="
    execpath = libexec/name
    system "go", "build", *std_go_args(output: execpath, ldflags:), "./main"
    (bin/"xray").write_env_script execpath,
      XRAY_LOCATION_ASSET: "${XRAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgshare.install resource("geoip")
    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
    pkgetc.install resource("example_config")
  end

  def caveats
    <<~EOS
      An example config is installed to #{etc}/xray/config.json
    EOS
  end

  service do
    run [opt_bin/"xray", "run", "--config", "#{etc}/xray/config.json"]
    run_type :immediate
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
    output = shell_output "#{bin}/xray -c #{testpath}/config.json -test"

    assert_match "Configuration OK", output
    assert_predicate testpath/"log", :exist?
  end
end
