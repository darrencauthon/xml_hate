module XmlHate

  class Node

    attr_reader :_keys

    def initialize(hash)
      @_keys = []
      all_items_in_the_hash_that_are_not_nil(hash).each do |k, v|
        @_keys << get_a_valid_property_name(k)
        form = convert_the_value_to_the_appropriate_form(v)
        if form.is_a?(Node)
          keys = form._keys.map { |x| x.to_s.singularize }.uniq
          if keys.count == 1 && form.send(keys.first.to_sym).is_a?(Array)
            form = form.send(keys.first.to_sym)
          end
        end
        create_accessor_for k, form
      end
    end

    def method_missing(meth, *args, &blk)
      an_empty_array_for_plurals_or_empty_string_for_singulars meth
    end

    def to_hash
      @_keys.reduce({}) { |t, i| t.merge(i => self.send(i) ) }
    end

    private

    def all_items_in_the_hash_that_are_not_nil(the_hash)
      the_hash.select{|k, v| !v.nil? }
    end

    def an_empty_array_for_plurals_or_empty_string_for_singulars(meth)
      return [] if meth.to_s == meth.to_s.pluralize

      empty_string = ''
      attempt_to_attach_content_singleton_to_the_value empty_string
      empty_string
    end

    def create_accessor_for(k, v)
      property_name = get_a_valid_property_name(k)
      self.instance_variable_set("@#{property_name}", v)
      self.instance_eval("
      class << self
        attr_accessor :#{property_name}
      end")
    end

    def get_a_valid_property_name(name)
      name = name.to_s.gsub('-', '_')
      name = name.gsub('@', '')
      name = name.gsub(':', '')
      name = name.underscore
      name.to_sym
    end

    def convert_the_value_to_the_appropriate_form(the_value)
      return Node.new(the_value) if the_value.class == Hashie::Mash 
      return the_value.map {|i| i.class == Hashie::Mash ? Node.new(i) : i} if the_value.class == Array
      attempt_to_attach_content_singleton_to_the_value the_value
      the_value
    end

    def attempt_to_attach_content_singleton_to_the_value(the_value)
      begin
        def the_value.content
          self
        end
      rescue
      end
    end

  end

end
