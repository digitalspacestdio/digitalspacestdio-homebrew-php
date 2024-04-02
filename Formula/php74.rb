require File.expand_path("../../Abstract/abstract-php", __FILE__)

class Php74 < AbstractPhp
  include AbstractPhpVersion::Php74Defs
  init PHP_VERSION_MAJOR, PHP_VERSION, PHP_BRANCH_NUM
  desc "PHP " + PHP_VERSION
  version PHP_VERSION
  revision PHP_REVISION

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a61187d6ed04bdc54d8b684a9cc1dcecf4b828d81a6fb1588c68a8c8f990756b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "feeba360418ece0d716a1f8d24c52f6f7c5b2ea11c967ec647cf3031d675ebf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9331d789327ea6291383318f50ed9c902e573e192a57c31f22c88d7d0ab5014"
    sha256 cellar: :any_skip_relocation, monterey:      "907f0f9987178d0b002fed6e38c3306d50a0434315976642a1a06f87c3497585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2db7c3ada33ebbc0ed1b3d91c076febc75ff70c07d849988dedbfe9796b49cb6"
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
