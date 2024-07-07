class Uni2ascii < Formula
  desc "Bi-directional conversion between UTF-8 and various ASCII flavors"
  homepage "https://billposer.org/Software/uni2ascii.html"
  url "http://billposer.org/Software/Downloads/uni2ascii-4.20.tar.bz2"
  sha256 "0c5002f54b262d937ba3a8249dd3148791a3f6ec383d80ec479ae60ee0de681a"
  license "GPL-3.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?uni2ascii[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49692068ab523b29ff30943843d3c017b9c6e70fc5082e05d404e8dd4b6e3aa5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de4fbbd1260caf3ea247e5127a0e0f77a7bba4ec57e3ed54b3cd4c40d83bbd22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfe655d4eef2cd9e47feec80bdca9905e61ba0de528db266d3fc76ad187c7ff2"
    sha256 cellar: :any_skip_relocation, ventura:        "6b8a59fc1998a56e96d6879998bc900f53294a9addee3b8404f4869a39db4714"
    sha256 cellar: :any_skip_relocation, monterey:       "347f9bb0221a0a4355db70dc23de8256448d5156d949e8ae2e0603e359954458"
    sha256 cellar: :any_skip_relocation, big_sur:        "3550f8535a4dcb997bd0f1aa3fb0868771d22eaf138b9ac3136b600a5c424fd3"
    sha256 cellar: :any_skip_relocation, catalina:       "58d99cd9438e838d70d1fe8299f44ddaaf6f9378cb5849c0d8e89a178a32fafe"
    sha256 cellar: :any_skip_relocation, mojave:         "97c679d5f838e03832a99e83068eddcddfa5276971f8edcd19b53a33d0179305"
    sha256 cellar: :any_skip_relocation, high_sierra:    "e95934b7cfcfc96467f1d9d36ec91e04e53fa0edd71f9c0b8aff6e357128de5a"
    sha256 cellar: :any_skip_relocation, sierra:         "298ca15b89643dfa4946d485105fed7baa6934556c63d2bf97a3b7af0984c325"
    sha256 cellar: :any_skip_relocation, el_capitan:     "3cc5e96fa9c49edb0b06d60af238f4a4803feefe22bbf5924698649e8c4db5fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acc769baafa054d67c74f3965d7f7810ba19e45ea64d8e4f6ce7c83bf766f426"
  end

  on_macos do
    depends_on "gettext"
  end

  # notified upstream about this patch
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/bb92449ad6b3878b4d6f472237152df28080df86/uni2ascii/uni2ascii-4.20.patch"
    sha256 "250a529eda136d0edf9e63b92a6fe95f4ef5dfad3f94e6fd8d877138ada857f8"
  end

  def install
    if OS.mac?
      gettext = Formula["gettext"]
      ENV.append "CFLAGS", "-I#{gettext.include}"
      ENV.append "LDFLAGS", "-L#{gettext.lib}"
      ENV.append "LDFLAGS", "-lintl"
    end

    ENV["MKDIRPROG"]="mkdir -p"

    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    # uni2ascii
    assert_equal "0x00E9", pipe_output("#{bin}/uni2ascii -q", "é")

    # ascii2uni
    assert_equal "e\n", pipe_output("#{bin}/ascii2uni -q", "0x65")
  end
end
