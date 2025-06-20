class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.8.0.tgz"
  sha256 "da0b14115621ce46347ab2e966dd53d804e1a62ce33345ca016b8c6e4b9a6a71"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d142c262159196f984860fb8e0ecd2c67792d5eaa957c35ab01ee194132f003b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d142c262159196f984860fb8e0ecd2c67792d5eaa957c35ab01ee194132f003b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d142c262159196f984860fb8e0ecd2c67792d5eaa957c35ab01ee194132f003b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7689d4a47c8bbbd10a93d1cb3a42bac429f3d87e46c2e74257357d39eb06a8f1"
    sha256 cellar: :any_skip_relocation, ventura:       "7689d4a47c8bbbd10a93d1cb3a42bac429f3d87e46c2e74257357d39eb06a8f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0200548cf54ed11f0980cebb0c1e7d4ae8041ab3509a4dda6d7b917c1e642112"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0765797964e555ac3663593a0d0e2f1e26e2e67c298c60ee7867ab20a3ac3df7"
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
