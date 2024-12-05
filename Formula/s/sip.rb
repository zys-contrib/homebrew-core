class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://python-sip.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/b8/dc/17b69b375103aa3db633b3f1f46bf7030cbe516b2b6d5dc73b7668a7840d/sip-6.9.0.tar.gz"
  sha256 "093fd0e15d99ae2f8a83dd7f7dbaa3ff250c582a77eb8e0845cd9acadb1f0934"
  license "BSD-2-Clause"
  head "https://github.com/Python-SIP/sip.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dcb80371d8d2a7e940566060a8808cd6debcc403ab46b75e605715be8f775b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dcb80371d8d2a7e940566060a8808cd6debcc403ab46b75e605715be8f775b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1dcb80371d8d2a7e940566060a8808cd6debcc403ab46b75e605715be8f775b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e1e1de1fa68a594442699d1ad606342b5acc01441d3011d6908abe02604d985"
    sha256 cellar: :any_skip_relocation, ventura:       "7e1e1de1fa68a594442699d1ad606342b5acc01441d3011d6908abe02604d985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "231c036c97e370aa86a8a80c3fb1720a05f0a13d5f6cc62edf048764dd90c8a7"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/43/54/292f26c208734e9a7f067aea4a7e282c080750c4546559b58e2e45413ca0/setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
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
