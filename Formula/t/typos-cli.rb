class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "50c6ccafb71e61f2cf41c18e41effee52fd2b29cccede67e08b89158a455917f"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e3322d8bf3c4ca10600a11ab485d904c5e44a64e0d0ed70fed177cde1743623"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a1e174fffb38efb343db5ea8eaf79b03412a8b390be309ba0dcb943b21cfe49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aedb305a642cc4bb8dbe34d2aeb33cb431a00fccd2e6ec42225bfaec174ab949"
    sha256 cellar: :any_skip_relocation, sonoma:         "45fc1db2b04f68781387ba8cb0ad19c11eedf09162a82608e52ac244ef167001"
    sha256 cellar: :any_skip_relocation, ventura:        "c929a372ded16d5f45640acf647ab95e9af3a463b6c7d8913b67f880bb5ad313"
    sha256 cellar: :any_skip_relocation, monterey:       "56d15f36df70e440bd592ce36534edb4ce4a0bdebe602295577f53320a09027d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47c192756e2d072492c9cc6865cb31ce3690702777d4100a6862e42d8b157999"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
