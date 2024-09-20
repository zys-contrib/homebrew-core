class Fanyi < Formula
  desc "Chinese and English translate tool in your command-line"
  homepage "https://github.com/afc163/fanyi"
  url "https://registry.npmjs.org/fanyi/-/fanyi-9.0.5.tgz"
  sha256 "f81345910d2a98eabfd1d92793e085e81e70f315e0b474f47019f0a774cf5df5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adc3260b9356abf89eb2355ed8a1ab05330bff3a2ba3ee0195e62fab07cb09bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adc3260b9356abf89eb2355ed8a1ab05330bff3a2ba3ee0195e62fab07cb09bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "adc3260b9356abf89eb2355ed8a1ab05330bff3a2ba3ee0195e62fab07cb09bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fe5844f5e6970789a887cb7319ac1693b5e9cddfc0a813e016f0e094c1157c6"
    sha256 cellar: :any_skip_relocation, ventura:       "3fe5844f5e6970789a887cb7319ac1693b5e9cddfc0a813e016f0e094c1157c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adc3260b9356abf89eb2355ed8a1ab05330bff3a2ba3ee0195e62fab07cb09bf"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "爱", shell_output("#{bin}/fanyi love 2>/dev/null")
  end
end
