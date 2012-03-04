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

    it "should return empty string for anything else" do
      @document.blah.must_equal ""
      @document.something.must_equal ""
      @document.else.must_equal ""
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

    it "should return empty string for anything else" do
      @document.car.must_equal ""
      @document.blah.must_equal ""
      @document.something.must_equal ""
      @document.else.must_equal ""
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
      @document.boat.locations.count.must_equal 1  
    end
    
    it "should return locations" do
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

  describe "with an even more complex movie xml block" do
    before do
      xml = <<DOC
<root>
  <movie name="Deep Impact">
    <actor name="Morgan Freeman" gender="Male" />
    <actor name="Tea Leoni" gender="Female" />
    <actor name="Elijah Wood" gender="Male">
      <movie name="Lord of the Rings 1" />
      <movie name="Lord of the Rings 2">
        <actor name="Sean Astin" />
        <year>2004</year>
      </movie>
    </actor>
  </movie>
</root>
DOC
      @document = XmlHate::Document.new(xml)
    end

    it "should have a movie element" do
      @document.movie.must_not_be_nil 
    end

    it "should have three actors" do
      @document.movie.actor.count.must_equal 3
    end

    it "should be able to pull acotrs out with plural property" do
      @document.movie.actors.count.must_equal 3 
    end

    it "should have two other movies on the third actor" do
      @document.movie.actor[2].movie.count.must_equal 2  
    end

    it "should be able to pull the actor deep down the chain" do
      @document.movie.actor[2].movie[1].actor.name.must_equal "Sean Astin"
    end

    it "should be able to pull the year deep down the chain" do
      @document.movie.actor[2].movie[1].year.must_equal "2004"
    end

    it "should maintain years as an array deep down the list" do
      @document.movie.actor[2].movie[1].years.count.must_equal 1
      @document.movie.actor[2].movie[1].years[0].must_equal "2004" 
    end
  end


  describe "another xml example" do
    before do
      xml = <<DOC
<root>
  <product_group>
    <name>A product group</name>
    <listofgroup></listofgroup>
    <listofgroup>
      <product_group id="100"></product_group>
      <product_group id="3">
        <name>Another product group</name>
      </product_group>
    </listofgroup>
  </product_group>
</root>
DOC
      @document = XmlHate::Document.new(xml)
    end

    it "should have data" do

    end

  end
end
