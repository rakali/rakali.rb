# encoding: UTF-8

module Rakali
  class Utils
    # This code was taken from Jekyll, available under MIT-LICENSE
    # Copyright (c) 2008-2014 Tom Preston-Werner
    # Merges a master hash with another hash, recursively.
    #
    # master_hash - the "parent" hash whose values will be overridden
    # other_hash  - the other hash whose values will be persisted after the merge
    #
    # This code was lovingly stolen from some random gem:
    # http://gemjack.com/gems/tartan-0.1.1/classes/Hash.html
    def self.deep_merge_hashes(master_hash, other_hash)
      target = master_hash.dup

      other_hash.keys.each do |key|
        if other_hash[key].is_a? Hash and target[key].is_a? Hash
          target[key] = deep_merge_hashes(target[key], other_hash[key])
          next
        end

        target[key] = other_hash[key]
      end

      target
    end
  end
end
