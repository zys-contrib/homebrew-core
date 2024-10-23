class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v4.2.5.tar.gz"
  sha256 "98faa1d46fc8c8b136710c0abc53cb99e157c57e3c6fed20822407f3aeacad90"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c2c15211d174cf950dd7c9071064a28174902602610936ed60534a75cb71fa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbf3f16a8c84aa051a6388fef1c81c911f8f856e15ce40b7258a06ce6b2e8019"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "06ab595b5dffa2a9d6dacbc6d74968002bd4664927de573aa0073257dd8ca438"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdec168ab14c7e68ae06a1dd90854a187d8c4e3a58e23c159c1b8508025cb043"
    sha256 cellar: :any_skip_relocation, ventura:       "1b1efc1c28e50325c2c6bcc43e90b482e7ddc0872b06cd0f8ff4945e6b1d4274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04b2d3a9a8b047d487ae4618ebeda6f8d3efc72eb949f84238e973f787b6e174"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "zip" => :build
    depends_on "openssl@3"
    depends_on "systemd"
  end

  # rust 1.80.0 build patch, upstream pr ref, https://github.com/aptos-labs/aptos-core/pull/14272
  patch do
    url "https://github.com/aptos-labs/aptos-core/commit/72b9657316c699cfbef75216f578a0bd99e0be46.patch?full_index=1"
    sha256 "f93b4f8b0a61d245e13d6776834cec9ecdd3b0103d53b43dcc79cda3e3f787ed"
  end

  def install
    # FIXME: Look into a different way to specify extra RUSTFLAGS in superenv as they override .cargo/config.toml
    # Ref: https://github.com/Homebrew/brew/blob/master/Library/Homebrew/extend/ENV/super.rb#L65
    ENV.append "RUSTFLAGS", "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"
    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end
