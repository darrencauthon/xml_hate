require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe XmlHate::Document do


  describe "with a simple car xml block" do
    before do
      xml = <<DOC
<root>
<car>a car</car>
</root>
DOC
      @document = XmlHate::Document.new(xml)
    end
  
    it "should return an object for car" do
      @document.car.wont_be_nil  
    end

    it "should return il for anything else" do
      @document.blah.must_be_nil
      @document.something.must_be_nil
      @document.else.must_be_nil
    end
  end

  describe "with a simple truck xml block" do
    before do
      xml = <<DOC
<root>
<truck>a truck</truck>
</root>
DOC
      @document = XmlHate::Document.new(xml)
    end
  
    it "should return an object for car" do
      @document.truck.wont_be_nil  
    end

    it "should return il for anything else" do
      @document.car.must_be_nil
      @document.blah.must_be_nil
      @document.something.must_be_nil
      @document.else.must_be_nil
    end
  end
  
  describe "with a more complex boat xml block" do
    before do
      xml = <<DOC
<root>
<boat name="Bulstrode" type="Cargo">
  <attitude>grumpy</attitude>
  <location>The ocean</location>
  <episode>ep 10</episode>
  <episode>ep 11</episode>
  <narrator firstname="George" lastname="Carlin" />
</boat>
</root>
DOC
      @document = XmlHate::Document.new(xml)
    end
  
    it "should return Bulstrode as the name" do
      @document.boat.name.must_equal "Bulstrode"  
    end

    it "should return Cargo as the type" do
      @document.boat.type.must_equal "Cargo"  
    end

    it "should return attitude as grumpy" do
      @document.boat.attitude.must_equal "grumpy"  
    end

    it "should return location as the ocean" do
      @document.boat.location.must_equal "The ocean"  
    end

    it "should return both episodes" do
      @document.boat.episode.count.must_equal 2
      @document.boat.episode[0].must_equal "ep 10"
      @document.boat.episode[1].must_equal "ep 11"
    end

    it "should return all information about the narrator" do
      @document.boat.narrator.firstname.must_equal "George"
      @document.boat.narrator.lastname.must_equal "Carlin"
    end

  end
end
