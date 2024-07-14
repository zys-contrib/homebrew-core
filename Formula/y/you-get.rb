class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/09/1e/96540e807ec3b103625e9660e7a2c7a7eb9accb1b90bf85156ff50e2dfd3/you_get-0.4.1718.tar.gz"
  sha256 "78560236a4d54ad6be200d172a828e39f49c0f07c867dcf1df670c66b5b7f096"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0936c0215687f211bf847e57c0090a686412eb604a0630f1efb9e4d36fb29b38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7131263466868076f11d8b13b2a2fa00e7fcb7728896b103a91a8a508b200d13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d316dc249ff1128206102615c9038d74ea3b0658fa6660a430bfa461f612f55"
    sha256 cellar: :any_skip_relocation, sonoma:         "679e88c4c4e10cd4441e6c09ea6a91646057de10362b5802659da7b85b671f75"
    sha256 cellar: :any_skip_relocation, ventura:        "7082200b4cf6e59a5548b94b76ec61016f8d133302a69a66c13e3ebc1528a2a2"
    sha256 cellar: :any_skip_relocation, monterey:       "46be605755b6ca9d6b7d12f66fdd9bbfe4a1c375489317af6241a22a87dcfade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4465656d3df215d433be695d83a7f734e8fd3da47604b0ddf50c81a58291b64f"
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
