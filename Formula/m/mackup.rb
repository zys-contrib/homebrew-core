class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://files.pythonhosted.org/packages/63/37/8f5ee72905948757f284e7a4fea1cd8b7203f13e57d2cf4917f2f1afa7a8/mackup-0.8.41.tar.gz"
  sha256 "49f929d502b3efbc01b5a206af6cff877447ac5821591b2a9231cbf42d97b17a"
  license "GPL-3.0-or-later"
  head "https://github.com/lra/mackup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc14c837232b9c9dd70ade93c1b4e87a8c3b14894068b2c7ef069cbf85a3a285"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f85cb462956cb44fbcc163351cc337d4c604c248d3769359c6ba45446b1e4cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e65aae58b535dec8f5fe474af3f5447140e4d63f780e782d7d1e84e6c293e614"
    sha256 cellar: :any_skip_relocation, sonoma:         "b08c9e2302a4aca64afbf33b785ca7eae1e8f661c386df4d834f6085ae9b46d8"
    sha256 cellar: :any_skip_relocation, ventura:        "559b8c878159dd5dc347dd363b2cf0503a6f2c7565e76f7c0da437ca98cbf05a"
    sha256 cellar: :any_skip_relocation, monterey:       "c3078cd965e01f1985ad53131537efaf56980d3605ed332fd7a674a285dd16b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9086360c6fa35cfe3e9b03ecce6e96ccf8fbb0b0babd8e157cc108a091f9f974"
  end

  depends_on "python@3.12"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mackup", "--help"
  end
end
