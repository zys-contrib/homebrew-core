class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "http://download.camlcity.org/download/findlib-1.9.8.tar.gz"
  sha256 "662c910f774e9fee3a19c4e057f380581ab2fc4ee52da4761304ac9c31b8869d"
  license "MIT"

  livecheck do
    url "http://download.camlcity.org/download/"
    regex(/href=.*?findlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "eb5b2b68030d3527fd4b2e9c260a944605862909325bc9249b57c890449ad9f0"
    sha256 arm64_sonoma:  "71160fdec707a48d88e6f2e79f38d0df3e970e3fe81141c0da6687bbd1cb2704"
    sha256 arm64_ventura: "82ccb62e19cdbf9c9b581603ddf1a1c8d8ebe5789960df955bd29cf7764f6e09"
    sha256 sonoma:        "fda2c76eff2c5bf058045e51b92663ba21c9b0ba92ffac80d27369cffaff291d"
    sha256 ventura:       "47d5af648254ec365ad4127fd96fb2c5d384f2199963f8ca12d482718875f2f2"
    sha256 x86_64_linux:  "45f892f48a91e37037c44cf98b6937a35a29621993d9c9a54224bead2623c958"
  end

  depends_on "ocaml"

  uses_from_macos "m4" => :build

  def install
    # Specify HOMEBREW_PREFIX here so those are the values baked into the compile,
    # rather than the Cellar
    system "./configure", "-bindir", bin,
                          "-mandir", man,
                          "-sitelib", HOMEBREW_PREFIX/"lib/ocaml",
                          "-config", etc/"findlib.conf",
                          "-no-camlp4"

    system "make", "all"
    system "make", "opt"

    # Override the above paths for the install step only
    system "make", "install", "OCAML_SITELIB=#{lib}/ocaml",
                              "OCAML_CORE_STDLIB=#{lib}/ocaml"

    # Avoid conflict with ocaml-num package
    rm_r(Dir[lib/"ocaml/num", lib/"ocaml/num-top"])

    # Save extra findlib.conf to work around https://github.com/Homebrew/homebrew-test-bot/issues/805
    libexec.mkpath
    cp etc/"findlib.conf", libexec/"findlib.conf"
  end

  test do
    output = shell_output("#{bin}/ocamlfind query findlib")
    assert_equal "#{HOMEBREW_PREFIX}/lib/ocaml/findlib", output.chomp
  end
end
