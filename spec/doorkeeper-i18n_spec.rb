require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

Dir.glob('rails/locales/*.yml').each do |locale_file|
  describe "a doorkeeper-i18n #{locale_file} locale file" do
    it_behaves_like 'a valid locale file', locale_file
    it { expect(locale_file).to be_a_subset_of 'rails/locales/en.yml' }
    it { expect('rails/locales/en.yml').to be_a_subset_of locale_file }

    # A word that mixes Latin, Cyrillic and Greek letters is a typo: a lookalike
    # letter (Latin "i" for Cyrillic "і") was typed with the wrong keyboard layout.
    it 'has no words that mix letters from different alphabets' do
      scripts = [/\p{Latin}/, /\p{Cyrillic}/, /\p{Greek}/]
      words = File.read(locale_file, encoding: 'UTF-8').scan(/[\p{L}\p{M}]+/)
      mixed = words.select { |word| scripts.count { |script| word.match?(script) } > 1 }
      expect(mixed).to be_empty
    end
  end
end
