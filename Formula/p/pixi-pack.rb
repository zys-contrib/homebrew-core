class PixiPack < Formula
  desc "Pack and unpack conda environments created with pixi"
  homepage "https://pixi.sh/latest/advanced/production_deployment/#pixi-pack"
  url "https://github.com/quantco/pixi-pack/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "f0f7c8afc6f8a15e714323e7e437a15b9e9130953670570359eef13a997d1bdd"
  license "BSD-3-Clause"
  head "https://github.com/quantco/pixi-pack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da11e187c8b12f4b031f7a973dca314cc56fc06a39331728b7d4c06ef5192355"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10259f011466b9f5ff5fb38f99352696c2b653161b5b69c3a42f5c81fdd534e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5cb97266044d45744aeaf63baff5221267c56af821ebf756dea12225c25186c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6553a1b2c3a246d2a2372376411658484ff15eb634e3d761be72d904b53d6542"
    sha256 cellar: :any_skip_relocation, ventura:       "64220c1a2e2c0f17fa9c9b5d1bfde6ccab7e2168ca1f40832a882e42be31436a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a36c83baacd059e2120d0b6cbe4b6895a21b6c77ed890014b63ee99bdc89f9e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ca7ab72018759fc9df103b39507512e366ded4c7bfeae26708f259cc8c9a756"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "pixi-pack #{version}", shell_output("#{bin}/pixi-pack --version").strip

    (testpath/"pixi.lock").write <<~YAML
      version: 6
      environments:
        default:
          channels:
          - url: https://conda.anaconda.org/conda-forge/
          packages:
            linux-64:
            - conda: https://conda.anaconda.org/conda-forge/linux-64/ca-certificates-2024.8.30-hbcca054_0.conda
      packages:
      - conda: https://conda.anaconda.org/conda-forge/linux-64/ca-certificates-2024.8.30-hbcca054_0.conda
        sha256: afee721baa6d988e27fef1832f68d6f32ac8cc99cdf6015732224c2841a09cea
        md5: c27d1c142233b5bc9ca570c6e2e0c244
        arch: x86_64
        platform: linux
        license: ISC
        size: 159003
        timestamp: 1725018903918
    YAML

    (testpath/"pixi.toml").write <<~TOML
      [project]
      name = "test"
      version = "0.1.0"
    TOML

    system bin/"pixi-pack", "pack", "--platform", "linux-64"
    assert_path_exists testpath/"environment.tar"
  end
end
