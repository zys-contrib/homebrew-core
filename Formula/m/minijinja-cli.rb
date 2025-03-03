class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https://docs.rs/minijinja/latest/minijinja/"
  url "https://github.com/mitsuhiko/minijinja/archive/refs/tags/2.8.0.tar.gz"
  sha256 "bdad3b19ffaf09c34eb97b254a05a9184f021003a66d69f01f20a5b6417b8bba"
  license "Apache-2.0"
  head "https://github.com/mitsuhiko/minijinja.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06f8818f988d6b26abd3568582f09f0a705d3b1effd4df63140592c324b7578c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3f9f2f76aee46c485c29b5d491d950563d34111dfb87d62cce2609635554745"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65478afd3e7f3f7e9495203da2773c24b6d20649e829314062092407552c299d"
    sha256 cellar: :any_skip_relocation, sonoma:        "78f0babfb82ed81cc7db182375bbda36b956fcec417a9f399c2189bcc6c7a2e9"
    sha256 cellar: :any_skip_relocation, ventura:       "30276a941aeda43340c54ae72670bbad6561e11544a8f06192034a5919bb3e81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5fc36b8e4bf81d318b6157fede9e7d306185fd504d55f406e6f9b673a4a1517"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "minijinja-cli")

    generate_completions_from_executable(bin/"minijinja-cli", "--generate-completion")
  end

  test do
    (testpath/"test.jinja").write <<~EOS
      Hello {{ name }}
    EOS

    assert_equal "Hello Homebrew\n", shell_output("#{bin}/minijinja-cli test.jinja --define name=Homebrew")
  end
end
