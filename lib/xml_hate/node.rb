module XmlHate
  class Node
    def initialize(hash)
      hash.each do |k,v|
        v = clean_up_the_value(v)
        self.instance_variable_set("@#{k}", v)
        self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})
        self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)}) 
      end
    end

    def method_missing(meth, *args, &blk)
      meth.to_s == meth.to_s.pluralize ? [] : ""
    end

    private

    def clean_up_the_value(value)
      return Node.new(value) if value.class == Hashie::Mash 
      if value.class == Array
        new_values = []
        value.each do |i|
          new_values << (i.class == Hashie::Mash ? Node.new(i) : i)
        end
        return new_values
      end
      value
    end
  end
end
