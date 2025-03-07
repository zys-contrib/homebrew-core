class Pgcli < Formula
  include Language::Python::Virtualenv

  desc "CLI for Postgres with auto-completion and syntax highlighting"
  homepage "https://pgcli.com/"
  url "https://files.pythonhosted.org/packages/20/6e/914150245fd7f1c249e437a567998f27b6ff22a64ca8e64cd45fc27ee31a/pgcli-4.2.0.tar.gz"
  sha256 "0d3ed9916f3bbe245c283bf484453080ff00227ab085660c6cfbb0ec53f2e9e6"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c657d33efc7892851e53c275c775bbbbb6ea59aa2cf523fb4e110f6712af23db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "373e39e041034410f039aa6549905a4d7c0a8b1acefd8dad78db59ffb2f582de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd090cf3240799480c6a4ac338123edc78f19526ebd8a4163dc2536a5ad91d75"
    sha256 cellar: :any_skip_relocation, sonoma:        "275c679e1deaa0e3a85b56adb084e5c35ccbef9dcb178445503ed39891e3483a"
    sha256 cellar: :any_skip_relocation, ventura:       "4c47d7991b1bc788570907081d3173175554d24e6b7abd3360a9081f29b247a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21c8a7c3ba2ea63fd1e11b21e3f3a16e805ec03e7857e6e59c46ece259354853"
  end

  depends_on "libpq"
  depends_on "python@3.13"

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/ab/de/79529bd31c1664415d9554c0c5029f2137afe9808f35637bbcca977d9022/cli_helpers-2.3.1.tar.gz"
    sha256 "b82a8983ceee21f180e6fd0ddb7ca8dae43c40e920951e3817f996ab204dae6a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "pgspecial" do
    url "https://files.pythonhosted.org/packages/b6/bd/21d05caf4c66b87abb4f1a7340ac2596f10087e9f60b95c84369febcf377/pgspecial-2.1.3.tar.gz"
    sha256 "6d4d2316aff7d47954db99d4c391d6c0bb26568ebcb9d151f65dab7938b6cbe2"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/e1/bd15cb8ffdcfeeb2bdc215de3c3cffca11408d829e4b8416dcfe71ba8854/prompt_toolkit-3.0.50.tar.gz"
    sha256 "544748f3860a2623ca5cd6d2795e7a14f3d0e1c3c9728359013f79877fc89bab"
  end

  resource "psycopg" do
    url "https://files.pythonhosted.org/packages/0e/cf/dc1a4d45e3c6222fe272a245c5cea9a969a7157639da606ac7f2ab5de3a1/psycopg-3.2.5.tar.gz"
    sha256 "f5f750611c67cb200e85b408882f29265c66d1de7f813add4f8125978bfd70e8"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/c4/4d/6a840c8d2baa07b57329490e7094f90aac177a1d5226bc919046f1106860/setproctitle-1.3.5.tar.gz"
    sha256 "1e6eaeaf8a734d428a95d8c104643b39af7d247d604f40a7bebcf3960a853c5e"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/e5/40/edede8dd6977b0d3da179a342c198ed100dd2aba4be081861ee5911e4da4/sqlparse-0.5.3.tar.gz"
    sha256 "09f67787f56a0b16ecdbde1bfc7f5d9c3371ca683cfeaa8e6ff60b4807ec9272"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    venv = virtualenv_install_with_resources without: "psycopg"

    # Help `psycopg` find our `libpq`, which is keg-only so its attempt to use `pg_config --libdir` fails
    resource("psycopg").stage do
      inreplace "psycopg/pq/_pq_ctypes.py", "libname = find_libpq_full_path()",
                                            "libname = '#{Formula["libpq"].opt_lib/shared_library("libpq")}'"
      venv.pip_install Pathname.pwd
    end

    generate_completions_from_executable(bin/"pgcli", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match "Invalid DSNs found in the config file", shell_output("#{bin}/pgcli --list-dsn 2>&1", 1)
    (testpath/"pgclirc").write <<~EOS
      [alias_dsn]
      homebrew_dsn = postgresql://homebrew:password@localhost/dbname
    EOS
    assert_match "homebrew_dsn", shell_output("#{bin}/pgcli --pgclirc=#{testpath}/pgclirc --list-dsn")
  end
end
