require File.expand_path("../../Abstract/abstract-php", __FILE__)

class Php74 < AbstractPhp
  include AbstractPhpVersion::Php74Defs
  init PHP_VERSION_MAJOR, PHP_VERSION, PHP_BRANCH_NUM
  desc "PHP " + PHP_VERSION
  version PHP_VERSION
  revision PHP_REVISION

  bottle do
    root_url "https://l2i5.c19.e2-3.dev/homebrew/php/7.4.33-104"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f487cfdc46b1a1702480016a581a550dfebcad4d034172f3f1a986cb89178a4"
    sha256 cellar: :any_skip_relocation, monterey:       "6e9e928182ade5e4c5f80bbba4f3960649c60a3a4ff368498f7386e1dc6f4da5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "391abea2fdf83c828ef456996872e3697fd2ec27bd96c184054261f9860b86b4"
    sha256 cellar: :any_skip_relocation, aarch64_linux:  "b97c9d4cc0ff646100c19eca8031f188580a50ed219391cd62525eb4bb654e72"
  end
  
  keg_only :versioned_formula

  def php_version
    "#{PHP_VERSION_MAJOR}"
  end

  def php_version_path
    "#{PHP_BRANCH_NUM}"
  end
  
  depends_on "pkg-config" => :build
  depends_on "krb5"
  depends_on "oniguruma"
  depends_on "libjpeg"

  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]

  head PHP_GITHUB_URL, :branch => PHP_BRANCH

  def install_args
    args = super
    if !build.without? "pear"
      args << "--with-pear"
    end
    args
  end

  if OS.mac?
      patch do
        url "https://raw.githubusercontent.com/digitalspacestdio/homebrew-php/master/Patches/php74/macos.patch"
        sha256 "53de4079666daabac28358b8a025e3c60103e5b1230c66860c8e0b7414c0fec1"
      end
  end

  service do
    name macos: "php#{PHP_VERSION_MAJOR}-fpm", linux: "php#{PHP_VERSION_MAJOR}-fpm"
    run [opt_sbin/"php-fpm", "--nodaemonize", "--fpm-config", "#{etc}/php/#{PHP_VERSION_MAJOR}/php-fpm.conf"]
    working_dir HOMEBREW_PREFIX
    keep_alive true
    require_root false
    log_path var/"log/service-php-#{PHP_VERSION_MAJOR}.log"
    error_log_path var/"log/service-php-#{PHP_VERSION_MAJOR}-error.log"
  end
end
