require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe XmlHate::Node do
  describe "creating a node with a simple node" do
    before do
      @object = XmlHate::Node.new({:firstname => "John", :lastname => "Carter" })
    end

    it "should respond to first name" do
      @object.respond_to?(:firstname).must_equal true 
    end

    it "should respond to last name" do
      @object.respond_to?(:lastname).must_equal true 
    end

    it "should not respond to other things" do
      @object.respond_to?(:something).must_equal false 
      @object.respond_to?(:else).must_equal false 
    end

    it "should return the first name" do
      @object.firstname.must_equal "John" 
    end
  
    it "should return the last name" do
      @object.lastname.must_equal "Carter" 
    end

    it "should return an empty string for a singular name" do
      @object.cat.must_equal "" 
      @object.dog.must_equal ""
    end

    it "should return an empty array for plural names" do
      @object.cats.must_equal []
      @object.dogs.must_equal []
    end
  end

  describe "creating a node with a child Hashie::Match" do
    before do
      @object = XmlHate::Node.new({:thing => Hashie::Mash.new({:firstname => "John", :lastname => "Carter" })})
    end

    it "should return a node object for thing" do
      @object.thing.class.must_equal XmlHate::Node 
    end

  end

  describe "creating a node with an Array" do
    before do
      @object = XmlHate::Node.new({:thing => [Hashie::Mash.new(), "test"]})
    end

    it "should return a node object for the first item" do
      @object.thing[0].class.must_equal XmlHate::Node 
    end

    it "should return a string for the second item" do
      @object.thing[1].class.must_equal String 
    end
  end

  describe "creating a node will create attributes for single instances of node" do
    before do
      @object1 = XmlHate::Node.new({:first_name => "Tyrone", :last_name => "Groves"})
      @object2 = XmlHate::Node.new({:customer_id => 23})
    end

    it "should not respond to first name" do
      @object2.respond_to?(:first_name).must_equal false
    end

    it "should not respond to last name" do
      @object2.respond_to?(:last_name).must_equal false
    end
  end

  describe "passing nil values as strings and sets" do
    before do
      @object = XmlHate::Node.new({:person => nil, :products => nil})
    end

    it "should return an empty string for the singular value" do
      @object.person.must_equal ""
    end

    it "should return an empty set for the plural value" do
      @object.products.must_equal []
    end
  end

  describe "using .content to access string values" do
    before do
      @object = XmlHate::Node.new({:firstname => "Ellis", :lastname => "Wyatt"})
    end

    it "should return strings for the first and last names" do
      @object.firstname.must_equal "Ellis"
      @object.lastname.must_equal "Wyatt"
    end

    it "should allow me to access the value for the string using .content as well" do
      @object.firstname.content.must_equal "Ellis"
      @object.lastname.content.must_equal "Wyatt"
    end

    it "should allow me to access the nonexistent values using .content" do
      @object.something_else.content.must_equal "" 
    end
  end

  describe "passing a key with dashes" do
    before do
      @object = XmlHate::Node.new({:"test-this" => "ok"})
    end

    it "should replace the dash with an underscore" do
      @object.test_this.must_equal "ok"
    end
  end
end
