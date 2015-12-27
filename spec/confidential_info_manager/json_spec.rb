# coding: utf-8

require "spec_helper"

describe ConfidentialInfoManager::JSON do

  shared_examples_for "encrypt and decrypt" do
    it "encrypt and decrypt" do
      confidential_info_manager = described_class.new(password, salt)
      encrypted_data = confidential_info_manager.encrypt_only_value(raw_data)
      expect(raw_data.keys).to eq(encrypted_data.keys)
      decrypted_data = confidential_info_manager.decrypt_only_value(encrypted_data)
      expect(raw_data).to eq(decrypted_data)
    end
  end

  context "secret string data encrypt and decrypt" do
    let!(:password) { "pass" }
    let!(:salt) { described_class.generate_salt }
    let!(:raw_data) { { API_KEY: "aaaaa", API_SECRET_KEY: "bbbbb"} }
    let!(:type) { Hash }
    it_should_behave_like "encrypt and decrypt"
  end

  context "save to JSON, read" do
    let!(:secret_data) { { API_KEY: "abcedefg", API_SECRET_KEY: "abcedfg"} }
    let!(:file_path) { File.join(File.dirname(File.expand_path(__FILE__)), "secret_data.json") }
    let!(:salt) { "abcdefg" }
    let!(:pass) { "pass" }

    after(:all) do
      File.delete(File.join(File.dirname(File.expand_path(__FILE__)), "secret_data.json"))
    end

    it "saving the encrypted data in JSON format" do
      confidential_info_manager = described_class.new(pass, salt)
      confidential_info_manager.save(secret_data, file_path)
      expect(File).to exist(file_path)
    end

    it "reads the load encrypted JSON file, decryption" do
      confidential_info_manager = described_class.new(pass, salt)
      yaml_data = confidential_info_manager.load(file_path)
      expect(yaml_data).to eq(secret_data)
    end

  end

end
