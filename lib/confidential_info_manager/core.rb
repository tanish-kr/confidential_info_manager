# coding: utf-8

module ConfidentialInfoManager

  ##
  # Condidential info manager core class
  # @author tatsunori nishikori <tora.1986.tatsu@gmail.com>
  class Core

    RANDOM_BYTES = 8.freeze
    ITERATOR_COUNT = 2000.freeze
    DEFAULT_ALGORITHM = "AES-256-CBC".freeze

    ##
    # constructor
    # @param [String] password
    # @param [String] salt
    # @param [String] mode
    # @see http://docs.ruby-lang.org/en/2.2.0/OpenSSL/Cipher.html
    def initialize(password, mode = DEFAULT_ALGORITHM, iterator_cnt = ITERATOR_COUNT)
      raise ArgmentError.new("Password is empty") if password.empty?
      raise ArgmentError.new("Mode is empty") if mode.empty?
      raise ArgmentError.new("You must specify an integer of 1 or more") if iterator_cnt <= 0

      @iterator_cnt = iterator_cnt
      @password = password
      @mode = mode
    end

    ##
    # encrypt
    # @param [Object] secret data
    # @return [String] encrypted data
    def encrypt(secret_data)
      # convert string
      case secret_data
        when Numeric
          secret_data = secret_data.to_s
        when Hash, Array
          secret_data = Marshal.dump(secret_data)
      end

      salt = OpenSSL::Random.random_bytes(RANDOM_BYTES)
      encrypter = generate_cipher
      encrypter.encrypt
      encrypter.pkcs5_keyivgen(@password, salt, @iterator_cnt)
      encrypted_data = ""
      encrypted_data << encrypter.update(secret_data)
      encrypted_data << encrypter.final
      Base64.strict_encode64("Salted__#{salt}#{encrypted_data}")
    end

    ##
    # decrypt
    # @param [String] encrypted data
    # @param [Class] type
    #   @note String/Fixnum/Bignum/Float/Array/Hash
    # @return [Object] decrypted data
    def decrypt(encrypted_data, type = String)
      encrypted_data = Base64.strict_decode64(encrypted_data)
      salt = encrypted_data[8, RANDOM_BYTES]

      encrypted_data = encrypted_data[8 + RANDOM_BYTES, encrypted_data.size]

      decrypter = generate_cipher
      decrypter.decrypt
      decrypter.pkcs5_keyivgen(@password, salt, @iterator_cnt)
      decrypted_data = ""
      decrypted_data << decrypter.update(encrypted_data)
      decrypted_data << decrypter.final

      if type == Fixnum || type == Bignum
        decrypted_data = decrypted_data.to_i
      elsif type == Float
        decrypted_data = decrypted_data.to_f
      elsif type == Array || type == Hash
        decrypted_data = Marshal.load(decrypted_data)
      end
      decrypted_data
    end

    ##
    # encrypt only value
    # @param [Object] secret_data
    #   @note Object is allowed an Hash or Array
    # @return [Object] encrypted data
    #   @note Array/Hash
    def encrypt_only_value(secret_data)
      case secret_data
        when Hash
          Hash[secret_data.map { |key, val| [key, encrypt(val)] }]
        when Array
          secret_data.map { |val| encrypt(val) }
        else
          encrypt(secret_data)
      end
    end

    ##
    # decrypt only value
    # @param [Object] encrypted_data
    #   @note Object is allowed an Hash or Array
    # @return [Object] decrypted data
    #   @note Array/Hash
    def decrypt_only_value(encrypted_data)
      case encrypted_data
        when Hash
          Hash[encrypted_data.map { |key, val| [key, decrypt(val)] }]
        when Array
          encrypted_data.map { |val| decrypt(val) }
        else
          decrypt(encrypted_data)
      end
    end

private

    ##
    # generate cipher instance
    # @return [OpenSSL::Cipher] cipher
    def generate_cipher
      cipher = OpenSSL::Cipher.new(@mode)
      cipher.reset
    end

  end

end
