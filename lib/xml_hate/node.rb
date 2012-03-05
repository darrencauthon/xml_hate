module XmlHate
  class Node
    def initialize(hash)
      hash.each do |k,v|
        create_accessor_for k, clean_up_the_value(v) 
      end
    end

    def method_missing(meth, *args, &blk)
      meth.to_s == meth.to_s.pluralize ? [] : ""
    end

    private

    def create_accessor_for(k, v)
      self.instance_variable_set("@#{k}", v)
      self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})
      self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)}) 
    end

    def clean_up_the_value(value)
      return Node.new(value) if value.class == Hashie::Mash 
      return value.map {|i| i.class == Hashie::Mash ? Node.new(i) : i} if value.class == Array
      value
    end
  end
end
