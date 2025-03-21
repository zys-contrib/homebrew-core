class Uffizzi < Formula
  desc "Self-serve developer platforms in minutes, not months with k8s virtual clusters"
  homepage "https://uffizzi.com"
  url "https://github.com/UffizziCloud/uffizzi_cli/archive/refs/tags/v2.4.17.tar.gz"
  sha256 "1feeae19c455b16d4bcf153fad984d3f013b274744b6046ba3ef62e07c6922ac"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "05ee521b203305963aca4cb58e64fd3ee32d923447ef363d632b7d865c7a6448"
    sha256 cellar: :any,                 arm64_sonoma:  "bb01bc566ac14b605068944fc3bda556e006a3f64cffbd0a0881e13e4da4bab4"
    sha256 cellar: :any,                 arm64_ventura: "1d15f5caab5c2d1e0bf8e75b7e3b792e869bc0fcf51c38f6e8e5d5dde9fb4e1b"
    sha256 cellar: :any,                 sonoma:        "943093434555a87cd9c768ffb1af79278027fd2d8e889b2a34da0eb3efd7fa6f"
    sha256 cellar: :any,                 ventura:       "40896bf188020f9923a3cb18d4d94494602062ed03a924045619c7f98e8ee5dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8e5e7e6abbd600fcf6bc07b59851d8637d44bcf919ebe3ebde22fa375b2ded8"
  end

  depends_on "ruby"
  depends_on "skaffold"

  conflicts_with "conserver", because: "both install `console` binaries"

  # Runtime dependencies of uffizzi
  # List with `gem install --explain uffizzi-cli`
  resource "tty-cursor" do
    url "https://rubygems.org/gems/tty-cursor-0.7.1.gem"
    sha256 "79534185e6a777888d88628b14b6a1fdf5154a603f285f80b1753e1908e0bf48"
  end

  resource "tty-spinner" do
    url "https://rubygems.org/gems/tty-spinner-0.9.3.gem"
    sha256 "0e036f047b4ffb61f2aa45f5a770ec00b4d04130531558a94bfc5b192b570542"
  end

  resource "wisper" do
    url "https://rubygems.org/gems/wisper-2.0.1.gem"
    sha256 "ce17bc5c3a166f241a2e6613848b025c8146fce2defba505920c1d1f3f88fae6"
  end

  resource "tty-screen" do
    url "https://rubygems.org/gems/tty-screen-0.8.2.gem"
    sha256 "c090652115beae764336c28802d633f204fb84da93c6a968aa5d8e319e819b50"
  end

  resource "tty-reader" do
    url "https://rubygems.org/gems/tty-reader-0.9.0.gem"
    sha256 "c62972c985c0b1566f0e56743b6a7882f979d3dc32ff491ed490a076f899c2b1"
  end

  resource "tty-color" do
    url "https://rubygems.org/gems/tty-color-0.6.0.gem"
    sha256 "6f9c37ca3a4e2367fb2e6d09722762647d6f455c111f05b59f35730eeb24332a"
  end

  resource "pastel" do
    url "https://rubygems.org/gems/pastel-0.8.0.gem"
    sha256 "481da9fb7d2f6e6b1a08faf11fa10363172dc40fd47848f096ae21209f805a75"
  end

  resource "tty-prompt" do
    url "https://rubygems.org/gems/tty-prompt-0.23.1.gem"
    sha256 "fcdbce905238993f27eecfdf67597a636bc839d92192f6a0eef22b8166449ec8"
  end

  resource "thor" do
    url "https://rubygems.org/gems/thor-1.3.2.gem"
    sha256 "eef0293b9e24158ccad7ab383ae83534b7ad4ed99c09f96f1a6b036550abbeda"
  end

  resource "bigdecimal" do
    url "https://rubygems.org/gems/bigdecimal-3.1.8.gem"
    sha256 "a89467ed5a44f8ae01824af49cbc575871fa078332e8f77ea425725c1ffe27be"
  end

  resource "concurrent-ruby" do
    url "https://rubygems.org/gems/concurrent-ruby-1.3.5.gem"
    sha256 "813b3e37aca6df2a21a3b9f1d497f8cbab24a2b94cab325bffe65ee0f6cbebc6"
  end

  resource "sentry-ruby" do
    url "https://rubygems.org/gems/sentry-ruby-5.23.0.gem"
    sha256 "8e8bb2f9a56a267a50fcba947f2ae131b6542f45fc3bb5764c2c25ba68f385cc"
  end

  resource "securerandom" do
    url "https://rubygems.org/gems/securerandom-0.4.1.gem"
    sha256 "cc5193d414a4341b6e225f0cb4446aceca8e50d5e1888743fac16987638ea0b1"
  end

  resource "minitar" do
    url "https://rubygems.org/gems/minitar-1.0.2.gem"
    sha256 "b192eb2ba7672906ed53853d2188130a849f1c2451e5b2dac688d9f5f7634672"
  end

  resource "logger" do
    url "https://rubygems.org/gems/logger-1.6.6.gem"
    sha256 "dd618d24e637715472732e7eed02e33cfbdf56deaad225edd0f1f89d38024017"
  end

  resource "childprocess" do
    url "https://rubygems.org/gems/childprocess-5.1.0.gem"
    sha256 "9a8d484be2fd4096a0e90a0cd3e449a05bc3aa33f8ac9e4d6dcef6ac1455b6ec"
  end

  resource "public_suffix" do
    url "https://rubygems.org/gems/public_suffix-6.0.1.gem"
    sha256 "61d44e1cab5cbbbe5b31068481cf16976dd0dc1b6b07bd95617ef8c5e3e00c6f"
  end

  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.8.7.gem"
    sha256 "462986537cf3735ab5f3c0f557f14155d778f4b43ea4f485a9deb9c8f7c58232"
  end

  resource "launchy" do
    url "https://rubygems.org/gems/launchy-3.1.1.gem"
    sha256 "72b847b5cc961589dde2c395af0108c86ff0119f42d4648d25b5440ebb10059e"
  end

  resource "i18n" do
    url "https://rubygems.org/gems/i18n-1.14.7.gem"
    sha256 "ceba573f8138ff2c0915427f1fc5bdf4aa3ab8ae88c8ce255eb3ecf0a11a5d0f"
  end

  resource "faker" do
    url "https://rubygems.org/gems/faker-3.5.1.gem"
    sha256 "1ad1fbea279d882f486059c23fe3ddb816ccd1d7052c05a45014b4450d859bfc"
  end

  resource "awesome_print" do
    url "https://rubygems.org/gems/awesome_print-1.9.2.gem"
    sha256 "e99b32b704acff16d768b3468680793ced40bfdc4537eb07e06a4be11133786e"
  end

  resource "benchmark" do
    url "https://rubygems.org/gems/benchmark-0.4.0.gem"
    sha256 "0f12f8c495545e3710c3e4f0480f63f06b4c842cc94cec7f33a956f5180e874a"
  end

  resource "uri" do
    url "https://rubygems.org/gems/uri-1.0.2.gem"
    sha256 "b303504ceb7e5905771fa7fa14b649652fa949df18b5880d69cfb12494791e27"
  end

  resource "drb" do
    url "https://rubygems.org/gems/drb-2.2.1.gem"
    sha256 "e9d472bf785f558b96b25358bae115646da0dbfd45107ad858b0bc0d935cb340"
  end

  resource "base64" do
    url "https://rubygems.org/gems/base64-0.2.0.gem"
    sha256 "0f25e9b21a02a0cc0cea8ef92b2041035d39350946e8789c562b2d1a3da01507"
  end

  resource "minitest" do
    url "https://rubygems.org/gems/minitest-5.22.3.gem"
    sha256 "ea84676290cb5e2b4f31f25751af6050aa90d3e43e4337141c3e3e839611981e"
  end

  resource "connection_pool" do
    url "https://rubygems.org/gems/connection_pool-2.5.0.gem"
    sha256 "233b92f8d38e038c1349ccea65dd3772727d669d6d2e71f9897c8bf5cd53ebfc"
  end

  resource "tzinfo" do
    url "https://rubygems.org/gems/tzinfo-2.0.6.gem"
    sha256 "8daf828cc77bcf7d63b0e3bdb6caa47e2272dcfaf4fbfe46f8c3a9df087a829b"
  end

  resource "activesupport" do
    url "https://rubygems.org/gems/activesupport-8.0.2.gem"
    sha256 "8565cddba31b900cdc17682fd66ecd020441e3eef320a9930285394e8c07a45e"
  end

  resource "uffizzi-cli" do
    url "https://rubygems.org/gems/uffizzi-cli-2.4.17.gem"
    sha256 "bb997e9b0dad3f7c9f2ec8e9b5b427e40d43f0794d02e4fd36a1bc298b548231"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--no-document", "--install-dir", libexec
    end

    bin.install Dir["#{libexec}/bin/*"]

    bin.env_script_all_files(libexec, GEM_HOME: ENV["GEM_HOME"], GEM_PATH: ENV["GEM_PATH"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uffizzi version")
    server_url = "https://example.com"
    system bin/"uffizzi config set server #{server_url}"
    assert_match server_url, shell_output("#{bin}/uffizzi config get-value server")
  end
end
