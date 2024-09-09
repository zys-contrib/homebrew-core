class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.10.0.tgz"
  sha256 "355a8ab8dbb6ad41befbef39bc4fd6b5df85e12761d2724bd01f13e878de4b13"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8f5b9f2545b450a1509b6a02777c36d88546fb8769ff4dc16f2cb1d9e9937056"
    sha256 cellar: :any,                 arm64_ventura:  "8f5b9f2545b450a1509b6a02777c36d88546fb8769ff4dc16f2cb1d9e9937056"
    sha256 cellar: :any,                 arm64_monterey: "8f5b9f2545b450a1509b6a02777c36d88546fb8769ff4dc16f2cb1d9e9937056"
    sha256 cellar: :any,                 sonoma:         "1385c96f8faa58f972a46e9f99746d3cf7060da87b9fce08308884eed455ab42"
    sha256 cellar: :any,                 ventura:        "1385c96f8faa58f972a46e9f99746d3cf7060da87b9fce08308884eed455ab42"
    sha256 cellar: :any,                 monterey:       "1385c96f8faa58f972a46e9f99746d3cf7060da87b9fce08308884eed455ab42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3a5919db363a074cde5d4504b600455a403150286f20c5f703a18ed25012204"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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
