class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek peer-to-peer network"
  homepage "https://nicotine-plus.org"
  url "https://files.pythonhosted.org/packages/0e/73/ba597ab69a24106e0ba44eef0346116f37842b8273d357a46ad2d05cc729/nicotine_plus-3.3.5.tar.gz"
  sha256 "e0c9d650606a9f9eab8e5c2b7fd560ddb5cfe475ea4c22f19b833d7ebf86ba43"
  license "GPL-3.0-or-later"
  head "https://github.com/nicotine-plus/nicotine-plus.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ffb1a2659bff33e864b545b329c3af2ed20d7463f17f1e89b17061a8c039fed6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee66410a793440590408fc0524157aa98814d693bcf5173321eee17ed31bbf29"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee66410a793440590408fc0524157aa98814d693bcf5173321eee17ed31bbf29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee66410a793440590408fc0524157aa98814d693bcf5173321eee17ed31bbf29"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee66410a793440590408fc0524157aa98814d693bcf5173321eee17ed31bbf29"
    sha256 cellar: :any_skip_relocation, ventura:        "ee66410a793440590408fc0524157aa98814d693bcf5173321eee17ed31bbf29"
    sha256 cellar: :any_skip_relocation, monterey:       "ee66410a793440590408fc0524157aa98814d693bcf5173321eee17ed31bbf29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "603be73b6c65bf171d66df59924bb95264b65836e32a69e0a8c523dd5d076207"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk4"
  depends_on "libadwaita"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.12"

  on_linux do
    depends_on "gettext" => :build # for `msgfmt`
  end

  conflicts_with "httm", because: "both install `nicotine` binaries"

  def install
    virtualenv_install_with_resources
  end

  test do
    # nicotine is a GUI app
    assert_match version.to_s, shell_output("#{bin}/nicotine --version")
  end
end
