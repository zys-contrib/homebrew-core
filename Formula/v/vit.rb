class Vit < Formula
  include Language::Python::Virtualenv

  desc "Full-screen terminal interface for Taskwarrior"
  homepage "https://github.com/vit-project/vit"
  url "https://files.pythonhosted.org/packages/a2/24/71ef618e17ced54d3ad706215165ebeb6ebc86f5d71ded58c4dbcba62b83/vit-2.3.2.tar.gz"
  sha256 "a837d8e865a70d0e384a1e78d314330f000d108fa62e3a72d9aec6dec7ca233c"
  license "MIT"
  head "https://github.com/vit-project/vit.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ad80b46eca2f3550ff7c81b65dbc16586f49ba5279dabe596d49346b8c32c2be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07c6838801cde2043cc4be85222d134f3add125a7e0e8f6bda6f718bf9a6fb73"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba5c6afa83e6004a5be6038e6a58691a249b6594529e68c2ed7117bb463030b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93cdfa799ccc23594cc64d1d20d4a5b20b0a06597e1afa000153a54a838e24e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "970a532408b8900ddb3b56d4966c3624640e76421cff3a4fa83c692d279406df"
    sha256 cellar: :any_skip_relocation, ventura:        "9d6aa4c94be62db3242d2235b94149f2f027a23fe50a379c6da6e7d868e67936"
    sha256 cellar: :any_skip_relocation, monterey:       "1c8173fcdebfe49c05d0029f9313e3631ab110c242540eb75b568365373fb62a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c05e79958401ba5fd6399a0afa23721e433c26b2dd0a169e3fe6868416aefaab"
  end

  depends_on "python@3.13"
  depends_on "task"

  resource "tasklib" do
    url "https://files.pythonhosted.org/packages/3e/50/3e876f39e31bad8783fd3fe117577cbf1dde836e161f8446631bde71aeb4/tasklib-2.5.1.tar.gz"
    sha256 "5ccd731b52636dd10457a8b8d858cb0d026ffaab1e3e751baf791bf803e37d7b"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/85/b7/516b0bbb7dd9fc313c6443b35d86b6f91b3baa83d2c4016e4d8e0df5a5e3/urwid-2.6.15.tar.gz"
    sha256 "9ecc57330d88c8d9663ffd7092a681674c03ff794b6330ccfef479af7aa9671b"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/".vit").mkpath
    touch testpath/".vit/config.ini"
    touch testpath/".taskrc"

    require "pty"
    PTY.spawn(bin/"vit") do |_stdout, _stdin, pid|
      sleep 3
      Process.kill "TERM", pid
    end
    assert_predicate testpath/".task", :exist?
  end
end
