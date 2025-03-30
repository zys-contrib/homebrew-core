class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/releases/download/2.10.0.0/haskell-language-server-2.10.0.0-src.tar.gz"
  sha256 "dd7ba032767e9a955f334617eef8f4b8b12b260191f97ad883545851f498dc0a"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ca04aceddff878e084ee95e1b350679f6496ef59f3fa8f888022530241e1a8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e465529fa959635d64b58f489e565b316530246cdb17fe77caaf9a047958b23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4b7056eb268074e77b59c6cd162a4d56b30a711d7504d9b7fad0068df528e21"
    sha256 cellar: :any_skip_relocation, sonoma:        "feb62de0788a945aa9effc9cf8309a3af9781c2960311c0d09dc403435611e21"
    sha256 cellar: :any_skip_relocation, ventura:       "5bd0b38d098fff1453dd0fafb897b23ea908872b90df89ff69594c52b7655ba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37b70a3d3a35c2e55e5227d37f13a136cfa2b191e32917b7feaeeeffa999553a"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]
  depends_on "ghc@9.10" => [:build, :test]
  depends_on "ghc@9.8" => [:build, :test]

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def ghcs
    deps.filter_map { |dep| dep.to_formula if dep.name.match? "ghc" }
        .sort_by(&:version)
  end

  def install
    # Cannot dynamically link when supporting multiple versions of GHC in single formula
    args = ["--disable-executable-dynamic", "--flags=-dynamic -test-exe"]
    # Work around failure: ld: B/BL out of range 204883708 (max +/-128MB)
    args << "--ghc-option=-optl-ld_classic" if DevelopmentTools.clang_build_version == 1500 && Hardware::CPU.arm?

    system "cabal", "v2-update"

    ghcs.each do |ghc|
      system "cabal", "v2-install", "--with-compiler=#{ghc.bin}/ghc", *args, *std_cabal_v2_args

      cmds = ["haskell-language-server", "ghcide-bench"]
      cmds.each do |cmd|
        bin.install bin/cmd => "#{cmd}-#{ghc.version}"
        bin.install_symlink "#{cmd}-#{ghc.version}" => "#{cmd}-#{ghc.version.major_minor}"
      end
      (bin/"haskell-language-server-wrapper").unlink if ghc != ghcs.last
    end
  end

  def caveats
    ghc_versions = ghcs.map { |ghc| ghc.version.to_s }.join(", ")

    <<~EOS
      #{name} is built for GHC versions #{ghc_versions}.
      You need to provide your own GHC or install one with
        brew install #{ghcs.last}
    EOS
  end

  test do
    (testpath/"valid.hs").write <<~HASKELL
      f :: Int -> Int
      f x = x + 1
    HASKELL

    (testpath/"invalid.hs").write <<~HASKELL
      f :: Int -> Int
    HASKELL

    ghcs.each do |ghc|
      with_env(PATH: "#{ghc.bin}:#{ENV["PATH"]}") do
        hls = bin/"haskell-language-server-#{ghc.version.major_minor}"
        assert_match "Completed (1 file worked, 1 file failed)", shell_output("#{hls} #{testpath}/*.hs 2>&1", 1)
      end
    end
  end
end
