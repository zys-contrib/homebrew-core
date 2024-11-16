class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://goteleport.com/"
  url "https://github.com/gravitational/teleport/archive/refs/tags/v17.0.1.tar.gz"
  sha256 "d2022e497edf5f42f110d4c8d2d8e9dbbcd87d45810fe7cb58e8dcc666f0b0fb"
  license all_of: ["AGPL-3.0-or-later", "Apache-2.0"]
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # As of writing, two major versions of `teleport` are being maintained
  # side by side and the "latest" release can point to an older major version,
  # so we can't use the `GithubLatest` strategy. We use the `GithubReleases`
  # strategy instead of `Git` because there is often a notable gap (days)
  # between when a version is tagged and released.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4e7f4e8b74ac634320853f794cc5265afb34868558b1899a5b656e10fdfd9a42"
    sha256 cellar: :any,                 arm64_sonoma:  "6a4408ffbc5f206f421107b7384d2e8d18fd3d7266d1df6ec7f6dd7f7e9bb2e5"
    sha256 cellar: :any,                 arm64_ventura: "f14ef6ef97ab5a6d6ff4721097a6d19eaa1e575b5ba425f0517f86470fc6fccc"
    sha256 cellar: :any,                 sonoma:        "7df4288c8a0e73c95ac162cc87aa27d01dc67a807f0463360efe491c01b95ab0"
    sha256 cellar: :any,                 ventura:       "851ff56dcb3809937089c0ab1d3c401121300b3a3d48f81c4772b06a07f48d26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dd4236aa926aae711c27fde357be865f4298492eda09d3ff8e446e9e0453b71"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  # TODO: try to remove rustup dependancy, see https://github.com/Homebrew/homebrew-core/pull/191633#discussion_r1774378671
  depends_on "rustup" => :build
  depends_on "wasm-pack" => :build
  depends_on "libfido2"
  depends_on "node"
  depends_on "openssl@3"

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"
  conflicts_with "tctl", because: "both install `tctl` binaries"

  def install
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "stable"
    system "rustup", "set", "profile", "minimal"

    ENV.deparallelize { system "make", "full", "FIDO2=dynamic" }
    bin.install Dir["build/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    assert_match version.to_s, shell_output("#{bin}/tsh version")
    assert_match version.to_s, shell_output("#{bin}/tctl version")

    mkdir testpath/"data"
    (testpath/"config.yml").write <<~YAML
      version: v2
      teleport:
        nodename: testhost
        data_dir: #{testpath}/data
        log:
          output: stderr
          severity: WARN
    YAML

    fork do
      exec "#{bin}/teleport start --roles=proxy,node,auth --config=#{testpath}/config.yml"
    end

    sleep 10
    system "curl", "--insecure", "https://localhost:3080"

    status = shell_output("#{bin}/tctl status --config=#{testpath}/config.yml")
    assert_match(/Cluster:\s*testhost/, status)
    assert_match(/Version:\s*#{version}/, status)
  end
end
