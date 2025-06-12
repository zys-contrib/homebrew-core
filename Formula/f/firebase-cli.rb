class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.7.0.tgz"
  sha256 "c698fabb2248238be2fc46cb3a2e710b7374b588116e8cf5026d164399d4037a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23750b4bd5d9b5c8d1740dc2e12537422e3d4027314291bc43dea7027f77ecee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23750b4bd5d9b5c8d1740dc2e12537422e3d4027314291bc43dea7027f77ecee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23750b4bd5d9b5c8d1740dc2e12537422e3d4027314291bc43dea7027f77ecee"
    sha256 cellar: :any_skip_relocation, sonoma:        "c36a05cac86433368f8fad415e2582d2caea168bb2474612dab3607be15d4ef3"
    sha256 cellar: :any_skip_relocation, ventura:       "c36a05cac86433368f8fad415e2582d2caea168bb2474612dab3607be15d4ef3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09d3c265c66064f7b33c6034e004246c82a55a640f8f988ca7a0a0cabb6ecd5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3724ffbb8165a585ed093d8f109af7874fcb7d91b48f6339a8004881ce875488"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # Skip `firebase init` on self-hosted Linux as it has different behavior with nil exit status
    if !OS.linux? || ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
      assert_match "Failed to authenticate", shell_output("#{bin}/firebase init", 1)
    end

    output = shell_output("#{bin}/firebase use dev 2>&1", 1)
    assert_match "Failed to authenticate, have you run \e[1mfirebase login\e[22m?", output
  end
end
