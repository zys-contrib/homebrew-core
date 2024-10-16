class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek peer-to-peer network"
  homepage "https://nicotine-plus.org"
  url "https://files.pythonhosted.org/packages/5a/d3/a489967ab67165a6893f23e03c5134cf1b9cd35fd826c0a7c9ea3c743cb9/nicotine_plus-3.3.6.tar.gz"
  sha256 "6a0b39c5ff4fb4768689516a3a2cfe3aafdc568b5237f19553c51b1de712ee66"
  license "GPL-3.0-or-later"
  head "https://github.com/nicotine-plus/nicotine-plus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0214a718bc6c2b9c4ea4e017ce586a8c0c23adc0f223b5ce32f1d96b75c3530"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0214a718bc6c2b9c4ea4e017ce586a8c0c23adc0f223b5ce32f1d96b75c3530"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0214a718bc6c2b9c4ea4e017ce586a8c0c23adc0f223b5ce32f1d96b75c3530"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0214a718bc6c2b9c4ea4e017ce586a8c0c23adc0f223b5ce32f1d96b75c3530"
    sha256 cellar: :any_skip_relocation, ventura:       "d0214a718bc6c2b9c4ea4e017ce586a8c0c23adc0f223b5ce32f1d96b75c3530"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67745151b15f23707214562a009840c9d64c133e8c22f48fc04774beafa1de85"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk4"
  depends_on "libadwaita"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.13"

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
