class PnpmAT9 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.15.5.tgz"
  sha256 "8472168c3e1fd0bff287e694b053fccbbf20579a3ff9526b6333beab8df65a8d"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-9"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6ff60c8771feb0aef2902ace289b67971ffb9c3073a33e843553b4d6c3f6372a"
    sha256 cellar: :any,                 arm64_sonoma:  "6ff60c8771feb0aef2902ace289b67971ffb9c3073a33e843553b4d6c3f6372a"
    sha256 cellar: :any,                 arm64_ventura: "6ff60c8771feb0aef2902ace289b67971ffb9c3073a33e843553b4d6c3f6372a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dba7e1d848bcc4f65d46a3669ac528e0d5d07b2f5f02b009294aea54170ce8b"
    sha256 cellar: :any_skip_relocation, ventura:       "6dba7e1d848bcc4f65d46a3669ac528e0d5d07b2f5f02b009294aea54170ce8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07ebb08635c6819c1eaf35ba3c8bc1303d0f018782e68289a8cfcd33880abc0c"
  end

  keg_only :versioned_formula

  depends_on "node" => [:build, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    bin.install_symlink bin/"pnpm" => "pnpm@9"
    bin.install_symlink bin/"pnpx" => "pnpx@9"

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"lib/node_modules/pnpm/dist").glob("reflink.*.node").each do |f|
      next if f.arch == Hardware::CPU.arch

      rm f
    end
  end

  def caveats
    <<~EOS
      pnpm requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system bin/"pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
