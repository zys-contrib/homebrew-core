class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.28.0.tar.gz"
  sha256 "94f05846f6b0d97924b78f0cd11859d91e4ca371af465932e18827f80fd014b5"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a70f3790d772a97febee09e6b1757fc4bec65dbc4db1f13326c6e1ad5ceb51e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a70f3790d772a97febee09e6b1757fc4bec65dbc4db1f13326c6e1ad5ceb51e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a70f3790d772a97febee09e6b1757fc4bec65dbc4db1f13326c6e1ad5ceb51e"
    sha256 cellar: :any_skip_relocation, sonoma:        "377687dd4f3cc120d5ea4594fe437180aa52c779870adbd01a8ad741cce9b017"
    sha256 cellar: :any_skip_relocation, ventura:       "377687dd4f3cc120d5ea4594fe437180aa52c779870adbd01a8ad741cce9b017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcbc8eeef845236be486f04016eba788fe26932d88088ef3e2381474542c6f5d"
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
    url "https://github.com/v2fly/domain-list-community/releases/download/20250212030559/dlc.dat"
    sha256 "81ce6fa7d40ba952a5d036e6ab2b79eb25f302fcf86c753f8208801636b346de"
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
