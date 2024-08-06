class VaultCli < Formula
  desc "Subversion-like utility to work with Jackrabbit FileVault"
  homepage "https://jackrabbit.apache.org/filevault/index.html"
  url "https://search.maven.org/remotecontent?filepath=org/apache/jackrabbit/vault/vault-cli/3.8.0/vault-cli-3.8.0-bin.tar.gz"
  sha256 "ecc0f14c1d92481236d72f9fdd044121a5d9e9fdbf10471b25492cf97ea6303f"
  license "Apache-2.0"
  head "https://github.com/apache/jackrabbit-filevault.git", branch: "master"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/apache/jackrabbit/vault/vault-cli/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "5ab48cb5bfcb928892edc54c09b0e401fdb3d69c2ad4a6db9df843867370e25e"
  end

  depends_on "openjdk"

  def install
    # Remove windows files
    rm(Dir["bin/*.bat"])

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix)
  end

  test do
    # Bad test, but we're limited without a Jackrabbit repo to speak to...
    system bin/"vlt", "--version"
  end
end
