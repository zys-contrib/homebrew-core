class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.35.3.tar.gz"
  sha256 "edd716f0774d94fd444fd7513665aee4fdd8e8f3cdcb0c4e2d978ca301966076"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/rattler-build.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe27221db19e039fa0dab5c602a0ed309942db0dc3c79511c66a6b6aaf292caa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eac8bd005ba575c32587d21aabf0f0286b7c5d60b2c7887961527e42f5de7d58"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1161480471a2dc282c62c8c95d271f559eaee08a583a42f6f55e9f936bb1224b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2dc666b6bdaa5e32eff1289c208de6cbc6b06c495d1c9096c5bcd9a9a4e4068"
    sha256 cellar: :any_skip_relocation, ventura:       "11a8cb2aeb09a41dd28cb8405e90b31b614a8923a7722fc81b153d51b3620010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ca776084aefb5851d43cde50934481d370b604cf3c828ab374bebfccb1b13ae"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--features", "tui", *std_cargo_args

    generate_completions_from_executable(bin/"rattler-build", "completion", "--shell")
  end

  test do
    (testpath/"recipe"/"recipe.yaml").write <<~YAML
      package:
        name: test-package
        version: '0.1.0'

      build:
        noarch: generic
        string: buildstring
        script:
          - mkdir -p "$PREFIX/bin"
          - echo "echo Hello World!" >> "$PREFIX/bin/hello"
          - chmod +x "$PREFIX/bin/hello"

      requirements:
        run:
          - python

      tests:
        - script:
          - test -f "$PREFIX/bin/hello"
          - hello | grep "Hello World!"
    YAML
    system bin/"rattler-build", "build", "--recipe", "recipe/recipe.yaml"
    assert_path_exists testpath/"output/noarch/test-package-0.1.0-buildstring.conda"

    assert_match version.to_s, shell_output(bin/"rattler-build --version")
  end
end
