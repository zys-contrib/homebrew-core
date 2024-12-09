class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://github.com/pimalaya/himalaya"
  url "https://github.com/pimalaya/himalaya/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "2f16737d4ff29b8495979045abb94723b684b200b98cab27ae45f8b270da5b9c"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "430d3049a25fdee8c6d38f80f0d2ef8103108d10ad81da506c2411caaf37cff1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f39d7f7e22b4baab36d1f4c659624dce597812b171b89d421ae91d631117c638"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d23ecffec7b5be31097be6e9f1049c669ca8d490e0a740a5066aa5319d1d55a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dde1d0e5189c39327b5d9f822cc0bfbe6052881933741ac5f11925efd8db45d"
    sha256 cellar: :any_skip_relocation, sonoma:         "be468d9901621711cf7a45ecab8f7521216aa419a229e886ce21844315ca28c5"
    sha256 cellar: :any_skip_relocation, ventura:        "82b5bf9621d0785b49d14362d7bf933ef163acbc9740184f60dc3b7961019737"
    sha256 cellar: :any_skip_relocation, monterey:       "87ed060405e6243d47b0a93acae318c702b248c29041359d482b3efb0cb1e573"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "401182fcfee72d5ef3a1c42204dbd71687c3c17586bb2ac2e87fc158aa496d85"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    system bin/"himalaya", "man", buildpath
    man1.install Dir["*.1"]
    generate_completions_from_executable(bin/"himalaya", "completion")
  end

  test do
    # See https://github.com/pimalaya/himalaya#configuration
    (testpath/".config/himalaya/config.toml").write <<~TOML
      [accounts.gmail]
      default = true
      email = "example@gmail.com"

      folder.alias.inbox = "INBOX"
      folder.alias.sent = "[Gmail]/Sent Mail"
      folder.alias.drafts = "[Gmail]/Drafts"
      folder.alias.trash = "[Gmail]/Trash"

      backend.type = "imap"
      backend.host = "imap.gmail.com"
      backend.port = 993
      backend.login = "example@gmail.com"
      backend.auth.type = "password"
      backend.auth.raw = "*****"

      message.send.backend.type = "smtp"
      message.send.backend.host = "smtp.gmail.com"
      message.send.backend.port = 465
      message.send.backend.login = "example@gmail.com"
      message.send.backend.auth.type = "password"
      message.send.backend.auth.cmd = "*****"
    TOML

    assert_match "cannot authenticate to IMAP server", shell_output(bin/"himalaya 2>&1", 1)
  end
end
