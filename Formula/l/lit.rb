class Lit < Formula
  desc "Portable tool for LLVM- and Clang-style test suites"
  homepage "https://llvm.org"
  url "https://files.pythonhosted.org/packages/47/b4/d7e210971494db7b9a9ac48ff37dfa59a8b14c773f9cf47e6bda58411c0d/lit-18.1.8.tar.gz"
  sha256 "47c174a186941ae830f04ded76a3444600be67d5e5fb8282c3783fba671c4edb"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f1a75ca38047f059e726925d2528f10ca5e66c207328d079088e93efe9db84e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f1a75ca38047f059e726925d2528f10ca5e66c207328d079088e93efe9db84e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f1a75ca38047f059e726925d2528f10ca5e66c207328d079088e93efe9db84e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f1a75ca38047f059e726925d2528f10ca5e66c207328d079088e93efe9db84e"
    sha256 cellar: :any_skip_relocation, ventura:        "3f1a75ca38047f059e726925d2528f10ca5e66c207328d079088e93efe9db84e"
    sha256 cellar: :any_skip_relocation, monterey:       "3f1a75ca38047f059e726925d2528f10ca5e66c207328d079088e93efe9db84e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23a33799f571ed2cb652a6ad2710fd1af8983363f8ef67b4c46a3d8304696149"
  end

  depends_on "llvm" => :test
  depends_on "python@3.12"

  def python3
    which("python3.12")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."

    # Install symlinks so that `import lit` works with multiple versions of Python
    python_versions = Formula.names
                             .select { |name| name.start_with? "python@" }
                             .map { |py| py.delete_prefix("python@") }
                             .reject { |xy| xy == Language::Python.major_minor_version(python3) }
    site_packages = Language::Python.site_packages(python3).delete_prefix("lib/")
    python_versions.each do |xy|
      (lib/"python#{xy}/site-packages").install_symlink (lib/site_packages).children
    end
  end

  test do
    ENV.prepend_path "PATH", Formula["llvm"].opt_bin

    (testpath/"example.c").write <<~EOS
      // RUN: cc %s -o %t
      // RUN: %t | FileCheck %s
      // CHECK: hello world
      #include <stdio.h>

      int main() {
        printf("hello world");
        return 0;
      }
    EOS

    (testpath/"lit.site.cfg.py").write <<~EOS
      import lit.formats

      config.name = "Example"
      config.test_format = lit.formats.ShTest(True)

      config.suffixes = ['.c']
    EOS

    system bin/"lit", "-v", "."

    if OS.mac?
      ENV.prepend_path "PYTHONPATH", prefix/Language::Python.site_packages(python3)
    else
      python = deps.reject { |d| d.build? || d.test? }
                   .find { |d| d.name.match?(/^python@\d+(\.\d+)*$/) }
                   .to_formula
      ENV.prepend_path "PATH", python.opt_bin
    end
    system python3, "-c", "import lit"
  end
end
