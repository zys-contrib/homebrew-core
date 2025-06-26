class PixiPack < Formula
  desc "Pack and unpack conda environments created with pixi"
  homepage "https://pixi.sh/latest/advanced/production_deployment/#pixi-pack"
  url "https://github.com/quantco/pixi-pack/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "02c9f66d35061ddfbd690a632aafe4415d451762b1e755010a8b33b81285f686"
  license "BSD-3-Clause"
  head "https://github.com/quantco/pixi-pack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5724d325024529c15335b958513027f4db6beef6fd695d2739c810486aa6ca09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e70f6a14cb794e7c46a4ce2e16307c31aefed228a98fc7a82e44930cf0859d31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ed378899bbb28634cf931917dcf099927530410ab3929b596f40537049c3a4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "36cce1afa0a4e588c56249b83f6e03324f2ff7a32f6a139b6d0423220e45088e"
    sha256 cellar: :any_skip_relocation, ventura:       "d195fede86de50f0d7c69339e90b324748a01f2bd95aa2a2c4def81470827523"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d20b651f4304f97df4e068fb4c90ee56b3cd975ed4955086d25ed28acdb4384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2ec9d80701d3abdb0d47ebe8ce996cb77c7cc96159b5de5c12a55ca54438070"
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

    generate_completions_from_executable(bin/"pixi-pack", "completion", "-s")
    generate_completions_from_executable(bin/"pixi-unpack", "completion", "-s")
  end

  test do
    assert_equal "pixi-pack #{version}", shell_output("#{bin}/pixi-pack --version").strip
    assert_equal "pixi-unpack #{version}", shell_output("#{bin}/pixi-unpack --version").strip

    (testpath/"pixi.lock").write <<~YAML
      version: 6
      environments:
        default:
          channels:
          - url: https://conda.anaconda.org/conda-forge/
          packages:
            linux-64:
            - conda: https://conda.anaconda.org/conda-forge/noarch/ca-certificates-2025.6.15-hbd8a1cb_0.conda
            linux-aarch64:
            - conda: https://conda.anaconda.org/conda-forge/noarch/ca-certificates-2025.6.15-hbd8a1cb_0.conda
            osx-64:
            - conda: https://conda.anaconda.org/conda-forge/noarch/ca-certificates-2025.6.15-hbd8a1cb_0.conda
            osx-arm64:
            - conda: https://conda.anaconda.org/conda-forge/noarch/ca-certificates-2025.6.15-hbd8a1cb_0.conda
      packages:
      - conda: https://conda.anaconda.org/conda-forge/noarch/ca-certificates-2025.6.15-hbd8a1cb_0.conda
        sha256: 7cfec9804c84844ea544d98bda1d9121672b66ff7149141b8415ca42dfcd44f6
        md5: 72525f07d72806e3b639ad4504c30ce5
        depends:
        - __unix
        license: ISC
        size: 151069
        timestamp: 1749990087500
    YAML

    (testpath/"pixi.toml").write <<~TOML
      [project]
      name = "test"
      version = "0.1.0"
    TOML

    system bin/"pixi-pack"
    assert_path_exists testpath/"environment.tar"
    system bin/"pixi-unpack", "environment.tar"
    assert_path_exists testpath/"env"
    assert_path_exists testpath/"activate.sh"
  end
end
