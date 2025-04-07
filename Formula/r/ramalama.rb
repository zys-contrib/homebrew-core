class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://github.com/containers/ramalama"
  url "https://files.pythonhosted.org/packages/ef/9e/e95e82f91b3a101d6025e30ec039a204649f7a05a79561fc0bd5c8977bf9/ramalama-0.7.3.tar.gz"
  sha256 "bd3e4913023964db99087495b058505b6f2ba3ef28e48ce6cce1f7d7eddde844"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e96223443b42de99e1794de0428979bd38a0b308b82738e8494a30a4d662dc67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e96223443b42de99e1794de0428979bd38a0b308b82738e8494a30a4d662dc67"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e96223443b42de99e1794de0428979bd38a0b308b82738e8494a30a4d662dc67"
    sha256 cellar: :any_skip_relocation, sonoma:        "26904f9bedb8b54e5e69ec20c2d481e454a4f046d2fe63ee474494563477ee20"
    sha256 cellar: :any_skip_relocation, ventura:       "26904f9bedb8b54e5e69ec20c2d481e454a4f046d2fe63ee474494563477ee20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6726ef5a6714d90d0ef2c120b6738dae4e98a47c5d5ba1f4f43bbb0bda9551c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6726ef5a6714d90d0ef2c120b6738dae4e98a47c5d5ba1f4f43bbb0bda9551c0"
  end

  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/16/0f/861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0/argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "invalidllm was not found", shell_output("#{bin}/ramalama run invalidllm 2>&1", 1)

    system bin/"ramalama", "pull", "tinyllama"
    list_output = shell_output("#{bin}/ramalama list")
    assert_match "tinyllama", list_output

    inspect_output = shell_output("#{bin}/ramalama inspect tinyllama")
    assert_match "Format: GGUF", inspect_output

    assert_match version.to_s, shell_output("#{bin}/ramalama version")
  end
end
