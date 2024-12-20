class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.2.13.tar.gz"
  sha256 "056039036937d017bcefa7e4ff11dc032964bfd818e468247259d6a4d8ddb527"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33433e6f47dd1666a7ade124d5c02c0f8504eb95d22a938d4bc25a5f94f0283f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33433e6f47dd1666a7ade124d5c02c0f8504eb95d22a938d4bc25a5f94f0283f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33433e6f47dd1666a7ade124d5c02c0f8504eb95d22a938d4bc25a5f94f0283f"
    sha256 cellar: :any_skip_relocation, sonoma:        "68204d1e001c22f1975694684ab0156bdee745f744cb0bd7855a4fb1bc3fb68d"
    sha256 cellar: :any_skip_relocation, ventura:       "68204d1e001c22f1975694684ab0156bdee745f744cb0bd7855a4fb1bc3fb68d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33433e6f47dd1666a7ade124d5c02c0f8504eb95d22a938d4bc25a5f94f0283f"
  end

  def install
    inreplace_files = [
      "libexec/goenv",
      "plugins/go-build/install.sh",
      "test/goenv.bats",
      "test/test_helper.bash",
    ]
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX

    prefix.install Dir["*"]
    %w[goenv-install goenv-uninstall go-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/go-build/bin/#{cmd}"
    end
  end

  test do
    assert_match "Usage: goenv <command> [<args>]", shell_output("#{bin}/goenv help")
  end
end
