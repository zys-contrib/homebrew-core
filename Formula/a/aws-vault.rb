class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.4.0.tar.gz"
  sha256 "595aa99882f4e577fa68f1d45de76e87362cf5b1582782992734ba82afb706e9"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "795b4e0fe692a302583766bae8744837dbeda4798a9e04f4f3a8cc4b2a5ac20d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a14b68a9d51cdd636b80a7f3872045065c10753016189471fe8c4bb56d45ff1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "222ef59f731e75e9adb0d882736f42ed4432764f398384e91de28709822982be"
    sha256 cellar: :any_skip_relocation, sonoma:        "60d91ad4cc42857e7a83d10fd6586fb5186026ecf4bc0fa3a14e0f88bc6f759d"
    sha256 cellar: :any_skip_relocation, ventura:       "245dda7e1d4c0cdc6ce0c151895c743a33e739bcd73ab34ca6418fe4e5e3594b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c634aab3ab73dab7675c1b964f8959fd365737a7bab998b3a2f162442de153b"
  end

  depends_on "go" => :build

  def install
    # Remove this line because we don't have a certificate to code sign with
    inreplace "Makefile",
      "codesign --options runtime --timestamp --sign \"$(CERT_ID)\" $@", ""
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s

    system "make", "aws-vault-#{os}-#{arch}", "VERSION=#{version}-#{tap.user}"
    system "make", "install", "INSTALL_DIR=#{bin}", "VERSION=#{version}-#{tap.user}"

    zsh_completion.install "contrib/completions/zsh/aws-vault.zsh" => "_aws-vault"
    bash_completion.install "contrib/completions/bash/aws-vault.bash" => "aws-vault"
    fish_completion.install "contrib/completions/fish/aws-vault.fish"
  end

  test do
    assert_match("aws-vault: error: login: argument 'profile' not provided, nor any AWS env vars found. Try --help",
      shell_output("#{bin}/aws-vault --backend=file login 2>&1", 1))

    assert_match version.to_s, shell_output("#{bin}/aws-vault --version 2>&1")
  end
end
