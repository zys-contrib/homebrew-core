class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.2.14.tar.gz"
  sha256 "82f1fb4295561b7c06c4c063cf4ad8037e209e6722cf585f587eecfa71b11ece"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc0e75068df67012c5415a81b8e339f734562014acaeeda51b0bd08bdcac3214"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc0e75068df67012c5415a81b8e339f734562014acaeeda51b0bd08bdcac3214"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc0e75068df67012c5415a81b8e339f734562014acaeeda51b0bd08bdcac3214"
    sha256 cellar: :any_skip_relocation, sonoma:        "557b325536dc0c264a0eb88edb1cdae849a061e9971d9a4bbadc69c61ff3d254"
    sha256 cellar: :any_skip_relocation, ventura:       "557b325536dc0c264a0eb88edb1cdae849a061e9971d9a4bbadc69c61ff3d254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc0e75068df67012c5415a81b8e339f734562014acaeeda51b0bd08bdcac3214"
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
