require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php70Sodium < AbstractPhp70Extension
  init
  desc "Modern and easy-to-use crypto library"
  homepage "https://github.com/jedisct1/libsodium-php"
  url "https://github.com/jedisct1/libsodium-php/archive/2.0.10.tar.gz"
  sha256 "2eebf3772d7441449b47abfe8f52043b9c6d6b5aff66aebd339c5d459d7fca28"
  head "https://github.com/jedisct1/libsodium-php.git"

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php70"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a721184d916af38fdd315dd240c3d2f05bc7657848b557394c01a4bb047007e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd88fa262697e8fb0b8c216457e649368e2f889110af9bfa9c599e24a295beb0"
    sha256 cellar: :any_skip_relocation, ventura:       "bd1938aaa9d0374be6a40dd9aa06ef0af06fe597839b4c3d11f5a160c938b9f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39a747da45038472515d154e03070b73feb8f85a9b2c04000a11c9146e492c25"
  end

  depends_on "libsodium"

  def install
    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                              "--with-sodium=#{Formula['libsodium'].opt_prefix}",
                              phpconfig,
                              "--disable-dependency-tracking"
    system "make"
    prefix.install "modules/sodium.so"
    write_config_file if build.with? "config-file"
  end
end
