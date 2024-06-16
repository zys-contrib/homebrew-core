class PythonArgcomplete < Formula
  desc "Tab completion for Python argparse"
  homepage "https://kislyuk.github.io/argcomplete/"
  url "https://files.pythonhosted.org/packages/db/ca/45176b8362eb06b68f946c2bf1184b92fc98d739a3f8c790999a257db91f/argcomplete-3.4.0.tar.gz"
  sha256 "c2abcdfe1be8ace47ba777d4fce319eb13bf8ad9dace8d085dcad6eded88057f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08ecddcc6ecfc2a1ec110d8efa624fc79c318a6a9bdb2edcc14f01ce2fc09c12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08ecddcc6ecfc2a1ec110d8efa624fc79c318a6a9bdb2edcc14f01ce2fc09c12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08ecddcc6ecfc2a1ec110d8efa624fc79c318a6a9bdb2edcc14f01ce2fc09c12"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a5567dc2589a6c49ef16044772068e4525e0e9cab27f1e69120df38608ed157"
    sha256 cellar: :any_skip_relocation, ventura:        "3a5567dc2589a6c49ef16044772068e4525e0e9cab27f1e69120df38608ed157"
    sha256 cellar: :any_skip_relocation, monterey:       "3a5567dc2589a6c49ef16044772068e4525e0e9cab27f1e69120df38608ed157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c0dc8fc3dfd26c42c588f409d0a2e2bd4ca7180291917b3af5e5f124eb40240"
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
