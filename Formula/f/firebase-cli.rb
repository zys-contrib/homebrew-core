class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.15.4.tgz"
  sha256 "1fe100e409d7674557470ac570bd9e3b7b94fba50825f291817c089b312b122d"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9ad606a1c7cbb36770636f4d5d91c646af09df1014eebb8d7889279b425eb21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9ad606a1c7cbb36770636f4d5d91c646af09df1014eebb8d7889279b425eb21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9ad606a1c7cbb36770636f4d5d91c646af09df1014eebb8d7889279b425eb21"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a9c2b8a6c82ee6b86b68e8d799dc65af8d918334938a2dac303f221d53f295a"
    sha256 cellar: :any_skip_relocation, ventura:        "2a9c2b8a6c82ee6b86b68e8d799dc65af8d918334938a2dac303f221d53f295a"
    sha256 cellar: :any_skip_relocation, monterey:       "2a9c2b8a6c82ee6b86b68e8d799dc65af8d918334938a2dac303f221d53f295a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a1f51a2900121889a69f1f5a81772cd2f3ba6250a2eaff06ecfa4f0be5db64a"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end
