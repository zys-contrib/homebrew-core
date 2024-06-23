class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/24/e1/6428a1781bb116fa1d61d7173a51c7f2463390a311ea8db2f6c251c4696b/you_get-0.4.1710.tar.gz"
  sha256 "ecd309e308d3412b970869f6e976d2f8381b1b0888e051aa6c41c9be7e6a3dcc"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44db7e8ed6b8cd539df6e9eb8323dee1d1f8dcafcc2e3df4b120bf45d04f52cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5be0e99a1242bf98bdee82387986568089d405cae42f3f5eccda511038ae34da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "027883df0ea0e7ee7ce198d29d9bc9f25a35c77cb23a1d0368e372872c03d223"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8915d2d55f9efd64fc2d92ca1c03416f3c60048c170ad773de57c52d360f007"
    sha256 cellar: :any_skip_relocation, ventura:        "7be679382bbf7ea9fe0104dbc5947b320040ae46e1964c91a50be1018c56ffd7"
    sha256 cellar: :any_skip_relocation, monterey:       "f21f40a5f4bc7bf8a50eabecea4fed5dcefe9d8db466e6cb3c4e6031d23f4430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37ad289e626860506fa04e4758dec81146ebdf42027d6a9177547f66228c6f2a"
  end

  depends_on "python@3.12"
  depends_on "rtmpdump"

  resource "dukpy" do
    url "https://files.pythonhosted.org/packages/d1/0b/402194ebcd92bb5a743106c0f4af8cf6fc75bcfeb441b90290accb197745/dukpy-0.4.0.tar.gz"
    sha256 "677ec7102d1c1c511f7ef918078e8099778dbcea7caf3d6a2a2a72f72aa2d135"
  end

  resource "mutf8" do
    url "https://files.pythonhosted.org/packages/ca/31/3c57313757b3a47dcf32d2a9bad55d913b797efc8814db31bed8a7142396/mutf8-1.0.6.tar.gz"
    sha256 "1bbbefb67c2e5a57104750bb04b0912200b57b2fa9841be245279e83859cb346"
  end

  # add missing completion files, upstream pr ref, https://github.com/soimort/you-get/pull/3025
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/a2a66d33d00a04307ab87e78c3f81061ecefef0f/you-get/you_get-0.4.1710-missing-file.patch"
    sha256 "b8b55f43f29986e7ba408135aff48abf091f916526b40ce097eda2db71aa17c7"
  end

  def install
    virtualenv_install_with_resources
    bash_completion.install "contrib/completion/you-get-completion.bash" => "you-get"
    fish_completion.install "contrib/completion/you-get.fish"
    zsh_completion.install "contrib/completion/_you-get"
  end

  def caveats
    "To use post-processing options, run `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system bin/"you-get", "--info", "https://youtu.be/he2a4xK8ctk"

    assert_match version.to_s, shell_output("#{bin}/you-get --version 2>&1")
  end
end
