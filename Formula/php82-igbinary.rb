require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php82Igbinary < AbstractPhp82Extension
  init
  desc "Igbinary is a replacement for the standard php serializer."
  homepage "https://pecl.php.net/package/igbinary"
  url "https://github.com/igbinary/igbinary/archive/3.2.14.tar.gz"
  sha256 "3dd62637667bee9328b3861c7dddc754a08ba95775d7b57573eadc5e39f95ac6"
  head "https://github.com/igbinary/igbinary.git"
  version "3.2.14"
  revision PHP_REVISION

  bottle do
    root_url "https://pub-7d898cd296ae4a92a616d2e2c17cdb9e.r2.dev/php/8.2.26-106"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e698a94855e1a003bc42dc055e70e4da8b11f3a8feb54a8e39593072d3895371"
    sha256 cellar: :any_skip_relocation, ventura:       "94ba07ceead71d1cb105b79a545e8bb62fcc6c2fa0ca3247159a7af7139fd702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e6b0555a4c07a476bc4a6481a48b8e47d21e8b2dbd769ecabaa74612b9e0142"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "27924b7dd611281f0abe8ffc2496ebdfbea23e25279690b50aa6f7282b9af184"
  end


  depends_on "igbinary" => :build

  def install
    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig
    system "make"
    prefix.install "modules/igbinary.so"
    write_config_file if build.with? "config-file"
  end

  def config_file
    super + <<~EOS
      ; Enable or disable compacting of duplicate strings
      ; The default is On.
      ;igbinary.compact_strings=On

      ; Use igbinary as session serializer
      ;session.serialize_handler=igbinary

      ; Use igbinary as APC serializer
      ;apc.serializer=igbinary
    EOS
  end
end
