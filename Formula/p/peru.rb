class Peru < Formula
  include Language::Python::Virtualenv

  desc "Dependency retriever for version control and archives"
  homepage "https://github.com/buildinspace/peru"
  url "https://files.pythonhosted.org/packages/fe/0e/b78315545923029f18669d083826bc59a12006cd3bc430c8141f896310cc/peru-1.3.2.tar.gz"
  sha256 "161d9fd85d8d37ef10eed1d8b38da126d7ba9554b585e40ed2964138fc3b2f00"
  license "MIT"

  bottle do
    rebuild 5
    sha256 cellar: :any,                 arm64_sequoia:  "3cd2c85ee4ff5e5c7efef1ecd933842b70851cfb25858e800389658978720fae"
    sha256 cellar: :any,                 arm64_sonoma:   "6bbfa6021acb4de8dc1031932083f0e0ca2acc3296dec9dd87c9e77e389d9d49"
    sha256 cellar: :any,                 arm64_ventura:  "8dade0a9d43215a49d727c92312ca7bfa777ce0f4e91dea0c98944abee794ed3"
    sha256 cellar: :any,                 arm64_monterey: "806150274ee7f2e12348d7025968174a01c12cf4da437fa6c1ae191fc8e19136"
    sha256 cellar: :any,                 sonoma:         "5b2f8e9640bf44828878d727ec08acc4d4aa74fc07dd2cb9819c395491950fb4"
    sha256 cellar: :any,                 ventura:        "73263481f1bd20dd689d255565e8c93a5c86e9475a86922af76cb83634910e04"
    sha256 cellar: :any,                 monterey:       "c70dc90087a362d3c131be4b2a54a14cc9f1c21828433ef73c5e2ed1d125a44e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52fdcc8015a74fbb3c94714c8113f53cc1ede04a363044f2392a2af9990076b8"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    # Fix plugins (executed like an executable) looking for Python outside the virtualenv
    Dir["peru/resources/plugins/**/*.py"].each do |f|
      inreplace f, "#! /usr/bin/env python3", "#!#{libexec}/bin/python3.12"
    end

    virtualenv_install_with_resources
  end

  test do
    (testpath/"peru.yaml").write <<~EOS
      imports:
        peru: peru
      git module peru:
        url: https://github.com/buildinspace/peru.git
    EOS
    system bin/"peru", "sync"
    assert_predicate testpath/".peru", :exist?
    assert_predicate testpath/"peru", :exist?
  end
end
