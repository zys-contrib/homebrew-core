class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.99.29.tar.gz"
  sha256 "18ff348dd5642dedeb2d1a1908a1f4fa840b3309cb684dedd972408275616bce"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0b30c6cde357e44275c21b07809e4c98c182eb699f4e428d2771591af3b39d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ddd5990b7e71e79a1c5f4a9a4d3c5a1f0775e9e71fd6f65891aa3ef40a0788a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae6746873f5e388997999eef08abf08c5a8d8569eb53714bd9f66662d0748771"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe8a81a93713f259f57841f394a549f710976207041cc8c6dafa5c112bdab613"
    sha256 cellar: :any_skip_relocation, ventura:       "8e0025c6fb53958c109ec13c5171025b73e9fdf6f0aef7b469360d0a9649ffcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ad7ff203343c524343f173a4838e1fe0daa10f720a77178932b412c8b32ea44"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
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
