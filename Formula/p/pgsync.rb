class Pgsync < Formula
  desc "Sync Postgres data between databases"
  homepage "https://github.com/ankane/pgsync"
  url "https://github.com/ankane/pgsync/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "385aa0be8683ae4877fc6b39a3a4a0664680ed1631559fadd7b5113d7724ecea"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "3be5e4c0b54da4fb5bc67559ed678390d673a80d0fd0d7cc84a3869056b04735"
    sha256                               arm64_ventura:  "390b56a83b1952e3fe7f90b401b09c85262d113864c1e96b34a505eeaca8c71d"
    sha256                               arm64_monterey: "199400c31c4ad508359244ac88d64f255a08325b4cd1fa23a7675b1c524458c5"
    sha256                               sonoma:         "d93d99284723f99cd8e9fb8662657e165b850555bcb2d0b7eb52a47a8c6db58a"
    sha256                               ventura:        "752a83687459ec26d56765dc3097221411944a8064749056489a9a3df812e864"
    sha256                               monterey:       "6a2edf7a42f8482631d31245b4a12f462f0ceefadaf486e4fe512fdc46ddf14f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8f827a09b68fe73cbc33d6f6d02adba242e8577b2adde061ead9ee7bdedc67c"
  end

  depends_on "libpq"
  depends_on "ruby"

  resource "parallel" do
    url "https://rubygems.org/gems/parallel-1.25.1.gem"
    sha256 "12e089b9aa36ea2343f6e93f18cfcebd031798253db8260590d26a7f70b1ab90"
  end

  resource "pg" do
    url "https://rubygems.org/gems/pg-1.5.6.gem"
    sha256 "4bc3ad2438825eea68457373555e3fd4ea1a82027b8a6be98ef57c0d57292b1c"
  end

  resource "slop" do
    url "https://rubygems.org/gems/slop-4.10.1.gem"
    sha256 "844322b5ffcf17ed4815fdb173b04a20dd82b4fd93e3744c88c8fafea696d9c7"
  end

  resource "tty-cursor" do
    url "https://rubygems.org/gems/tty-cursor-0.7.1.gem"
    sha256 "79534185e6a777888d88628b14b6a1fdf5154a603f285f80b1753e1908e0bf48"
  end

  resource "tty-spinner" do
    url "https://rubygems.org/gems/tty-spinner-0.9.3.gem"
    sha256 "0e036f047b4ffb61f2aa45f5a770ec00b4d04130531558a94bfc5b192b570542"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end

    system "gem", "build", "pgsync.gemspec"
    system "gem", "install", "--ignore-dependencies", "pgsync-#{version}.gem"

    bin.install libexec/"bin/pgsync"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    system bin/"pgsync", "--init"
    assert_predicate testpath/".pgsync.yml", :exist?
  end
end
