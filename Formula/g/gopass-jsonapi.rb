class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/archive/refs/tags/v1.15.14.tar.gz"
  sha256 "2ff6a1b03d5b7befe81d6465990ea5b13b9ad052d6c9cf1638b795767307d9ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a32069959f87ea8b742aae64d590c4c2e6467a8731aa1275cff79fe54bad048"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4286a43f346997246b95ab7f346a881294aa2d09676d98a619b7c7db78978da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47be53a5aa5d51f16d8c84d99fe3ba6da6364e446049652588aec8bd274e4684"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b3b3e84cc592874587cdf5b54c55eb1ca8473524d1ccb0c7996237444dee13e"
    sha256 cellar: :any_skip_relocation, ventura:        "931b2ab8d3bce8f579f1dfe858b159762c92a79f9a25702bbcaded55213215b1"
    sha256 cellar: :any_skip_relocation, monterey:       "a37180430d7f20da329a708c515c8c9bfb881958a46e3b6afe0ef19187b37779"
  end

  depends_on "go" => :build
  depends_on "gopass"

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS

    begin
      system Formula["gnupg"].opt_bin/"gpg", "--batch", "--gen-key", "batch.gpg"

      system Formula["gopass"].opt_bin/"gopass", "init", "--path", testpath, "noop", "testing@foo.bar"
      system Formula["gopass"].opt_bin/"gopass", "generate", "Email/other@foo.bar", "15"
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
      system Formula["gnupg"].opt_bin/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end

    assert_match(/^gopass-jsonapi version #{version}$/, shell_output("#{bin}/gopass-jsonapi --version"))

    msg = '{"type": "query", "query": "foo.bar"}'
    assert_match "Email/other@foo.bar",
      pipe_output("#{bin}/gopass-jsonapi listen", "#{[msg.length].pack("L<")}#{msg}")
  end
end
