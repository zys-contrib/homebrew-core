class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.18.0.tar.gz"
  sha256 "15acf65228867d47dcab27f87af048a2f0e6ed5d347a2e68730d30ae2a3871eb"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "69ec0da071aaf89d8342eeaa5f08710dd618df50a2d4a5f6bb4e7fc3eb81e113"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69ec0da071aaf89d8342eeaa5f08710dd618df50a2d4a5f6bb4e7fc3eb81e113"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69ec0da071aaf89d8342eeaa5f08710dd618df50a2d4a5f6bb4e7fc3eb81e113"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69ec0da071aaf89d8342eeaa5f08710dd618df50a2d4a5f6bb4e7fc3eb81e113"
    sha256 cellar: :any_skip_relocation, sonoma:         "59cc9e9133d774d387f10549dfb7130a9f9fc37a8c8baa6250952ed3a46722bc"
    sha256 cellar: :any_skip_relocation, ventura:        "59cc9e9133d774d387f10549dfb7130a9f9fc37a8c8baa6250952ed3a46722bc"
    sha256 cellar: :any_skip_relocation, monterey:       "59cc9e9133d774d387f10549dfb7130a9f9fc37a8c8baa6250952ed3a46722bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "affaea1fc03a3b360c0563ddaf05f6e8bcaf30d384dd7c4484769cb9dd3bfcba"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202409120050/geoip.dat"
    sha256 "4ec83c46f84b3efb9856903e7c10d6c21f6515b9e656575c483dcf2a3d80f916"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202409120050/geoip-only-cn-private.dat"
    sha256 "0b8ba93300d5cfce40f2f0035c5179e875f68b2d1b879d24a0c343f93ad61c03"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20240914091803/dlc.dat"
    sha256 "c171f61d3ba8e0dcf31a9548e9fd928a9416e064ad9417664eadda8d25eb6ad9"
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
