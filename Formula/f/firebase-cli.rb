class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.23.0.tgz"
  sha256 "9aca257a16e3a548b049c550da3ecaa64cde2de2c56cfe7316a8079376bf8e1c"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27871d2f7bc6ff5d7b2ae0ee76ca99d81c10f8170fab92e939e0e4aebd37a96d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27871d2f7bc6ff5d7b2ae0ee76ca99d81c10f8170fab92e939e0e4aebd37a96d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27871d2f7bc6ff5d7b2ae0ee76ca99d81c10f8170fab92e939e0e4aebd37a96d"
    sha256 cellar: :any_skip_relocation, sonoma:        "427cb68226c763e2f8de38dd1adf29f340d4b4fff1452b8376a4b61d79b47026"
    sha256 cellar: :any_skip_relocation, ventura:       "427cb68226c763e2f8de38dd1adf29f340d4b4fff1452b8376a4b61d79b47026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf320d687a4414d2cd85f2fb33f9717758403706f75cd3f55d0e07a234b05cc8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "Failed to authenticate", shell_output("#{bin}/firebase init", 1)
    output = pipe_output("#{bin}/firebase login:ci --interactive --no-localhost", "dummy-code")
    assert_match "Unable to authenticate", output
  end
end
