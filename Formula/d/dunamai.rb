class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/c2/71/7cc5ba60aabefebfaa800e18d82388b0eb48f8f0becbfa5838afe7920484/dunamai-1.21.2.tar.gz"
  sha256 "05827fb5f032f5596bfc944b23f613c147e676de118681f3bb1559533d8a65c4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "681a06759eb243c5f91ffe3d3eaa3f39a741a806b9e8d9dbddc99f27f858c5ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "681a06759eb243c5f91ffe3d3eaa3f39a741a806b9e8d9dbddc99f27f858c5ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "681a06759eb243c5f91ffe3d3eaa3f39a741a806b9e8d9dbddc99f27f858c5ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "681a06759eb243c5f91ffe3d3eaa3f39a741a806b9e8d9dbddc99f27f858c5ac"
    sha256 cellar: :any_skip_relocation, ventura:        "681a06759eb243c5f91ffe3d3eaa3f39a741a806b9e8d9dbddc99f27f858c5ac"
    sha256 cellar: :any_skip_relocation, monterey:       "681a06759eb243c5f91ffe3d3eaa3f39a741a806b9e8d9dbddc99f27f858c5ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b7ec38be3720c22354fe602651d88ebd0645ad71f2fd47bc505626919f6d717"
  end

  depends_on "python@3.12"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"
    system "git", "tag", "v0.1"
    assert_equal "0.1", shell_output("#{bin}/dunamai from any").chomp
  end
end
