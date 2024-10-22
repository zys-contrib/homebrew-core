class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "650969954075e63323d7cfdb5ad4aac5cdf96ba03110117133dc6ad6efd81b1b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1f12e107d96cac65debbf9bb2d4a986b5de9beb5b419f502ed2e8e652c2db4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1f12e107d96cac65debbf9bb2d4a986b5de9beb5b419f502ed2e8e652c2db4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1f12e107d96cac65debbf9bb2d4a986b5de9beb5b419f502ed2e8e652c2db4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3789a923e6206c7c5fcafcf02044142ca1e8cc0fc32a023ba98556d8829582f3"
    sha256 cellar: :any_skip_relocation, ventura:       "3789a923e6206c7c5fcafcf02044142ca1e8cc0fc32a023ba98556d8829582f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef37008fbd2a488747471d1967de2eb6ea4ef39d50750e587e9b3adb61027fec"
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
