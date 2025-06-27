class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v4.26.1.tar.gz"
  sha256 "60bf6d34a7a87bf903b095a1c5f0d2f150f12fb9fef3977be48caab4ff93858b"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "132533c9508f64e7902fa9bbb28f9ffbe248b635872f782a50df6daa109f3ebb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab54422770e5d1fb2b29483984b9ef67f651334dd818fab4b25548cb56d7d192"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88c3b0240a82d7acd311b610ffd53d8e3adaf9745ff51cc111b296d4b8904d49"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd3c7561f75b0844c9daa9950b9adb3af4c70d8042f557db23f2afeffec46940"
    sha256 cellar: :any_skip_relocation, ventura:       "0ebd3cef2208d6d7cc492ed310cf401e2fd2d78aa3bdab2492cffdce6d7b3f78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69e2bdd1a79792d1486c95741ef0c283900798c76d0f60cabd524fa1f483b741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a869e1451ef3345809cf6cd5633271fa48c458ad236317efccfa37d06d55bf13"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python"

  def install
    cd "bkmr" do
      # Ensure that the `openssl` crate picks up the intended library.
      # https://docs.rs/openssl/latest/openssl/#manual
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

      system "cargo", "install", *std_cargo_args
    end

    generate_completions_from_executable(bin/"bkmr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    output = shell_output("#{bin}/bkmr info")
    assert_match "Database URL: #{testpath}/.config/bkmr/bkmr.db", output
    assert_match "Database Statistics", output
  end
end
