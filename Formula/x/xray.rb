class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v25.3.6.tar.gz"
  sha256 "d62305348deff713767fe1b3c23538e3f8bfe0c96d092f1f95f48c17bc2f5943"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f05568d8c7e729a0576c40cf390b825b4e063a5869c6de259afc5e881bf82ab8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f05568d8c7e729a0576c40cf390b825b4e063a5869c6de259afc5e881bf82ab8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f05568d8c7e729a0576c40cf390b825b4e063a5869c6de259afc5e881bf82ab8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dc243d6ce6f0ef9cee009963290a7058d1d631e4c4e46a968f9bdcedcd7c0de"
    sha256 cellar: :any_skip_relocation, ventura:       "5dc243d6ce6f0ef9cee009963290a7058d1d631e4c4e46a968f9bdcedcd7c0de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "639b7925309b3372261110da57ff1c56216e8031b4e5dcc185acd9e1317eceef"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202503050126/geoip.dat"
    sha256 "83337c712b04d8c16351cf5a5394eae5cb9cfa257fb4773485945dce65dcea76"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20250305033558/dlc.dat"
    sha256 "c4037839df21eadf36c88b9d56bec3853378a30f0e1a0ca8bc2e81971e5676a7"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v5.26.0/release/config/config.json"
    sha256 "15a66415d72df4cd77fcd037121f36604db244dcfa7d45d82a0c33de065c6a87"

    livecheck do
      url "https://github.com/v2fly/v2ray-core.git"
    end
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
    assert_path_exists testpath/"log"
  end
end
