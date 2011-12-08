require "constantine/version"
require 'constantine/railtie' if defined?(Rails)

module Constantine
  extend self

  def constantize(word)
    modules = []
    variations(split(word)) { |m| modules << m }
    modules.uniq.each do |potential_name|
      names = potential_name.split('::')
      names.shift if names.empty? || names.first.empty?
      constant = Object
      names.each do |name|
        if constant.const_defined?(name)
          constant = constant.const_get(name) 
        end
        if constant.respond_to?(:name) && constant.name == potential_name
          return constant
        end
      end
    end
    # No match was guessed, start over, without the magic
    constant = Object
    word.split('::').reject { |n| n.empty? }.each do |name|
      if constant.const_defined?(name)
        constant = constant.const_get(name)
      else
        constant.const_missing(name)
      end
    end
    constant
  end

  private

  def variations(words, prefix = [], &block)
    (words.length-1).downto(0).each do |count|
      pre = words[0..count].join("")
      post = words[count+1..words.length-1]
      yield [prefix + [pre], post].reject(&:empty?).join("::")
      variations(post, prefix + [pre], &block)
    end
  end

  def split(word)
    word = word.dup
    word.gsub!(/([A-Z]+)([A-Z][a-z])/, '\1 \2')
    word.gsub!(/([a-z\d])([A-Z])/, '\1 \2')
    word.split(" ")
  end

  module Support

    def constantize(word)
      Constantine.constantize(word)
    end
  end
end
