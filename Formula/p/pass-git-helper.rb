class PassGitHelper < Formula
  include Language::Python::Virtualenv

  desc "Git credential helper interfacing with pass"
  homepage "https://github.com/languitar/pass-git-helper"
  url "https://github.com/languitar/pass-git-helper/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "3b0cda7a5eae2e93cc1ccec0ea02716db5a2ce3105c6d631f20fa20152b7a163"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7abf528867c4773880eeaf96a61583677c6df91d1d33cb6260851995f0977f2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7abf528867c4773880eeaf96a61583677c6df91d1d33cb6260851995f0977f2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7abf528867c4773880eeaf96a61583677c6df91d1d33cb6260851995f0977f2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "161f83037615891ef298cf97940553757ed09c84da60a404c509b08a9b270101"
    sha256 cellar: :any_skip_relocation, ventura:        "161f83037615891ef298cf97940553757ed09c84da60a404c509b08a9b270101"
    sha256 cellar: :any_skip_relocation, monterey:       "161f83037615891ef298cf97940553757ed09c84da60a404c509b08a9b270101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e320b0f7dcf2d5ecdc49312d2504817267b4bbf3b17a02c0aeb06b37f5e7a6e"
  end

  depends_on "gnupg" => :test
  depends_on "pass"
  depends_on "python@3.12"

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Generate temporary GPG key for use with pass
    pipe_output("#{Formula["gnupg"].opt_bin}/gpg --generate-key --batch", <<~EOS, 0)
      %no-protection
      %transient-key
      Key-Type: RSA
      Name-Real: Homebrew Test
    EOS

    system "pass", "init", "Homebrew Test"

    pipe_output("pass insert -m -f homebrew/pass-git-helper-test", <<~EOS, 0)
      test_password
      test_username
    EOS

    (testpath/"config.ini").write <<~EOS
      [github.com*]
      target=homebrew/pass-git-helper-test
    EOS

    result = pipe_output("#{bin}/pass-git-helper -m #{testpath}/config.ini get", <<~EOS, 0)
      protocol=https
      host=github.com
      path=homebrew/homebrew-core
    EOS

    assert_match "password=test_password\nusername=test_username", result
  end
end
