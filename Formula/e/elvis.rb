class Elvis < Formula
  desc "Erlang Style Reviewer"
  homepage "https://github.com/inaka/elvis"
  url "https://github.com/inaka/elvis/archive/refs/tags/3.2.6.tar.gz"
  sha256 "55edcd5c0c995b3c093c83f51bce1f00ea4d3322234531e03b6181a99cb42ff9"
  license "Apache-2.0"
  head "https://github.com/inaka/elvis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3fa51cbfa940ef6580a9a1c6dd7b54e79e2bd592a6bcd998ae586423f0e9312"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb14a028a27e780ed2ee0018d425dfa0ab3de7a26a66632178584c86b8f0e437"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6626aef7f53e38000f0173d218b52d5b4ba4d332eebed634c956b467cae0d8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "39c463af07cd2a4b541ab050b8ec425a3ed1050dba7fc9a2d756decce376971d"
    sha256 cellar: :any_skip_relocation, ventura:       "84da0222b61cd6e226ceb9f3da0120d0c70d98bc90d54b71ae273c9bbe6d86de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48fd3142e4cc6da836f27762340fac25e26e23e647b918724d99ef3bdf72bc6e"
  end

  depends_on "rebar3" => :build
  depends_on "erlang"

  def install
    system "rebar3", "escriptize"

    bin.install "_build/default/bin/elvis"

    bash_completion.install "priv/bash_completion/elvis"
    zsh_completion.install "priv/zsh_completion/_elvis"
  end

  test do
    (testpath/"src/example.erl").write <<~EOS
      -module(example).

      -define(bad_macro_name, "should be upper case").
    EOS

    (testpath/"elvis.config").write <<~EOS
      [{elvis, [
        {config, [
          \#{ dirs => ["src"], filter => "*.erl", ruleset => erl_files }
        ]},
        {output_format, parsable}
      ]}].
    EOS

    expected = <<~EOS.chomp
      The macro named "bad_macro_name" on line 3 does not respect the format defined by the regular expression
    EOS

    assert_match expected, shell_output("#{bin}/elvis rock", 1)
  end
end
