class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "0342babfbd6d8201ae00b6b0ef5e0b181bce5690c703ffae8dd02542e024c4c2"
  license "Apache-2.0"
  revision 1
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82bc6cfc1ab63fc3f6030a1cd761c1c70ce418bf9d3a51f288c10586b5d754cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c93368bc396297078b463042a202ed2b189ecc124b4bc8a36ee4db483e2a5605"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23413800238a8a5bb894a8f7b4bdffc5f3ec95c9e7aced5b1c85ae1565cc2839"
    sha256 cellar: :any_skip_relocation, sonoma:        "dac1e7caaf8980f95bcdcf2fdf44e1c91596d1ad0d57ae0b9481868f6b6d96dc"
    sha256 cellar: :any_skip_relocation, ventura:       "5544b29fd224eb8e306a81f925a206d003b4807d3750b7ed7fa30d80284ac1fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ee98d9ca6b13800f83384f1f06d914fbd07cb38d3dd884d1c40fb73640e7d83"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "erlang@26"
  depends_on "rebar3"

  def install
    system "cargo", "install", *std_cargo_args(path: "compiler-cli")

    # TODO: Remove me when we depend on unversioned `erlang`.
    bin.env_script_all_files libexec, PATH: "#{Formula["erlang@26"].opt_bin}:$PATH"
  end

  test do
    Dir.chdir testpath
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin/"gleam", "test"
  end
end
