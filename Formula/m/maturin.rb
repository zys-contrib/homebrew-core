class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "16839be24f792cd0de7bc849794e351ab63569d7d302d781e113af319914fdf6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16d60fe01ca76e124af5cf5c282644b94bcf8dc65dcb1d385619f0be28682852"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77b2eed87bd60268aada9b343b705800de4cb9ae74c5cb2b1ebecdc81274d56f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed30655e916d3d29684ac88fd78fd139a309850dcf61c30db083529e108ac048"
    sha256 cellar: :any_skip_relocation, sonoma:        "b61d5933f5c7b947dd4ac15b73b2992c3d2bb75be239e408429edc306bfd66d7"
    sha256 cellar: :any_skip_relocation, ventura:       "41ee546127ae7c3b750b649c2859d02fe5ec1c24d57ea74361595a9b6ff31eaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d32f4e935d2dc645f5430f6fc1ee8d007cc0e532a95e91a64eb94237a78a509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4eea3bb116c873f954c18704ee7fc4f37a8323f1d7c9c4277545c989c0e8d12"
  end

  depends_on "python@3.13" => :test
  depends_on "rust"

  uses_from_macos "bzip2"
  uses_from_macos "xz"

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      ENV.remove "HOMEBREW_LIBRARY_PATHS",
                 recursive_dependencies.find { |d| d.name.match?(/^llvm(@\d+)?$/) }
                                       .to_formula
                                       .opt_lib
    end

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"maturin", "completions")

    python_versions = Formula.names.filter_map do |name|
      Version.new(name.delete_prefix("python@")) if name.start_with?("python@")
    end.sort

    newest_python = python_versions.pop
    newest_python_site_packages = lib/"python#{newest_python}/site-packages"
    newest_python_site_packages.install "maturin"

    python_versions.each do |pyver|
      (lib/"python#{pyver}/site-packages/maturin").install_symlink (newest_python_site_packages/"maturin").children
    end
  end

  test do
    python = "python3.13"
    system "cargo", "init", "--name=brew", "--bin"
    system bin/"maturin", "build", "-o", "dist", "--compatibility", "off"
    system python, "-m", "pip", "install", "brew", "--prefix=./dist", "--no-index", "--find-links=./dist"
    system python, "-c", "import maturin"
  end
end
