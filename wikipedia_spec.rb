require 'wikipedia'

describe Wikipedia do
  it "should find backlinks for woodbridge" do
    Wikipedia.backlinks_for("Woodbridge_High_School_(London)").should == [{"pageid"=>451032, "title"=>"Woodford Green", "ns"=>0}, {"pageid"=>2083679, "title"=>"Woodbridge High School", "ns"=>0}, {"pageid"=>7094497, "title"=>"Woodbridge High School, Redbridge", "ns"=>0, "redirect"=>""}, {"pageid"=>16792267, "title"=>"List of schools in Redbridge", "ns"=>0}, {"pageid"=>27948808, "title"=>"The Skints", "ns"=>0}]
  end
  
  it "should find the categories for Suggs (singer)" do
    Wikipedia.categories_for("Suggs (singer)").should == ["Category:1961 births", "Category:All articles lacking sources", "Category:Anglo-Scots", "Category:Articles lacking reliable references from December 2008", "Category:BLP articles lacking sources from December 2008", "Category:British radio DJs", "Category:English male singers", "Category:English pop singers", "Category:English radio personalities", "Category:English songwriters", "Category:Former pupils of Quintin Kynaston School", "Category:Living people", "Category:Madness (band) members", "Category:People from Hastings", "Category:Ska musicians", "Category:Use dmy dates from August 2010", "Category:Virgin Radio (UK)"]
  end
  
  it "should correctly see if it's categories include the topic" do
    Wikipedia.stub!(:categories_for).with("The Skints").and_return ["Category:All articles with topics of unclear notability", "Category:Articles with topics of unclear notability from August 2010", "Category:English punk rock groups", "Category:Musical groups from London"]
    Wikipedia.is_associated_with?("The Skints", "music").should == true
  end
  
  it "should collect all correct results" do
    Wikipedia.stub!(:backlinks_for).with("Woodbridge_High_School_(London)").and_return  [{"pageid"=>451032, "title"=>"Woodford Green", "ns"=>0}, {"pageid"=>2083679, "title"=>"Woodbridge High School", "ns"=>0}, {"pageid"=>7094497, "title"=>"Woodbridge High School, Redbridge", "ns"=>0, "redirect"=>""}, {"pageid"=>16792267, "title"=>"List of schools in Redbridge", "ns"=>0}, {"pageid"=>27948808, "title"=>"The Skints", "ns"=>0}]
    Wikipedia.things_associated_with("Woodbridge_High_School_(London)", "music").should == ["The Skints"]
  end
  
  
  it "should find woodbridge from it's ofsted number" do
    Wikipedia.find_school_by_ofsted(102854).should == "Woodbridge High School (London)"
  end
  
  it "should not error if no school found from ofsted number" do
     Wikipedia.find_school_by_ofsted(102854345345345).should == nil
  end
end