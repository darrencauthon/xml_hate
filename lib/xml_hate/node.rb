module XmlHate
  class Node
    def initialize(hash)
      hash.each do |k,v|
        v = Node.new(v) if v.class == Hashie::Mash 
        if v.class == Array
          new_values = []
          v.each do |i|
            new_values << (i.class == Hashie::Mash ? Node.new(i) : i)
          end
          v = new_values
        end
        self.instance_variable_set("@#{k}", v)
        self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})
        self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)}) 
      end
    end

    def method_missing(meth, *args, &blk)
      meth.to_s == meth.to_s.pluralize ? [] : ""
    end
  end
end
