require File.expand_path("../../Abstract/abstract-php", __FILE__)

class Php71 < AbstractPhp
  include AbstractPhpVersion::Php71Defs
  init PHP_VERSION_MAJOR, PHP_VERSION, PHP_BRANCH_NUM
  desc "PHP " + PHP_VERSION
  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]
  head PHP_GITHUB_URL, :branch => PHP_BRANCH
  
  version PHP_VERSION
  revision PHP_REVISION

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ebe231b0e2b3e0dde115cab597f74865aca846489bd023906779677aa4ebb3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d0345a82c060eb99ad3461486c10b59edab2b196ae8993b05afbc316a2a8789"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b5f531930474c870bfabb53da0588276ac58a8686090a2c0e64624097466b28"
    sha256 cellar: :any_skip_relocation, monterey:      "b65f4013c38d52b5308f8fa430006d2d7097f2d6beaf0ec0281017edb19ab25e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "652527002eba50a0d7a5b039dfe57f80e215e4b6ff31de0934c5320c1568a8a6"
  end

  keg_only :versioned_formula

  def php_version
    "#{PHP_VERSION_MAJOR}"
  end

  def php_version_path
    "#{PHP_BRANCH_NUM}"
  end

  def config_path
    etc + "php" + php_version
  end

  if OS.mac?
    patch do
      url "https://raw.githubusercontent.com/digitalspacestdio/homebrew-php/master/Patches/php72/macos.patch"
      sha256 "cf28218565c07b26d0764e903b24421b8095a6bbc68aded050b9fe0cc421729d"
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
