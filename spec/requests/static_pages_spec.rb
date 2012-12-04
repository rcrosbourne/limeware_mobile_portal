require 'spec_helper'

describe "Static Pages" do
  
  describe "Home Page" do
  	it "should have content 'LIME Mobile Portal'" do
		visit root_path
		page.should have_content("LIME Mobile Portal")  		
  	end
  	it "should have link with content 'Sign In" do
  		visit root_path
  		page.should have_link("Sign In", :href => "#"  )
  	end
  end

end