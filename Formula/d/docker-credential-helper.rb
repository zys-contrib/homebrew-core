class DockerCredentialHelper < Formula
  desc "Platform keystore credential helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "aa4c2aa7987e780769b116f5cef263c13813ef9d40367c7830f71ce486c937b3"
  license "MIT"
  head "https://github.com/docker/docker-credential-helpers.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da3f41e9985558f0f6d8e156895de8f0e55157c6029909443b00b0fcbce5fa9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5347e3a6530ebf9d71e238c3c3c9f556ea42cbea743995f80d44e23e651e8e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58700557e521e1299e0ec594388c10f82220a0f27cdeb4af62aa9aff2c0a6989"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8cc1a0d8889d3fff45cbb717cbc8e6c3330095ee5863d662b434df4b378aa89"
    sha256 cellar: :any_skip_relocation, ventura:       "b4eb6c0899e0a2215ecf08fe43f1ebbedf0a007155a5a31c5e122d630c447853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06b5eb51fb2e2c118f5106e0cdc353c18d8c00561494d9b045309a716eb1dfca"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    if OS.mac?
      system "make", "osxkeychain"
      bin.install "bin/build/docker-credential-osxkeychain"
    else
      system "make", "pass"
      system "make", "secretservice"
      bin.install "bin/build/docker-credential-pass"
      bin.install "bin/build/docker-credential-secretservice"
    end
  end

  test do
    if OS.mac?
      run_output = shell_output("#{bin}/docker-credential-osxkeychain", 1)
      assert_match "Usage: docker-credential-osxkeychain", run_output
    else
      run_output = shell_output("#{bin}/docker-credential-pass list")
      assert_match "{}", run_output

      run_output = shell_output("#{bin}/docker-credential-secretservice list", 1)
      assert_match "Cannot autolaunch D-Bus without X11", run_output
    end
  end
end
