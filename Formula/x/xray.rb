class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v24.12.18.tar.gz"
  sha256 "3d8b4a161a263e7af7bb1a2690961da075d13f980acd806f5cd4e5c8338d7534"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34cb663875b8b8f4586387bfdad5c982ea8e49bb2fb262c16b50d97e07ff26f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34cb663875b8b8f4586387bfdad5c982ea8e49bb2fb262c16b50d97e07ff26f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34cb663875b8b8f4586387bfdad5c982ea8e49bb2fb262c16b50d97e07ff26f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa3b28fbab7ce97d309d050354ce1770118617679f58a5ff17937a14ae036eee"
    sha256 cellar: :any_skip_relocation, ventura:       "fa3b28fbab7ce97d309d050354ce1770118617679f58a5ff17937a14ae036eee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ff62b7a7b3dc83e4136636a8238a54c25714ad4ef8672f34cb13def748d9c41"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202412120057/geoip.dat"
    sha256 "5a184de8e36b5b131e405eb1078856703c0727f097636529cbbe47f38f2fe92d"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20241210004721/dlc.dat"
    sha256 "e414da6132d8b406827b827f246c3fe9759530d61f191b866836fe4d0a7b13a4"
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
