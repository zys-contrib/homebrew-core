class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.56.2.tgz"
  sha256 "97895a6f81f50ac0ff6eda4c807453ac7fc4608de634d993f954743caf1a5cd9"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "ca14d09da7e11d7aaf2027fdd84f6adc9ae927571ff2166de4f59706f998cabb"
    sha256                               arm64_sonoma:  "15cfcda9a8f3c82e52534a38aa8e57261ce8ffa81acb70d958cb2e8931e5fcce"
    sha256                               arm64_ventura: "1f86a527a20110f740add2b8ac7c81c53640f78772f75d246dabd4b3cd42de5c"
    sha256                               sonoma:        "04ff44dc795864a97b0a31cbbb08472602128abda0ed32895ad21871e9af832d"
    sha256                               ventura:       "e22d302bca0c2b914cce6a782332069e93dd65b67919a12e6f5f88e3bd9365f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8906bfbb324726b7a03bb8c4f760dabe575fd824946e10d0bcaf5865f06e7755"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".gitlab-ci.yml").write <<~YML
      ---
      stages:
        - build
        - tag
      variables:
        HELLO: world
      build:
        stage: build
        needs: []
        tags:
          - shared-docker
        script:
          - echo "HELLO"
      tag-docker-image:
        stage: tag
        needs: [ build ]
        tags:
          - shared-docker
        script:
          - echo $HELLO
    YML

    system "git", "init"
    system "git", "add", ".gitlab-ci.yml"
    system "git", "commit", "-m", "'some message'"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    rm ".git/config"

    (testpath/".git/config").write <<~EOS
      [core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
        ignorecase = true
        precomposeunicode = true
      [remote "origin"]
        url = git@github.com:firecow/gitlab-ci-local.git
        fetch = +refs/heads/*:refs/remotes/origin/*
      [branch "master"]
        remote = origin
        merge = refs/heads/master
    EOS

    assert_match(/name\s*?description\s*?stage\s*?when\s*?allow_failure\s*?needs\n/,
        shell_output("#{bin}/gitlab-ci-local --list"))
  end
end
