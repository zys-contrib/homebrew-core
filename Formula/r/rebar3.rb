class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/refs/tags/3.24.0.tar.gz"
  sha256 "391b0eaa2825bb427fef1e55a0d166493059175f57a33b00346b84a20398216c"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e09b0c0a5c2f497582b372ce6f562288ad3bc78479ba036e4e11dc9bc26bc07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5f760d70e924bba678bdb3628da2457843f93635080d831b195c1ae1157166a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76a193404cc815b70d6f090b195d45092dde58d6b022c43aeb6c6aa64fd028cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "d65af44f517ec8d3d43e96a9d1adf54ccd8820eb80f6ee855a81bd256196408a"
    sha256 cellar: :any_skip_relocation, ventura:       "931a271f9f096aaeea8e03a2d43f64ae92668b0eff71ab9717f4594d6ee631fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02b3b49e11165116df3e0719eb661896e276e2e8956b8eeca4075b4d496c556d"
  end

  depends_on "erlang@26"

  def install
    system "./bootstrap"
    bin.install "rebar3"

    bash_completion.install "apps/rebar/priv/shell-completion/bash/rebar3"
    zsh_completion.install "apps/rebar/priv/shell-completion/zsh/_rebar3"
    fish_completion.install "apps/rebar/priv/shell-completion/fish/rebar3.fish"

    # TODO: Remove me when we depend on unversioned `erlang`.
    bin.env_script_all_files libexec, PATH: "#{Formula["erlang@26"].opt_bin}:$PATH"
  end

  test do
    system bin/"rebar3", "--version"
  end
end
