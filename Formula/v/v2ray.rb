class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.21.0.tar.gz"
  sha256 "880a929caff7b72ef9d3b9a3262cec0dff6566c2481989822a6b27fdaaeed975"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef0bd11efaa0565b2909864d7f6937f71d0dd2d2c4aa4ef1a08a1fd8896a2cc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef0bd11efaa0565b2909864d7f6937f71d0dd2d2c4aa4ef1a08a1fd8896a2cc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef0bd11efaa0565b2909864d7f6937f71d0dd2d2c4aa4ef1a08a1fd8896a2cc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa50bf190698771c2bfd5e34cc8c9d364458b6a4be7c0c8a17621a4ca080296e"
    sha256 cellar: :any_skip_relocation, ventura:       "aa50bf190698771c2bfd5e34cc8c9d364458b6a4be7c0c8a17621a4ca080296e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0672538ee975aeec9c7cb4af468624384cfc9d201aa4ad4fff617badb0a394a8"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202410170052/geoip.dat"
    sha256 "6f5b65aee82da0415bfbe87903673cd006183f8833659646fca6b531e8c155ea"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202410170052/geoip-only-cn-private.dat"
    sha256 "37541ed2186d7fe661580e680cc5ed89f554fb02fad1acf6951361696eee6e6f"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20241013063848/dlc.dat"
    sha256 "f820556ed3aa02eb7eadba7a3743d7e6df8e9234785d0d82d2d1edce20fe4b3c"
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
