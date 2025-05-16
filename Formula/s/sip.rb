class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://python-sip.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/e3/11/1ad8d00e08f26eaa45c48c085b8fdb6aba32b5c96e601d96b4b821a5b88e/sip-6.11.0.tar.gz"
  sha256 "237d24ead97a5ef2e8c06521dd94c38626e43702a2984c8a2843d7e67f07e799"
  license "BSD-2-Clause"
  head "https://github.com/Python-SIP/sip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2ee78b3a93a1f0ae7469573129b6fc6cf2c940fdff3167fdccb8a5ec4c52e45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2ee78b3a93a1f0ae7469573129b6fc6cf2c940fdff3167fdccb8a5ec4c52e45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2ee78b3a93a1f0ae7469573129b6fc6cf2c940fdff3167fdccb8a5ec4c52e45"
    sha256 cellar: :any_skip_relocation, sonoma:        "66616e4055c5d84151c5f985b4fe76e6df1b73745199b904e7ac31fab60b2617"
    sha256 cellar: :any_skip_relocation, ventura:       "66616e4055c5d84151c5f985b4fe76e6df1b73745199b904e7ac31fab60b2617"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5023f74a18936d667bd5899310ef260882732dfccfbcb477f2a791e34b4f06d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12654418be62fe1ac65a57450710c5f9b5166056859601786c458d0d4ad62424"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/9e/8b/dc1773e8e5d07fd27c1632c45c1de856ac3dbf09c0147f782ca6d990cf15/setuptools-80.7.1.tar.gz"
    sha256 "f6ffc5f0142b1bd8d0ca94ee91b30c0ca862ffd50826da1ea85258a06fd94552"
  end

  def python3
    "python3.13"
  end

  def install
    venv = virtualenv_install_with_resources

    # Modify the path sip-install writes in scripts as we install into a
    # virtualenv but expect dependents to run with path to Python formula
    inreplace venv.site_packages/"sipbuild/builder.py", /\bsys\.executable\b/, "\"#{which(python3)}\""
  end

  test do
    (testpath/"pyproject.toml").write <<~TOML
      # Specify sip v6 as the build system for the package.
      [build-system]
      requires = ["sip >=6, <7"]
      build-backend = "sipbuild.api"

      # Specify the PEP 566 metadata for the project.
      [tool.sip.metadata]
      name = "fib"
    TOML

    (testpath/"fib.sip").write <<~EOS
      // Define the SIP wrapper to the (theoretical) fib library.

      %Module(name=fib, language="C")

      int fib_n(int n);
      %MethodCode
          if (a0 <= 0)
          {
              sipRes = 0;
          }
          else
          {
              int a = 0, b = 1, c, i;

              for (i = 2; i <= a0; i++)
              {
                  c = a + b;
                  a = b;
                  b = c;
              }

              sipRes = b;
          }
      %End
    EOS

    system bin/"sip-install", "--target-dir", "."
  end
end
