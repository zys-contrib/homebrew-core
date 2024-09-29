class Tmuxinator < Formula
  desc "Manage complex tmux sessions easily"
  homepage "https://github.com/tmuxinator/tmuxinator"
  url "https://github.com/tmuxinator/tmuxinator/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "8b41f7c56b42ea13e37c99f4cd818a571859f473ae5acbed12f343a75e3fa1be"
  license "MIT"
  head "https://github.com/tmuxinator/tmuxinator.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20b3157e1c0d3d678d99d9d331d6a40672e2ac06275b16ce2aa710648f9b6158"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20b3157e1c0d3d678d99d9d331d6a40672e2ac06275b16ce2aa710648f9b6158"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20b3157e1c0d3d678d99d9d331d6a40672e2ac06275b16ce2aa710648f9b6158"
    sha256 cellar: :any_skip_relocation, sonoma:        "511e8442e0a21d32bb349546202e7eb63bc1264443149d63401054191cd92654"
    sha256 cellar: :any_skip_relocation, ventura:       "511e8442e0a21d32bb349546202e7eb63bc1264443149d63401054191cd92654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20b3157e1c0d3d678d99d9d331d6a40672e2ac06275b16ce2aa710648f9b6158"
  end

  depends_on "ruby"
  depends_on "tmux"

  conflicts_with "tmuxinator-completion", because: "the tmuxinator formula includes completion"

  resource "xdg" do
    url "https://rubygems.org/downloads/xdg-2.2.5.gem"
    sha256 "f3a5f799363852695e457bb7379ac6c4e3e8cb3a51ce6b449ab47fbb1523b913"
  end

  resource "thor" do
    url "https://rubygems.org/downloads/thor-1.3.2.gem"
    sha256 "eef0293b9e24158ccad7ab383ae83534b7ad4ed99c09f96f1a6b036550abbeda"
  end

  resource "erubi" do
    url "https://rubygems.org/downloads/erubi-1.12.0.gem"
    sha256 "27bedb74dfb1e04ff60674975e182d8ca787f2224f2e8143268c7696f42e4723"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end

    system "gem", "build", "tmuxinator.gemspec"
    system "gem", "install", "--ignore-dependencies", "tmuxinator-#{version}.gem"
    bin.install libexec/"bin/tmuxinator"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

    bash_completion.install "completion/tmuxinator.bash" => "tmuxinator"
    zsh_completion.install "completion/tmuxinator.zsh" => "_tmuxinator"
    fish_completion.install Dir["completion/*.fish"]
  end

  test do
    version_output = shell_output("#{bin}/tmuxinator version")
    assert_match "tmuxinator #{version}", version_output

    completion = shell_output("bash -c 'source #{bash_completion}/tmuxinator && complete -p tmuxinator'")
    assert_match "-F _tmuxinator", completion

    commands = shell_output("#{bin}/tmuxinator commands")
    commands_list = %w[
      commands completions new edit open start
      stop local debug copy delete implode
      version doctor list
    ]

    expected_commands = commands_list.join("\n")
    assert_match expected_commands, commands

    list_output = shell_output("#{bin}/tmuxinator list")
    assert_match "tmuxinator projects:", list_output

    system bin/"tmuxinator", "new", "test"
    list_output = shell_output("#{bin}/tmuxinator list")
    assert_equal "tmuxinator projects:\ntest\n", list_output
  end
end
