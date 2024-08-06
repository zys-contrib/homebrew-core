class PythonArgcomplete < Formula
  desc "Tab completion for Python argparse"
  homepage "https://kislyuk.github.io/argcomplete/"
  url "https://files.pythonhosted.org/packages/75/33/a3d23a2e9ac78f9eaf1fce7490fee430d43ca7d42c65adabbb36a2b28ff6/argcomplete-3.5.0.tar.gz"
  sha256 "4349400469dccfb7950bb60334a680c58d88699bff6159df61251878dc6bf74b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07df70afc5bb6657621f4abbc73e9e7551304351d143522765eadc344d1b0f3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07df70afc5bb6657621f4abbc73e9e7551304351d143522765eadc344d1b0f3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07df70afc5bb6657621f4abbc73e9e7551304351d143522765eadc344d1b0f3b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6824b76b28905b51384f14a7276daff155b46a51ba644a380dd7e371dec0303"
    sha256 cellar: :any_skip_relocation, ventura:        "e6824b76b28905b51384f14a7276daff155b46a51ba644a380dd7e371dec0303"
    sha256 cellar: :any_skip_relocation, monterey:       "e6824b76b28905b51384f14a7276daff155b46a51ba644a380dd7e371dec0303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4aec45f613013f2771765f7c54b4910430450080b7b29c29e17f4d5a15c4df45"
  end

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end

    # Bash completions are not compatible with Bash 3 so don't use v1 directory.
    # Ref: https://kislyuk.github.io/argcomplete/#global-completion
    bash_completion_script = "argcomplete/bash_completion.d/_python-argcomplete"
    (share/"bash-completion/completions").install bash_completion_script => "python-argcomplete"
    zsh_completion.install_symlink bash_completion/"python-argcomplete" => "_python-argcomplete"
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import argcomplete"
    end

    output = shell_output("#{bin}/register-python-argcomplete foo")
    assert_match "_python_argcomplete foo", output
  end
end
