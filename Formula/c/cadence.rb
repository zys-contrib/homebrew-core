class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "3768c6fa9547b644ccefa584b976ac59f5674988abf0256a26ea9536a8dec1b3"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ae92a2030d022bc3ba068a1c624e35db7c66bf1f7ba2a881a0fe11c73b0dc8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ae92a2030d022bc3ba068a1c624e35db7c66bf1f7ba2a881a0fe11c73b0dc8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ae92a2030d022bc3ba068a1c624e35db7c66bf1f7ba2a881a0fe11c73b0dc8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "937a0df0d53c1de1814839317923288679681157a838b116cfe5b5064ee46812"
    sha256 cellar: :any_skip_relocation, ventura:       "937a0df0d53c1de1814839317923288679681157a838b116cfe5b5064ee46812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "096d576945273b92c30437b7c8a2c5df0c8c1a7b396e72aab9fe60cbf1199077"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/main"
  end

  test do
    # from https://cadence-lang.org/docs/tutorial/hello-world
    (testpath/"hello.cdc").write <<~EOS
      access(all) contract HelloWorld {

          // Declare a public (access(all)) field of type String.
          //
          // All fields must be initialized in the initializer.
          access(all) let greeting: String

          // The initializer is required if the contract contains any fields.
          init() {
              self.greeting = "Hello, World!"
          }

          // Public function that returns our friendly greeting!
          access(all) view fun hello(): String {
              return self.greeting
          }
      }
    EOS
    system bin/"cadence", "hello.cdc"
  end
end
