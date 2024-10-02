class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v24.9.30.tar.gz"
  sha256 "0771120ddbf866fba44f2e8978bcc20f3843663f5726bd8db9e03e1a27e1212a"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "441bb2842199a775229b590d1f87ce2c3344d255265ea54cc164af64e4977a35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "484206a5e13860d34f6cac072828c39fbbecdbe5c1df9c2c53e8342cad83a57a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "484206a5e13860d34f6cac072828c39fbbecdbe5c1df9c2c53e8342cad83a57a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "484206a5e13860d34f6cac072828c39fbbecdbe5c1df9c2c53e8342cad83a57a"
    sha256 cellar: :any_skip_relocation, sonoma:         "adf5c8959cd593906725d1163943ffe1372a51cbc0c276bcf4fa8b0e17d34eea"
    sha256 cellar: :any_skip_relocation, ventura:        "adf5c8959cd593906725d1163943ffe1372a51cbc0c276bcf4fa8b0e17d34eea"
    sha256 cellar: :any_skip_relocation, monterey:       "adf5c8959cd593906725d1163943ffe1372a51cbc0c276bcf4fa8b0e17d34eea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03d0db86ba5d6e05983beaa169b7606f285d754b2ade1fc9748ba9284613becf"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202409260052/geoip.dat"
    sha256 "334bd38a791c41a6b95f3afec7350c8a86ac9b2a9dde1e63c80d183edcb81af4"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20240920063125/dlc.dat"
    sha256 "aeefcd8b3e5b27c22e2e7dfb6ff5e8d0741fd540d96ab355fd00a0472f5884a7"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v5.19.0/release/config/config.json"
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
    output = shell_output "#{bin}/xray -c #{testpath}/config.json -test"

    assert_match "Configuration OK", output
    assert_predicate testpath/"log", :exist?
  end
end
