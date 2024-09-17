class HuggingfaceCli < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/index"
  url "https://files.pythonhosted.org/packages/81/18/52812091169325bf609feac958d5612e9c49788155a170352c7d55b6a74c/huggingface_hub-0.25.0.tar.gz"
  sha256 "fb5fbe6c12fcd99d187ec7db95db9110fb1a20505f23040a5449a717c1a0db4d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "1f06a150184b17792762d4c4104f2aeab52348fed0c6fd08a8a89a4ee28e1613"
    sha256 cellar: :any,                 arm64_sonoma:   "7bc0258dafb24af21a949ba5ec30e97a072f1234a58ba150618019a8b8e8a0eb"
    sha256 cellar: :any,                 arm64_ventura:  "064dc829c1d54a539ec8a3ea79dc9c39dd3572a1db1f9cd89ced568b343882af"
    sha256 cellar: :any,                 arm64_monterey: "e6a199063ee861a4058d9f13a7f6e03eafccb0ede0f3794655ea7c93e20d51b0"
    sha256 cellar: :any,                 sonoma:         "9737ccbb8214f42ac4714dd4ee05a48fbaf101830d7c61c946d0b366356841c5"
    sha256 cellar: :any,                 ventura:        "e8c30c252de228aa6efa0e70eaf3b77eaa64a007c3739b44fca6e04d70e456f3"
    sha256 cellar: :any,                 monterey:       "b58ffe38a2af7fc1219e2f59d21bbf411efcd2157e0a7bc0c45188c5525367e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34bd7590cfc44d5b06ba05b99cc07a5f799b5c71e2b8b6952c23dcafc562d527"
  end

  depends_on "certifi"
  depends_on "git-lfs"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/e6/76/3981447fd369539aba35797db99a8e2ff7ed01d9aa63e9344a31658b8d81/filelock-3.16.0.tar.gz"
    sha256 "81de9eb8453c769b63369f87f11131a7ab04e367f8d97ad39dc230daa07e3bec"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/62/7c/12b0943011daaaa9c35c2a2e22e5eb929ac90002f08f1259d69aedad84de/fsspec-2024.9.0.tar.gz"
    sha256 "4b0afb90c2f21832df142f292649035d80b421f60a9e1c027802e5a0da2b04e8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/58/83/6ba9844a41128c62e810fddddd72473201f3eacde02046066142a2d96cc5/tqdm-4.66.5.tar.gz"
    sha256 "e1020aef2e5096702d8a025ac7d16b1577279c9d63f8375b63083e9a5f0fcbad"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    whoami_output = shell_output("#{bin}/huggingface-cli whoami")
    assert_match "Not logged in", whoami_output
    test_cache = testpath/"cache"
    test_cache.mkdir
    ENV["HUGGINGFACE_HUB_CACHE"] = test_cache.to_s
    ENV["NO_COLOR"] = "1"
    scan_output = shell_output("#{bin}/huggingface-cli scan-cache")
    assert_match "Done in 0.0s. Scanned 0 repo(s) for a total of 0.0.", scan_output
  end
end
