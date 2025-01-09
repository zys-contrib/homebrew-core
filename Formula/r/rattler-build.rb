class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "fe248fddff9c078efd3edc270abb90ec13bf2325a6b0029bc799f7b0c946c464"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ffc9db0dd2d52b2e8672880438a070091bb813825a7be42eca1c875d4e2c0dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da4cdf7697385e5b41d57fba0731508c3f7aee5058d326943354c2c12ab6fc44"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe03df39277b685b7e540ee7b0e0b62c4fe5d86a34f86c5d60a327ba58403ffd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e0d71beedc8dca6f2279086929e5328818ecd4b8c7b87378d60605cb6ad370c"
    sha256 cellar: :any_skip_relocation, ventura:       "4ee7fc21616d10972b90229479661c16f38c211fc6f6e3f1990ae1e8e18ea8ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "490184aa02ea30a11a4caebbb347efdc1ab079d48aaca8fe7790e273369962fe"
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
