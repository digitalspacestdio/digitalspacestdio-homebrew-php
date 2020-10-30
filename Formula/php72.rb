require File.expand_path("../../Abstract/abstract-php", __FILE__)

class Php72 < AbstractPhp
  init
  desc "PHP Version 7.2"
  include AbstractPhpVersion::Php72Defs
  version PHP_VERSION
  revision 1

  include AbstractPhpVersion::Php72Defs

  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]

  head PHP_GITHUB_URL, :branch => PHP_BRANCH

  def php_version
    "7.2"
  end

  def php_version_path
    "72"
  end

  if OS.mac?
    patch do
      url "https://raw.githubusercontent.com/djocker/homebrew-php/master/Patches/php72/macos.patch"
      sha256 "cf28218565c07b26d0764e903b24421b8095a6bbc68aded050b9fe0cc421729d"
    end
  end

  if OS.mac?
      patch do
        url "https://raw.githubusercontent.com/djocker/homebrew-php/master/Patches/php73/80171.patch"
        sha256 "4c51e35fd936a7f3f5613c72e6395b9afa8f569061c00849683e09e8fe986a0f"
      end
  end
end
