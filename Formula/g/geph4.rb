class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.99.5.tar.gz"
  sha256 "86c271a49ec095b2f6f480cf8feedb1670cb3048d5d174c8c004cfe545185fe6"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf39ad69bc42bd47763ca5e4bdbe1135913eb12d94c533ea4bcfecb1c9486e42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd4bc4c9ce708bfc8ea14b713920921954bde397180649f08c9c8053a14d90e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34d434422e69a6f14dbc5df3b332abd15cfdda0f257938a287ddd8a3cf170990"
    sha256 cellar: :any_skip_relocation, sonoma:        "9842876f83c2cd0e03c294520c54ed7c03f5bedbe2c96e2ba2546c3f78c895b8"
    sha256 cellar: :any_skip_relocation, ventura:       "84f6ac3add4fd3860d6083121b1d180b4c3a5a79ab4a4f8d654506147b65904c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c5c7c9e5100fbce347d8f3acef47a559f6a14c625fdf8093c438d4010eca7ee"
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
