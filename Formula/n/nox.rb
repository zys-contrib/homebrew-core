class Nox < Formula
  include Language::Python::Virtualenv

  desc "Flexible test automation for Python"
  homepage "https://nox.thea.codes/"
  url "https://files.pythonhosted.org/packages/1e/86/b86fc26784d2f63d038b4efc9e18d4d807ec025569da66c6d032b8f717df/nox-2024.4.15.tar.gz"
  version "2024.04.15"
  sha256 "ecf6700199cdfa9e5ea0a41ff5e6ef4641d09508eda6edb89d9987864115817f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e99c5aa725861fb3af5051d6203597dda5b842559ebdbfb01e410dd173a49bfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4125816ab344b179b2ab09b3f392a75efa1c8e7fc6acb44a30709b9d31f2c94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4125816ab344b179b2ab09b3f392a75efa1c8e7fc6acb44a30709b9d31f2c94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4125816ab344b179b2ab09b3f392a75efa1c8e7fc6acb44a30709b9d31f2c94"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bcbd553a4a0ecc80173c998a94561fe5456531a330c19203f9b5cff5288388d"
    sha256 cellar: :any_skip_relocation, ventura:        "5bcbd553a4a0ecc80173c998a94561fe5456531a330c19203f9b5cff5288388d"
    sha256 cellar: :any_skip_relocation, monterey:       "5bcbd553a4a0ecc80173c998a94561fe5456531a330c19203f9b5cff5288388d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "092e78bcaf5222fed54a3f3be554d616707b4f68d9df72c929272dbb50599a1b"
  end

  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/5f/39/27605e133e7f4bb0c8e48c9a6b87101515e3446003e0442761f6a02ac35e/argcomplete-3.5.1.tar.gz"
    sha256 "eb1ee355aa2557bd3d0145de7b06b2a45b0ce461e1e7813f5d066039ab4177b4"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/db/38/2992ff192eaa7dd5a793f8b6570d6bbe887c4fbbf7e72702eb0a693a01c8/colorlog-6.8.2.tar.gz"
    sha256 "3e3e079a41feb5a1b64f978b5ea4f46040a94f11f0e8bbb8261e3dbbeca64d44"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/0d/dd/1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02d/distlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/9d/db/3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1/filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/3f/40/abc5a766da6b0b2457f819feab8e9203cbeae29327bd241359f866a3da9d/virtualenv-20.26.6.tar.gz"
    sha256 "280aede09a2a5c317e409a00102e7077c6432c5a38f0ef938e643805a7ad2c48"
  end

  def install
    virtualenv_install_with_resources
    (bin/"tox-to-nox").unlink
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"noxfile.py").write <<~EOS
      import nox

      @nox.session
      def tests(session):
          session.install("pytest")
          session.run("pytest")
    EOS
    (testpath/"test_trivial.py").write <<~EOS
      def test_trivial():
          assert True
    EOS
    assert_match "usage", shell_output("#{bin}/nox --help")
    assert_match "Sessions defined in #{testpath}/noxfile.py", shell_output("#{bin}/nox --list-sessions")
  end
end
