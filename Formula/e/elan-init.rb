class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "a4a99e2aafca4ce316ef8f88757fafbbf50d2a5912551086c5aaa522c9d976f4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/leanprover/elan.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c93394653ef8e64479ba7dec0b9be68568914ac862361cdb3c08815b75cdc66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f92dafb5d7f25736c620cb9c149c62ec541e71d5cb6ba14d08acdeff3a2e8e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "126ff77a5b4c50884bc65f560dbba2f53b6f3589d55351bfa99a39085269b6c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "902e038099e06cbb93b24e9a9b4eeb71fd0da090b21c22a5f762a7b123fa6004"
    sha256 cellar: :any_skip_relocation, ventura:       "7a5a201f8d57f00c95ef95d1b4ba0d371caf78b4eaf100760747e89a6ca47bec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce9692c41a445074fe403a41743c1b5a86aff4fd539a29e6c988510cebfdb2c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9540b37d1fdae860f8d60f60d48c7541ae8dffc4d9d1ff1bff4d443e852f1fae"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "coreutils"
  depends_on "gmp"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  conflicts_with "lean-cli", because: "both install `lean` binaries"
  conflicts_with "lean", because: "`lean` and `elan-init` install the same binaries"

  def install
    ENV["RELEASE_TARGET_NAME"] = "homebrew-build"

    system "cargo", "install", "--features", "no-self-update", *std_cargo_args

    %w[lean leanpkg leanchecker leanc leanmake lake elan].each do |link|
      bin.install_symlink "elan-init" => link
    end

    generate_completions_from_executable(bin/"elan", "completions")
  end

  test do
    ENV["ELAN_HOME"] = testpath/".elan"

    system bin/"elan-init", "-y", "--default-toolchain=leanprover/lean4:stable"
    (testpath/"hello.lean").write <<~EOS
      def id' {α : Type} (x : α) : α := x

      inductive tree {α : Type} : Type
      | node : α → List tree → tree

      example (a b : Prop) : a ∧ b -> b ∧ a := by
          intro h; cases h with
          | intro ha hb => constructor; exact hb; exact ha
    EOS
    system bin/"lean", testpath/"hello.lean"
    system bin/"lake", "help"
  end
end
