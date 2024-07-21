class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v1.8.21.tar.gz"
  sha256 "464636c323c20cd17a6e10d6fdf0120f0a84096f1c66c0ab4851141d238a1a0b"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "260a78ddc73de36d6d31d3253dff841b6affabb7432f0ecb6aef909fe1d2d9ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "511d48c32e0d3757ab876215d55ec1879f20dd71f70026311b6ab5c439209982"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9169005901c4f0815b08db139ff24ac3bcf6d2786f8e04e14997ac7377e2f9a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "56f448a472ec19b7ade3141812287a5bdaad06083a86dcf335487add01f241fa"
    sha256 cellar: :any_skip_relocation, ventura:        "1d4f81b3901ae740291b30131dae14d5acccd1350d755a55cf33e74c7af5374c"
    sha256 cellar: :any_skip_relocation, monterey:       "a7284034ce292c248367eccf9ae51a8697751c2aadb1ccca999f9cd4aedfa03e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dc1ab15eca229269f10fe09ee54148b2915442023f2d288c8056fab8de128e3"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202407192357/geoip.dat"
    sha256 "8128db0c1431f4c6854dfb7740b497ee0ac73f0f3a52a1e0040c508f7d79c0a4"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20240720181558/dlc.dat"
    sha256 "873ad7f4ad185ba7a70c5addbfd064703f22a7a8e4e21e4114a8ea98da7dd5ad"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v5.16.1/release/config/config.json"
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
