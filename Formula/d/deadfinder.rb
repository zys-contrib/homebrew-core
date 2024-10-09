class Deadfinder < Formula
  desc "Finds broken links"
  homepage "https://rubygems.org/gems/deadfinder"
  url "https://github.com/hahwul/deadfinder/archive/refs/tags/1.4.4.tar.gz"
  sha256 "65be55ddea901827b033b5b9c94edb8ceba5c83f70af38e99f340d4239c902d6"
  license "MIT"
  head "https://github.com/hahwul/deadfinder.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4648863aa583eed5441547d23e662de3df76450a60ef76a88dd6c1afe1c35501"
    sha256 cellar: :any,                 arm64_sonoma:  "05da98f9103d00902a2fa619f21c715550c48370deae0f7f97b5577095a81de4"
    sha256 cellar: :any,                 arm64_ventura: "0abce0025c3c461f244195cdc48c1217d083a3029697d2df8fc74470648c3019"
    sha256 cellar: :any,                 sonoma:        "69320530cb338fd46c35f75feeb535836e673dcd5dfd6661df305ae5d566e264"
    sha256 cellar: :any,                 ventura:       "73f8bc1a21122af14429a2955b0fe12970462d558c4bc823bdd381893cec5cab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa20b19beb02e905b93675b24ef908e9d9acf8f64b7a42384c58298e3cb4b383"
  end

  depends_on "ruby"

  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["NOKOGIRI_USE_SYSTEM_LIBRARIES"] = "1"
    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
    system "gem", "build", "deadfinder.gemspec"
    system "gem", "install", "deadfinder-#{version}.gem"
    bin.install libexec/"bin/deadfinder"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match version.to_s, shell_output(bin/"deadfinder version")

    assert_match "Done", shell_output(bin/"deadfinder url https://brew.sh")
  end
end
