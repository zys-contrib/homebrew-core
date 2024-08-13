class Chainhook < Formula
  desc "Reorg-aware indexing engine for the Stacks & Bitcoin blockchains"
  homepage "https://github.com/hirosystems/chainhook"
  url "https://github.com/hirosystems/chainhook/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "5d1ea1ad91585d440cf56d0293541593294b70cbf59172957ff53b5598be874d"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/chainhook.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db1c0014de5d08c85bc9f780772ff6b489eddf91be6dd87c74d00a798afc9677"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "464a2c4e1b2758039c5b0ffc10ace9cee8c60322c29a94e0ef3b3542ecdb78a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5c18ed13814ca6ea90de8fa107b4b0fd45466d0384416c85d38c0f572a030cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ae8f567262e46b68cb509eb47e9bc9fca23860e8ef6e3c819eb76eb8096a0b2"
    sha256 cellar: :any_skip_relocation, ventura:        "c6b317d43cfa5b797868fc122485e2722d0f31ef8ee34a0a9c8b55dbd89f2a8e"
    sha256 cellar: :any_skip_relocation, monterey:       "e91426547d1206929b68461712958dc340fb1bff182de299f873c65e9e90ebb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3697182a2f3d066cdc0ac0b70e318337d2462cc6126524d4f74a4f973e15e8c4"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  # rust 1.80 build patch, upstream pr ref, https://github.com/hirosystems/chainhook/pull/631
  patch do
    url "https://github.com/hirosystems/chainhook/commit/e98fc6093e30c41aec55a3391b917ff92de6df1f.patch?full_index=1"
    sha256 "9b1b48a9a5be5ae0ceb3661c7e61f08ca6806ee49fd684dd1dc29cc3a3abb242"
  end

  def install
    system "cargo", "install", "--features", "cli,debug", "--no-default-features",
                                *std_cargo_args(path: "components/chainhook-cli")
  end

  test do
    pipe_output("#{bin}/chainhook config new --mainnet", "n\n")
    assert_match "mode = \"mainnet\"", (testpath/"Chainhook.toml").read
  end
end
