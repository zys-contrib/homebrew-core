class WpCliCompletion < Formula
  desc "Bash completion for Wpcli"
  homepage "https://github.com/wp-cli/wp-cli"
  url "https://github.com/wp-cli/wp-cli/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "5edf426895cad99c7fd6486de6618e7360ebcdbdda0684b78d587d67b4749345"
  license "MIT"
  head "https://github.com/wp-cli/wp-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f6e6b76f262eee84b092a65a934ec84498532587caf613ab725b57337e5e8ab5"
  end

  def install
    bash_completion.install "utils/wp-completion.bash" => "wp"
  end

  test do
    assert_match "-F _wp_complete",
      shell_output("bash -c 'source #{bash_completion}/wp && complete -p wp'")
  end
end
