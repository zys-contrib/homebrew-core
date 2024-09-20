class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.99.8.tar.gz"
  sha256 "3925c16f35d1b10705b36f2a19ef9fda596cb0d07bd6bab2e1e7b9b0ce7a2c72"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8135f7f2ea59f4c76dc2abb300ed9dc8689788a910e30e7680b958750339e609"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3f9d97b226dab426abc14c324e4abaab9af8a8203f53369b2e72486069c5cc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77798e0f768b536d7987b0c8b7aae9c259b2f785936f792fada9b38693709a81"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b519f62cc347aec55ce98267455d0f26214ad7292626cce74d3434b0bf3c358"
    sha256 cellar: :any_skip_relocation, ventura:       "9a6e1b5898e9db6cdc7173eeb19b6e034a06c10f16df88ebfaab160b8c8969df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77b5707e16403b1fd17919d727160904503722e621490341040f8ae1e1065aa4"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    rm_r(buildpath/".cargo")
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db auth-password 2>&1", 1)
    assert_match "incorrect credentials", output

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end
