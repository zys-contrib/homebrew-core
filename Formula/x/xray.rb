class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v1.8.16.tar.gz"
  sha256 "61a96fba9ae18e91ea163f317a3641bca21fa744c214fb912270a3e6b7a8da6d"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51e3fca2efd26297a08c1edaac23c93dcf7eecb0acbdde287a42c751443a0462"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "287c23f0062d11132c749c76a36b67a3076cce61510f59d5d44461e2c58bcd8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "680db6e91f9031777e7806d758cc3878638ea24431e78b46960322f20c37c4d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "22b7db7f50c08c502ac4b8359982b39f87e6b2dec5561a41394608c5138e4034"
    sha256 cellar: :any_skip_relocation, ventura:        "09649c45226e255998f5d28d1f83b1c1feef320f9992bbaa84bef29125a68a22"
    sha256 cellar: :any_skip_relocation, monterey:       "aec70f5d91db3e70202868ab76d24476952fd6df4e8d57acc461200655079e67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5ad722dd927aa58a37b30e32c5487d0a3a95e88f78cff8d6057fb8243e2b9c1"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202406200042/geoip.dat"
    sha256 "4d65e0bfc4976c65d7ce2c77ae7c06fe8bf8ab852c3d83bd2a2fa1f952e556e5"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20240614093027/dlc.dat"
    sha256 "d3d6482b9a1d8a875ae86756058e7693bb8ce7b476f690b191498d854fe16e76"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v5.15.3/release/config/config.json"
    sha256 "1bbadc5e1dfaa49935005e8b478b3ca49c519b66d3a3aee0b099730d05589978"
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
