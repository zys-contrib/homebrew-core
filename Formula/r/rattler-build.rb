class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.35.4.tar.gz"
  sha256 "b37fd61a440735fd5ab9d8cd7d7d07bc8262e151133de89362fb08e78f60853a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c762146d33456f210701e11fa1e3b25e44934eea4a150f6ced0a94972e1d36f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8b1b1445a521065c9caf09af94b005c54eb20284920e0c3b2f162677ba3f89f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73aa4ec74cc087792d53563dfacde0f2ae29f81bdfa05e081f85aecf6db8e648"
    sha256 cellar: :any_skip_relocation, sonoma:        "46c5c02f84887313bea010cf4483977883aebad6b6c69c3fc4a5b813e17f11a9"
    sha256 cellar: :any_skip_relocation, ventura:       "5db566fda7f52b64cff675fcb18b30e71abdfc90f784cbe380248bcff950a160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d61632ce5819db9c231c17023c976b91e2ebecad2a53b33f5a5fd6a6cd86014"
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
