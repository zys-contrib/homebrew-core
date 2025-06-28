class GitlabGem < Formula
  desc "Ruby client and CLI for GitLab API"
  homepage "https://narkoz.github.io/gitlab/"
  url "https://github.com/NARKOZ/gitlab/archive/refs/tags/v6.0.0.tar.gz"
  sha256 "dfafb3b2ddaaaa94b78da5e2cb7515199160def567cb936606a5dae9e270a9b7"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "05f1b0962f1cdc0ba8325a1cb2161aad2fb2c2d93c144c1efd8aa861b7faac12"
    sha256 cellar: :any,                 arm64_sonoma:  "040dfa582c413b0c51cedffc28d3edc5d5482b4c3584e1553fb31fbb9c76ad9e"
    sha256 cellar: :any,                 arm64_ventura: "46f87e54a723b07f5813a32f9d5391c471a6384929e4a1880cf27a864d55543d"
    sha256 cellar: :any,                 sonoma:        "7d01617823ef02f76e5ef3ca2f31fbdc07c78c0ecb93fa89b2cad893971851e3"
    sha256 cellar: :any,                 ventura:       "c1b354fab666cfffd496156c33b9a8c0bafb5ed371bcf9b1ffdd6ddab30e015d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a918b915390e04f92d147cf55f8eeded8af49ffb3fb891fa98ae1b14c787b4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f059f0148490b7eaffb7a619c8c7cb146b511defea2b4c9d146c68b68e2da7e4"
  end

  depends_on "ruby"

  # list with `gem install --explain httparty terminal-table`

  resource "bigdecimal" do
    url "https://rubygems.org/gems/bigdecimal-3.1.8.gem"
    sha256 "a89467ed5a44f8ae01824af49cbc575871fa078332e8f77ea425725c1ffe27be"
  end

  resource "multi_xml" do
    url "https://rubygems.org/gems/multi_xml-0.7.2.gem"
    sha256 "307a96dc48613badb7b2fc174fd4e62d7c7b619bc36ea33bfd0c49f64f5787ce"
  end

  resource "mini_mime" do
    url "https://rubygems.org/gems/mini_mime-1.1.5.gem"
    sha256 "8681b7e2e4215f2a159f9400b5816d85e9d8c6c6b491e96a12797e798f8bccef"
  end

  resource "csv" do
    url "https://rubygems.org/gems/csv-3.3.2.gem"
    sha256 "6ff0c135e65e485d1864dde6c1703b60d34cc9e19bed8452834a0b28a519bd4e"
  end

  resource "httparty" do
    url "https://rubygems.org/gems/httparty-0.23.1.gem"
    sha256 "3ac1dd62f2010f6ece551716f5ceec2b2012011d89f1751917ab7f724e966b55"
  end

  resource "unicode-emoji" do
    url "https://rubygems.org/gems/unicode-emoji-4.0.4.gem"
    sha256 "2c2c4ef7f353e5809497126285a50b23056cc6e61b64433764a35eff6c36532a"
  end

  resource "unicode-display_width" do
    url "https://rubygems.org/gems/unicode-display_width-3.1.4.gem"
    sha256 "8caf2af1c0f2f07ec89ef9e18c7d88c2790e217c482bfc78aaa65eadd5415ac1"
  end

  resource "terminal-table" do
    url "https://rubygems.org/gems/terminal-table-4.0.0.gem"
    sha256 "f504793203f8251b2ea7c7068333053f0beeea26093ec9962e62ea79f94301d2"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "gitlab.gemspec"
    system "gem", "install", "--ignore-dependencies", "gitlab-#{version}.gem"
    (bin/"gitlab").write_env_script libexec/"bin/gitlab", GEM_HOME: ENV["GEM_HOME"]
  end

  test do
    ENV["GITLAB_API_ENDPOINT"] = "https://example.com/"
    ENV["GITLAB_API_PRIVATE_TOKEN"] = "token"
    output = shell_output("#{bin}/gitlab user 2>&1", 1)
    assert_match "Server responded with code 404, message", output

    assert_match version.to_s, shell_output("#{bin}/gitlab --version")
  end
end
