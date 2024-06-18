class GitReview < Formula
  include Language::Python::Virtualenv

  desc "Submit git branches to gerrit for review"
  homepage "https://opendev.org/opendev/git-review"
  url "https://files.pythonhosted.org/packages/79/ae/1c161f8914731ca5a5b3ce0784f5bc47d9a68f4ce33123d431bf30fc90b6/git-review-2.4.0.tar.gz"
  sha256 "a350eaa9c269a1fe3177a5ffd4ae76f2b604e1af122eb0de08ab07252001722a"
  license "Apache-2.0"
  revision 3
  head "https://opendev.org/opendev/git-review.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9b700a7bacfa7d535af80febc4ae560134d6cda44bdc657911d8dfa0e2fa9c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0913c4eb91a52c19366903f290ce67291087d39a197fc4c248d588470d63c77b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6bea46cd44b0517bcb8f5886a6362e0197924b49d56f2621e07440d00ad91e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "786d384fb5e32ef99eec84cb644d66a0c1670f6abbd480c80802dd8ef2ddb8b2"
    sha256 cellar: :any_skip_relocation, ventura:        "a34122338d31b3ceb4cc1858dc6b7aa85c936805c848e19703d465aa3718a454"
    sha256 cellar: :any_skip_relocation, monterey:       "ce09901c1c4ae9e4721160bc60ca7ac56cc8cbfcd96634f75218ca2e522daa6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91807fb8e81b356675d65481a19b6a9aa47cbc29f56237357619a575236d88fa"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "git", "remote", "add", "gerrit", "https://github.com/Homebrew/brew.sh"
    (testpath/".git/hooks/commit-msg").write "# empty - make git-review happy"
    (testpath/"foo").write "test file"
    system "git", "add", "foo"
    system "git", "commit", "-m", "test"
    system bin/"git-review", "--dry-run"
  end
end
