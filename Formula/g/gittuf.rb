class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https://gittuf.dev/"
  url "https://github.com/gittuf/gittuf/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "be7bc642a31a266a06518ef16b20a3102e45f948a0b7888b8a2d376b1ec377ca"
  license "Apache-2.0"
  head "https://github.com/gittuf/gittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4909f373978f423fc2e5dc45d457495666977e9443b2ed229834d1f194d1c1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4909f373978f423fc2e5dc45d457495666977e9443b2ed229834d1f194d1c1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4909f373978f423fc2e5dc45d457495666977e9443b2ed229834d1f194d1c1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7eecef3d105df5420fccab2a468f12b8aad7a6ce090c94dec26b507a337189d0"
    sha256 cellar: :any_skip_relocation, ventura:       "51ff8c2e0a7f60a87f85671bf9a45bdd27e6a62db7fe4551c9a379b3837e0cb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d1be885c848a361d78691f48b999459865c3d67bad76c8b7c83392e5cc2553e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/gittuf/gittuf/internal/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gittuf", "completion")
  end

  test do
    output = shell_output("#{bin}/gittuf policy init 2>&1", 1)
    assert_match "Error: required flag \"signing-key\" not set", output unless OS.linux?

    output = shell_output("#{bin}/gittuf sync 2>&1", 1)
    assert_match "Error: unable to identify git directory for repository", output

    assert_match version.to_s, shell_output("#{bin}/gittuf version")
  end
end
