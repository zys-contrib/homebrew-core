class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://github.com/rustsec/rustsec/archive/refs/tags/cargo-audit/v0.21.0.tar.gz"
  sha256 "343242874edd00c2aa49c7481af0c4735ebcf682d04710f0c02a56a9015f6092"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rustsec/rustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-audit/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "21bed15ab32597f77138b5580939d8968581d364fd7a666e022a9d10c1298b91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d4a4150d6dc6ca387b330faec6c7d02e702623292f4e98f521ed7e55ddaa17e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d593cba38ba2151f0de63eef859b6e721858d4f166d939780b069c6fcef05915"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a22b351570d486285a6deaa4b4e6406a7986a4b391463d3511a677574d592d87"
    sha256 cellar: :any_skip_relocation, sonoma:         "45570977fbae17013a277d8f6c526846a1939ba462bf2585304e71e85501f0de"
    sha256 cellar: :any_skip_relocation, ventura:        "8c26a8ca40fb0aa94d6ae3d2a5e686583452fb723e458d4337b138a9e66cf07c"
    sha256 cellar: :any_skip_relocation, monterey:       "428cfe95aede6ef9ad0d9679146ccd8760f007acf9406a87847cff9c14f9cba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "627da7addad326cf941213dc1705126a3befbcbddcd0a641153849f44a1143b0"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-audit")
    # test cargo-audit
    pkgshare.install "cargo-audit/tests/support"
  end

  test do
    output = shell_output("#{bin}/cargo-audit audit 2>&1", 2)
    assert_predicate HOMEBREW_CACHE/"cargo_cache/advisory-db", :exist?
    assert_match "not found: Couldn't load Cargo.lock", output

    cp_r "#{pkgshare}/support/base64_vuln/.", testpath
    assert_match "error: 1 vulnerability found!", shell_output("#{bin}/cargo-audit audit 2>&1", 1)
  end
end
