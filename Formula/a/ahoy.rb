class Ahoy < Formula
  desc "Creates self documenting CLI programs from commands in YAML files"
  homepage "https://github.com/ahoy-cli/ahoy/"
  url "https://github.com/ahoy-cli/ahoy/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "d48b832a475fc9aa5ea42784ac77805afa7bcd477d919a603ec022c240a045df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3df3575f32c3f7f4b035763fb50c321691ee21a55cd09b0f1b7db7456e8b8a80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff34fd831db681f141430674f747592b0d25b0fced2b7b06eca000904bd93c29"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff34fd831db681f141430674f747592b0d25b0fced2b7b06eca000904bd93c29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff34fd831db681f141430674f747592b0d25b0fced2b7b06eca000904bd93c29"
    sha256 cellar: :any_skip_relocation, sonoma:         "94456698ccb845385b3eecd9f567a51e763ce69f42b2c3cee43f23eb371a94e8"
    sha256 cellar: :any_skip_relocation, ventura:        "94456698ccb845385b3eecd9f567a51e763ce69f42b2c3cee43f23eb371a94e8"
    sha256 cellar: :any_skip_relocation, monterey:       "94456698ccb845385b3eecd9f567a51e763ce69f42b2c3cee43f23eb371a94e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cbaee24adf9c44204beec7e6b43d13a123aedc2be7e7382327630727a857700"
  end

  depends_on "go" => :build

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}-homebrew")
    end
    ohai "Please check the README in the repo (https://github.com/ahoy-cli/ahoy) for new features."
    ohai "An updated documentation website is coming soon."
  end

  test do
    (testpath/".ahoy.yml").write <<~YAML
      ahoyapi: v2
      commands:
        hello:
          cmd: echo "Hello Homebrew!"
    YAML
    assert_equal "Hello Homebrew!\n", `#{bin}/ahoy hello`

    assert_equal "#{version}-homebrew", shell_output("#{bin}/ahoy --version").strip
  end
end
