class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  license "Apache-2.0"
  revision 1
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  stable do
    url "https://github.com/haskell/haskell-language-server/releases/download/2.9.0.1/haskell-language-server-2.9.0.1-src.tar.gz"
    sha256 "bdcdca4d4ec2a6208e3a32309ad88f6ebc51bdaef44cc59b3c7c004699d1f7bd"

    # Backport support for newer GHC 9.8
    # Ref: https://github.com/haskell/haskell-language-server/commit/6d0a6f220226fe6c1cb5b6533177deb55e755b0b
    patch :DATA
  end

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e50ed5add3e104d152871aa41670d5793907cd835986735dc3cc0c7e139b90b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46b1067ee77c8d2741f9e26744786cabc80e62a6b29befcaaf38058067953102"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56df7ae9fc11ea8d19ccc3adff4a9fd7844f8e15200e5469fa90815b8c8a89b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a11af473d8a8eaea5159c5fa4827b59551ff705bca1d057d75aa6ae8f40d2a3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1e671aa10750b612d12a45f815a35416998662188e954d80a16a55377d9f50e"
    sha256 cellar: :any_skip_relocation, ventura:        "739cbff9e9abd601ffe31628417f6a0cea26a7c05e70b384bf40b2765f40d9a9"
    sha256 cellar: :any_skip_relocation, monterey:       "ecfbbe1f719963f7e3f45fe27e14ca98b07218525f8c23af886e67450a9a6242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afbb8f67dc62f0f72ebbbc7ce88e10c3e5a65abac2df6d2f86132676f15041d6"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc@9.10" => [:build, :test]
  depends_on "ghc@9.6" => [:build, :test]
  depends_on "ghc@9.8" => [:build, :test]

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def ghcs
    deps.filter_map { |dep| dep.to_formula if dep.name.match? "ghc" }
        .sort_by(&:version)
  end

  def install
    # Backport newer index-state for GHC 9.8.4 support in ghc-lib-parser.
    # We use the timestamp of r1 revision to avoid latter part of commit
    # Ref: https://github.com/haskell/haskell-language-server/commit/25c5d82ce09431a1b53dfa1784a276a709f5e479
    # Ref: https://hackage.haskell.org/package/ghc-lib-parser-9.8.4.20241130/revisions/
    # TODO: Remove on the next release
    inreplace "cabal.project", ": 2024-06-13T17:12:34Z", ": 2024-12-04T16:29:32Z" if build.stable?

    system "cabal", "v2-update"

    ghcs.each do |ghc|
      system "cabal", "v2-install", "--with-compiler=#{ghc.bin}/ghc", "--flags=-dynamic", *std_cabal_v2_args

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

__END__
--- a/ghcide/src/Development/IDE/GHC/Compat/Core.hs
+++ b/ghcide/src/Development/IDE/GHC/Compat/Core.hs
@@ -674,7 +674,7 @@ initObjLinker env =
 loadDLL :: HscEnv -> String -> IO (Maybe String)
 loadDLL env str = do
     res <- GHCi.loadDLL (GHCi.hscInterp env) str
-#if MIN_VERSION_ghc(9,11,0)
+#if MIN_VERSION_ghc(9,11,0) || (MIN_VERSION_ghc(9, 8, 3) && !MIN_VERSION_ghc(9, 9, 0))
     pure $
       case res of
         Left err_msg -> Just err_msg
