class ApibuilderCli < Formula
  desc "Command-line interface to generate clients for api builder"
  homepage "https://www.apibuilder.io"
  url "https://github.com/apicollective/apibuilder-cli/archive/refs/tags/0.1.51.tar.gz"
  sha256 "8b97ea24baed5689f645f6031dc57e8e14828e8d41b26a3ea18b1e96af248a7b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c4bd91432bf2ff1b0b7844e4ee7d8c5b878fa134428f84f526baf54690b4e9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c4bd91432bf2ff1b0b7844e4ee7d8c5b878fa134428f84f526baf54690b4e9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c4bd91432bf2ff1b0b7844e4ee7d8c5b878fa134428f84f526baf54690b4e9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "0509b9d214aea380aa1153696cafc75c5b388236a0b81b21f2f912ab9ceba390"
    sha256 cellar: :any_skip_relocation, ventura:        "0509b9d214aea380aa1153696cafc75c5b388236a0b81b21f2f912ab9ceba390"
    sha256 cellar: :any_skip_relocation, monterey:       "9c4bd91432bf2ff1b0b7844e4ee7d8c5b878fa134428f84f526baf54690b4e9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39e06906a2a7378e587d69b13c10b433cebd86f6b6fa2e7d96d5ed77fbd5f050"
  end

  uses_from_macos "ruby"

  # patch to remove ask.rb file load, upstream pr ref, https://github.com/apicollective/apibuilder-cli/pull/89
  patch do
    url "https://github.com/apicollective/apibuilder-cli/commit/2f901ad345c8a5d3b7bf46934d97f9be2150eae7.patch?full_index=1"
    sha256 "d57b7684247224c7d9e43b4b009da92c7a9c9ff9938e2376af544662c5dfd6c4"
  end

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"config").write <<~EOS
      [default]
      token = abcd1234
    EOS

    assert_match "Profile default:",
                 shell_output("#{bin}/read-config --path config")
    assert_match "Could not find apibuilder configuration directory",
                 shell_output("#{bin}/apibuilder", 1)
  end
end
